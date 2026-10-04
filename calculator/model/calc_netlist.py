"""Струйный калькулятор: эталонная вентильная модель.

Вход — матрица трубочек 5×7, выход — четыре семисегментных индикатора и блинкер знака.
build() строит нетлист на элементах 2И/2ИЛИ/2ИЛИ-НЕ/2искл.ИЛИ, ячейках памяти и ключах.
"""
import json
from pathlib import Path
from netlist import NL
from glyphs import G, CLASSES, pname

HERE = Path(__file__).resolve().parent
SEL = {c: v for c, v in json.load(open(HERE / 'weights.json')).items()}

def build(gen=False):
    n = NL()
    n.names = {}
    def nm(net, name):
        if net not in ('0', '1') and net not in n.names: n.names[net] = name
        return net
    PH1, PH2, PH3 = n.inp('PH1'), n.inp('PH2'), n.inp('PH3')
    BTN = n.inp('BTN')

    # ---------------- input keys ----------------
    n.block = '1 Входные ключи'
    used = sorted({i for c in CLASSES for i in SEL[c]})
    key = {i: n.key('px_' + pname(i)) for i in used}

    # ---------------- recognizer (15 neurons) ----------------
    n.block = '2 Распознаватель'
    cls = {}
    for c in CLASSES:
        lits = [key[i][0] if G[c][i] else key[i][1] for i in SEL[c]]
        A, B = n.AND(lits[0], lits[1]), n.OR(lits[0], lits[1])
        for j, l in enumerate(lits[2:]):
            last = (j == len(lits) - 3)
            Bn = n.OR(n.AND(B, l), A)
            if not last: A = n.AND(A, l)
            B = Bn
        cls[c] = nm(B, 'cls_' + {'+': 'plus', '-': 'minus', 'x': 'mul', '=': 'eq', 'C': 'clr'}.get(c, c))

    # ---------------- encoder ----------------
    n.block = '3 Шифратор'
    d = [cls[str(i)] for i in range(10)]
    kb = [n.ORn([d[1], d[3], d[5], d[7], d[9]]), n.ORn([d[2], d[3], d[6], d[7]]),
          n.ORn([d[4], d[5], d[6], d[7]]), n.OR(d[8], d[9])]
    for i in range(4): nm(kb[i], f'key_bcd{i}')
    isDigit = nm(n.OR(n.ORn(kb), d[0]), 'is_digit')
    kPlus, kMinus, kMul, kEq, kC = cls['+'], cls['-'], cls['x'], cls['='], cls['C']
    isOp = nm(n.OR(n.OR(kPlus, kMinus), kMul), 'is_op')

    # ---------------- register helpers ----------------
    def ms_reg(name, width):
        """master-slave register; returns (Q list, QN list, connect(D, en))"""
        Q, QN, M = [], [], []
        for i in range(width):
            M.append(n.cell(f'{name}{i}_m'))
            q, qn = n.cell(f'{name}{i}')
            Q.append(q); QN.append(qn)
        def connect(D, en):
            mclr, mset = n.AND(PH1, en), n.AND(PH2, en)
            for i in range(width):
                n.connect(f'{name}{i}_m', n.AND(D[i], mset), mclr)
                n.connect(f'{name}{i}', n.AND(M[i][0], PH3), n.AND(M[i][1], PH3))
        return Q, QN, connect

    def latch(name, width):
        Q, QN = [], []
        for i in range(width):
            q, qn = n.cell(f'{name}{i}'); Q.append(q); QN.append(qn)
        def connect(D, ld, clr_only=None):
            R, S = n.AND(PH1, ld), n.AND(PH2, ld)
            for i in range(width):
                n.connect(f'{name}{i}', n.AND(D[i], S), R)
        return Q, QN, connect

    # ---------------- control state ----------------
    n.block = '6 Управление'
    (s1,), (s1n,), s1c = ms_reg('sync1_', 1)
    (s2,), (s2n,), s2c = ms_reg('sync2_', 1)
    (run,), (runn,), runc = ms_reg('run', 1)
    (neg,), (negn,), negc = ms_reg('neg', 1)
    (show,), (shown,), showc = ms_reg('show', 1)

    n.block = '5 Регистры'
    X, XN, Xc = ms_reg('X', 8)         # entry register, 2 BCD digits (X[0:4] units)
    R, RN, Rc = ms_reg('R', 16)        # result / accumulator, 4 BCD digits
    Y, YN, Yc = latch('Y', 8)          # first operand
    OP, OPN, OPc = latch('OP', 2)      # OP[0]=sub, OP[1]=mul
    (sgn,), (sgnn,), sgnc = latch('SGN', 1)

    n.block = '6 Управление'
    s1c([BTN], '1'); s2c([s1], '1')
    pulse = nm(n.AND(s1, s2n), 'key_pulse')
    act = nm(n.AND(pulse, n.NOR(run, neg)), 'key_act')
    digitP = nm(n.AND(act, isDigit), 'ev_digit')
    opP = nm(n.AND(n.AND(act, isOp), shown), 'ev_op')
    eqP = nm(n.AND(n.AND(act, kEq), shown), 'ev_eq')
    clrP = nm(n.AND(act, kC), 'ev_clr')
    fresh = nm(n.AND(digitP, show), 'ev_fresh')                 # digit after a result starts over
    clrAll = nm(n.OR(clrP, fresh), 'ev_clr_all')
    opSub, opMul = OP[0], OP[1]
    opMuln = OPN[1]

    n.block = '4f Декремент X, X=0'
    # zero detect of X and decrementer
    nzX = nm(n.ORn(X), 'x_nonzero')
    zX = n.NOT(nzX)
    n.block = '6 Управление'
    runStep = nm(n.AND(run, nzX), 'run_step')
    eqNM = n.AND(eqP, opMuln)                   # '=' for + and -
    eqNM = nm(eqNM, 'ev_eq_addsub')
    eqSub = nm(n.AND(eqP, opSub), 'ev_eq_sub')
    sub = nm(n.OR(eqSub, neg), 'alu_sub')
    selX = nm(n.OR(n.AND(opP, n.NOT(kMul)), eqNM), 'sel_x')
    selY = runStep
    selR = neg
    zeroA = n.OR(n.OR(opP, neg), clrAll)
    keep = nm(n.NOT(zeroA), 'alu_keep_r')
    enR = nm(n.OR(n.OR(n.OR(opP, eqNM), n.OR(runStep, neg)), clrAll), 'en_r')
    enX = nm(n.OR(n.OR(digitP, opP), n.OR(clrP, runStep)), 'en_x')
    ldOP = nm(n.OR(opP, clrAll), 'ld_op')
    nsub = nm(n.NOT(sub), 'alu_sub_n')

    # ---------------- ALU ----------------
    n.block = '4a Мультиплексор B'
    # operand B mux (2 digits)
    Bm = [n.OR(n.OR(n.AND(X[i], selX), n.AND(Y[i], selY)), n.AND(R[i], selR)) for i in range(8)]
    # 9's complement when sub
    def comp9(b):
        o = n.OR(n.OR(b[1], b[2]), b[3])
        return [n.XOR(b[0], sub), b[1], n.XOR(b[2], n.AND(b[1], sub)),
                n.OR(n.AND(b[3], nsub), n.NOR(nsub, o))]
    n.block = '4b Дополнение до 9'
    for i in range(8): nm(Bm[i], f'alu_b{i}')
    Bc = comp9(Bm[0:4]) + comp9(Bm[4:8])
    for i in range(8): nm(Bc[i], f'alu_bc{i}')
    n.block = '4c Маска A'
    A = [nm(n.AND(R[i], keep), f'alu_a{i}') for i in range(16)]
    def FA(a, b, c):
        t = n.XOR(a, b)
        return n.XOR(t, c), n.OR(n.AND(a, b), n.AND(t, c))
    def bcd_add(a, b, cin):
        s, c = [], cin
        for i in range(4):
            si, c = FA(a[i], b[i], c); s.append(si)
        z = n.OR(c, n.AND(s[3], n.OR(s[2], s[1])))
        r1 = n.XOR(s[1], z); k1 = n.AND(s[1], z)
        r2, k2 = FA(s[2], z, k1)
        r3 = n.XOR(s[3], k2)
        return [s[0], r1, r2, r3], z
    n.block = '4d BCD-сумматор 2 разр.'
    S0, c1 = bcd_add(A[0:4], Bc[0:4], sub)
    S1, c2 = bcd_add(A[4:8], Bc[4:8], c1)
    nm(c1, 'alu_c1'); nm(c2, 'alu_c2')
    n.block = '4e Инкремент сотен/тысяч'
    chi = nm(n.AND(c2, nsub), 'alu_c2_hi')
    def bcd_inc(dg, c):
        h0 = n.XOR(dg[0], c); k = n.AND(dg[0], c)
        h1 = n.XOR(dg[1], k); k = n.AND(dg[1], k)
        h2 = n.XOR(dg[2], k); k = n.AND(dg[2], k)
        h3 = n.XOR(dg[3], k)
        co = n.AND(n.AND(dg[3], dg[0]), c)
        return [h0, n.XOR(h1, co), h2, n.XOR(h3, co)], co
    S2, c3 = bcd_inc(A[8:12], chi)
    S3, _ = bcd_inc(A[12:16], c3)
    nm(c3, 'alu_c3')
    for i, v in enumerate(S0 + S1 + S2 + S3): nm(v, f'alu_s{i}')
    n.block = '4f Декремент X, X=0'
    # decrementer for X (multiplication counter)
    u, un, t, tn = X[0:4], XN[0:4], X[4:8], XN[4:8]
    b1 = un[0]
    h1 = n.XOR(u[1], b1); b2 = n.AND(b1, un[1])
    h2 = n.XOR(u[2], b2); b3 = n.AND(b2, un[2])
    h3 = n.XOR(u[3], b3); uf = n.AND(b3, un[3])
    decU = [un[0], n.XOR(h1, uf), n.XOR(h2, uf), h3]
    g0 = n.XOR(t[0], uf); br = n.AND(tn[0], uf)
    g1 = n.XOR(t[1], br); br = n.AND(tn[1], br)
    g2 = n.XOR(t[2], br); br = n.AND(tn[2], br)
    g3 = n.XOR(t[3], br)
    decT = [g0, g1, g2, g3]
    for i, v in enumerate(decU + decT): nm(v, f'x_dec{i}')
    nm(uf, 'x_dec_borrow')

    # ---------------- register inputs ----------------
    n.block = '5 Регистры'
    n.block = '5a Регистр X'
    shiftT = n.AND(digitP, shown)
    DX = [n.OR(n.AND(digitP, kb[i]), n.AND(runStep, decU[i])) for i in range(4)] + \
         [n.OR(n.AND(shiftT, X[i]), n.AND(runStep, decT[i])) for i in range(4)]
    Xc(DX, enX)
    n.block = '5b Регистр R'
    Rc(S0 + S1 + S2 + S3, enR)
    n.block = '5c Регистр Y'
    Yc(X, opP)
    n.block = '5d OP и знак'
    OPc([kMinus, kMul], ldOP)
    # sign: reset on op / clear, set in negate cycle
    n.connect('SGN0', n.AND(PH2, neg), n.AND(PH1, n.OR(opP, clrAll)))

    n.block = '6 Управление'
    runc([n.OR(n.AND(eqP, opMul), runStep)], '1')
    negc([n.AND(eqSub, n.NOT(c2))], '1')
    keepShow = n.AND(show, n.NOR(digitP, clrP))
    showSet = n.OR(n.AND(eqP, n.NOT(n.AND(eqSub, n.NOT(c2)))), neg)
    showc([n.OR(keepShow, showSet)], '1')

    # ---------------- display ----------------
    n.block = '7a Мультиплексор индикации'
    D01 = [nm(n.OR(n.AND(show, R[i]), n.AND(shown, X[i])), f'disp_lo{i}') for i in range(8)]
    n.block = '7b Гашение нулей'
    nz = lambda b: n.ORn(b)
    nz3_net = [nz(R[12:16])]
    t32 = n.OR(nz3_net[0], nz(R[8:12]))
    en3 = nm(n.AND(show, nz(R[12:16])), 'disp_en3')
    en2 = nm(n.AND(show, t32), 'disp_en2')
    en1 = nm(n.OR(en2, nz(D01[4:8])), 'disp_en1')
    segs = {}
    n.block = '7c Дешифраторы 7-сегм. ×4'
    def decoder(tag, b, bn, en):
        if bn is None: bn = [n.NOT(x) for x in b]
        p = [n.AND(bn[1], bn[0]), n.AND(bn[1], b[0]), n.AND(b[1], bn[0]), n.AND(b[1], b[0])]
        q0 = n.AND(n.AND(bn[3], bn[2]), en); q1 = n.AND(n.AND(bn[3], b[2]), en); q8 = n.AND(b[3], en)
        dd = [n.AND(q0, p[j]) for j in range(4)] + [n.AND(q1, p[j]) for j in range(4)] + \
             [n.AND(q8, bn[0]), n.AND(q8, b[0])]
        nen = n.NOT(en)
        s = {'a': n.NOR(nen, n.OR(dd[1], dd[4])),
             'b': n.NOR(nen, n.OR(dd[5], dd[6])),
             'c': n.NOR(nen, dd[2]),
             'd': n.NOR(nen, n.ORn([dd[1], dd[4], dd[7]])),
             'e': n.ORn([dd[0], dd[2], dd[6], dd[8]]),
             'f': n.NOR(nen, n.ORn([dd[1], dd[2], dd[3], dd[7]])),
             'g': n.NOR(nen, n.ORn([dd[0], dd[1], dd[7]]))}
        for k, v in s.items(): nm(v, f'seg_{tag}_{k}')
        segs[tag] = s
    decoder('d3', R[12:16], RN[12:16], en3)
    decoder('d2', R[8:12], RN[8:12], en2)
    decoder('d1', D01[4:8], None, en1)
    decoder('d0', D01[0:4], None, '1')

    # ---------------- 3-phase clock generator (built last: keeps element ids stable) ----------------
    if gen:
        n.block = '8 Генератор фаз'
        OSC = n.inp('OSC')
        n.osc = 'OSC'                         # driven by the fl_osc element on D4
        # non-overlapping enables: OSC and its copy delayed by two buffer elements
        d1 = nm(n.OR(OSC, OSC), 'osc_d1'); d2 = nm(n.OR(d1, d1), 'osc_d2')
        men = nm(n.AND(OSC, d2), 'gen_master_en')      # opens late, closes early
        sen = nm(n.NOR(OSC, d2), 'gen_slave_en')       # only while both are low
        aq, aqn = n.cell('gA_m'); a, an = n.cell('gA')
        bq, bqn = n.cell('gB_m'); b, bn = n.cell('gB')
        # 2-bit Johnson counter: A <- ~B, B <- A (states 00 -> 10 -> 11 -> 01 -> 00)
        n.connect('gA_m', n.AND(bn, men), n.AND(b, men))
        n.connect('gB_m', n.AND(a, men), n.AND(an, men))
        n.connect('gA', n.AND(aq, sen), n.AND(aqn, sen))
        n.connect('gB', n.AND(bq, sen), n.AND(bqn, sen))
        p1 = n.AND(n.AND(a, bn), men); p2 = n.AND(n.AND(a, b), men); p3 = n.AND(n.AND(an, b), men)
        ren = {p1: 'PH1', p2: 'PH2', p3: 'PH3'}
        n.gates = [(t, ren.get(o, o), a_, b_, bl) for t, o, a_, b_, bl in n.gates]
        for p in ('PH1', 'PH2', 'PH3'): n.inputs.discard(p)
    # structural hashing: merge identical gates (same type, same inputs); survivors keep their ids
    while True:
        seen, rep = {}, {}
        for t, o, a_, b_, bl in n.gates:
            key = (t, min(a_, b_), max(a_, b_))
            if key in seen: rep[o] = seen[key]
            else: seen[key] = o
        if not rep: break
        f = lambda x: rep.get(x, x)
        n.gates = [(t, o, f(a_), f(b_), bl) for t, o, a_, b_, bl in n.gates if o not in rep]
        for c in n.cells.values(): c[0], c[1] = f(c[0]), f(c[1])
        for tag in segs: segs[tag] = {k: f(v) for k, v in segs[tag].items()}
    nm(nz3_net[0], 'disp_nz3') if nz3_net else None
    for i in range(8): nm(X[i], f'x_reg{i}'); nm(Y[i], f'y_reg{i}')
    for i in range(16): nm(R[i], f'r_reg{i}')
    nm(run, 'st_run'); nm(neg, 'st_neg'); nm(show, 'st_show'); nm(shown, 'st_show_n')
    nm(opSub, 'op_sub'); nm(opMul, 'op_mul'); nm(opMuln, 'op_mul_n'); nm(sgn, 'sign')
    for i in range(16): nm(RN[i], f'r_reg_n{i}')
    for i in range(8): nm(XN[i], f'x_reg_n{i}')
    out = {'segs': segs, 'sign': sgn, 'cls': cls}
    return n, out

SEG7 = {0: 'abcdef', 1: 'bc', 2: 'abdeg', 3: 'abcdg', 4: 'bcfg', 5: 'acdfg', 6: 'acdefg', 7: 'abc', 8: 'abcdefg', 9: 'abcdfg'}
