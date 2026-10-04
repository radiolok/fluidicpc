"""Потактовое Python-зеркало высокоуровневого RTL (rtl/fluidic_calc_rtl.v).

Те же уравнения, что в RTL, построчно. compare_with_netlist() гоняет зеркало и вентильную
модель одними нажатиями и сверяет табло и знак после каждого такта машины.

Запуск: python3 rtl_model.py [число случайных примеров]
"""
import json
import random
import sys
from pathlib import Path

from glyphs import G, CLASSES

HERE = Path(__file__).resolve().parent
W = json.load(open(HERE / 'weights.json'))
CARE = {c: sum(1 << i for i in W[c]) for c in CLASSES}
VAL = {c: sum(G[c][i] << i for i in W[c]) for c in CLASSES}
SEG = {0: 'abcdef', 1: 'bc', 2: 'abdeg', 3: 'abcdg', 4: 'bcfg', 5: 'acdfg', 6: 'acdefg', 7: 'abc', 8: 'abcdefg', 9: 'abcdfg'}
SEGCODE = {d: sum(1 << 'abcdefg'.index(s) for s in v) for d, v in SEG.items()}


def bits_to_int(bits):
    return sum(b << i for i, b in enumerate(bits))


class RTL:
    def __init__(s):
        s.s1 = s.s2 = s.run = s.neg = s.show = 0
        s.X = [0, 0]            # BCD digits: [units, tens]
        s.Y = [0, 0]
        s.R = [0, 0, 0, 0]      # units .. thousands
        s.op_sub = s.op_mul = 0
        s.sgn = 0

    @staticmethod
    def recognize(pix):
        return {c: int(bin((pix ^ VAL[c]) & CARE[c]).count('1') <= 1) for c in CLASSES}

    def cycle(s, pix, btn):
        k = s.recognize(pix)
        d = [k[str(i)] for i in range(10)]
        key_bcd = ((d[1] | d[3] | d[5] | d[7] | d[9]) | (d[2] | d[3] | d[6] | d[7]) << 1 |
                   (d[4] | d[5] | d[6] | d[7]) << 2 | (d[8] | d[9]) << 3)
        is_digit = int(any(d))
        is_op = k['+'] | k['-'] | k['x']

        pulse = s.s1 & (1 - s.s2)
        act = pulse & (1 - (s.run | s.neg))
        ev_digit = act & is_digit
        ev_op = act & is_op & (1 - s.show)
        ev_eq = act & k['='] & (1 - s.show)
        ev_clr = act & k['C']
        ev_fresh = ev_digit & s.show
        ev_clr_all = ev_clr | ev_fresh

        x_nz = int(s.X != [0, 0])
        run_step = s.run & x_nz
        eq_addsub = ev_eq & (1 - s.op_mul)
        eq_sub = ev_eq & s.op_sub
        sub = eq_sub | s.neg
        sel_x = (ev_op & (1 - k['x'])) | eq_addsub
        sel_y = run_step
        sel_r = s.neg
        keep_r = 1 - (ev_op | s.neg | ev_clr_all)

        # операнд B: выбранный регистр, при вычитании — дополнение до 9
        pack = lambda dg: dg[0] | dg[1] << 4
        b = (pack(s.X) if sel_x else 0) | (pack(s.Y) if sel_y else 0) | (pack(s.R[:2]) if sel_r else 0)
        bd = [b & 15, b >> 4]
        if sub: bd = [9 - bd[0], 9 - bd[1]]
        a = s.R if keep_r else [0, 0, 0, 0]
        t0 = a[0] + bd[0] + sub; c1 = int(t0 > 9); s0 = t0 - 10 if c1 else t0
        t1 = a[1] + bd[1] + c1;  c2 = int(t1 > 9); s1_ = t1 - 10 if c2 else t1
        c2_hi = c2 & (1 - sub)
        t2 = a[2] + c2_hi; c3 = int(t2 > 9); s2_ = 0 if c3 else t2
        t3 = a[3] + c3; s3_ = 0 if t3 > 9 else t3
        alu = [s0, s1_, s2_, s3_]

        en_r = ev_op | eq_addsub | run_step | s.neg | ev_clr_all
        en_x = ev_digit | ev_op | ev_clr | run_step
        ld_op = ev_op | ev_clr_all

        x_val = s.X[0] + 10 * s.X[1]
        if en_x:
            if ev_digit: xn = [key_bcd, 0 if s.show else s.X[0]]
            elif run_step: v = x_val - 1; xn = [v % 10, v // 10]
            else: xn = [0, 0]
        else: xn = list(s.X)
        yn = list(s.X) if ev_op else list(s.Y)
        opn = (k['-'], k['x']) if ld_op else (s.op_sub, s.op_mul)
        sgn_n = 1 if s.neg else 0 if (ev_op | ev_clr_all) else s.sgn
        run_n = (ev_eq & s.op_mul) | run_step
        neg_n = eq_sub & (1 - c2)
        show_n = (s.show & (1 - (ev_digit | ev_clr))) | (ev_eq & (1 - (eq_sub & (1 - c2)))) | s.neg
        rn = alu if en_r else list(s.R)

        s.s1, s.s2 = btn, s.s1
        s.run, s.neg, s.show = run_n, neg_n, show_n
        s.X, s.Y, s.R = xn, yn, rn
        s.op_sub, s.op_mul = opn
        s.sgn = sgn_n

    def display(s):
        lo = s.R[:2] if s.show else s.X
        nz3, nz2 = s.R[3] != 0, s.R[2] != 0
        en3 = s.show and nz3
        en2 = s.show and (nz3 or nz2)
        en1 = en2 or lo[1] != 0
        digits = [lo[0], lo[1], s.R[2], s.R[3]]
        ens = [True, en1, en2, en3]
        return tuple(SEGCODE[dg] if en else 0 for dg, en in zip(digits, ens)), s.sgn


def compare_with_netlist(nrand=100, seed=7):
    from calc_netlist import build
    from sim import Machine
    n, out = build(gen=True); n.compile()
    pix_of = {}
    for kk, _ in n.keys:
        i = (int(kk[4]) - 1) * 5 + int(kk[6]) - 1
        pix_of[kk] = (i, 0); pix_of[kk + '_n'] = (i, 1)
    m = Machine(n, out['segs'], out['sign'], pix_of)
    r = RTL()
    for _ in range(3): r.cycle(0, 0)                      # Machine.__init__ ran 3 idle cycles
    def net_disp():
        return tuple(sum(m.n.v[out['segs'][f'd{k}'][sg]] << j for j, sg in enumerate('abcdefg')) for k in range(4)), m.n.v[out['sign']]
    mism, cycles = 0, 0
    def step(bits, btn):
        nonlocal mism, cycles
        m.setpix(bits); m.clock(btn); r.cycle(bits_to_int(bits), btn); cycles += 1
        if net_disp() != r.display() or m.n.v[m.run] != r.run or m.n.v[m.neg] != r.neg:
            mism += 1
    def press(ch, noise=None):
        bits = list(G[ch])
        if noise is not None: bits[noise] ^= 1
        for _ in range(3): step(bits, 1)
        step([0] * 35, 0)
        while r.run or r.neg: step([0] * 35, 0)
        step([0] * 35, 0)
    rng = random.Random(seed)
    for t in range(nrand):
        a, b, o = rng.randrange(100), rng.randrange(100), rng.choice('+-x')
        noisy = t % 2 == 1
        for ch in f'C{a}{o}{b}=':
            press(ch, rng.randrange(35) if noisy else None)
    return mism, cycles


if __name__ == '__main__':
    nr = int(sys.argv[1]) if len(sys.argv) > 1 else 100
    mism, cycles = compare_with_netlist(nr)
    print(f'RTL-зеркало и вентильная модель: {nr} примеров (половина с ошибкой пикселя), '
          f'{cycles} тактов, расхождений {mism}')
    sys.exit(1 if mism else 0)
