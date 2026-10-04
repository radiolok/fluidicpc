"""Потактовая симуляция модели с настоящим генератором фаз (4 периода OSC на такт машины)."""
import sys, random
from glyphs import G, pname
from calc_netlist import SEG7
SEGINV = {frozenset(v): str(k) for k, v in SEG7.items()}; SEGINV[frozenset()] = ''

class Machine:
    def __init__(s, n, segs, sign, pix_of, run='run0.Q', neg='neg0.Q'):
        s.n, s.segs, s.sign, s.pix_of, s.run, s.neg = n, segs, sign, pix_of, run, neg
        n.settle(); s.setpix([0] * 35)
        for _ in range(3): s.clock(0)
    def setpix(s, bits):
        for net, (i, inv) in s.pix_of.items(): s.n.v[net] = (1 - bits[i]) if inv else bits[i]
    def clock(s, btn):
        s.n.v['BTN'] = btn
        for _ in range(4):
            s.n.v['OSC'] = 1; s.n.settle(); s.n.v['OSC'] = 0; s.n.settle()
    def press(s, ch):
        s.setpix(G[ch]); s.clock(1); s.clock(1); s.clock(1); s.setpix([0] * 35); s.clock(0)
        k = 0
        while s.n.v[s.run] or s.n.v[s.neg]:
            s.clock(0); k += 1; assert k < 200
        s.clock(0)
    def shown(s):
        txt = ''.join(SEGINV[frozenset(k for k, v in s.segs[d].items() if s.n.v[v])] for d in ('d3', 'd2', 'd1', 'd0'))
        v = int(txt) if txt else 0
        return -v if s.n.v[s.sign] else v
    def calc(s, keys):
        s.press('C')
        for ch in keys: s.press(ch)
        return s.shown()

def run_tests(m, nrand=300, exhaustive=False, seed=5):
    e = lambda a, o, b: a + b if o == '+' else a - b if o == '-' else a * b
    fails = 0
    for k, v in [('12+34=', 46), ('99+99=', 198), ('5-8=', -3), ('50-50=', 0), ('99x99=', 9801), ('7x0=', 0), ('123+4=', 27), ('8-12=', -4), ('64x25=', 1600)]:
        got = m.calc(k); fails += got != v
        if got != v: print('FAIL', k, got, v)
    rng = random.Random(seed)
    cases = [(a, o, b) for o in '+-x' for a in range(100) for b in range(100)] if exhaustive else \
            [(rng.randrange(100), rng.choice('+-x'), rng.randrange(100)) for _ in range(nrand)]
    for i, (a, o, b) in enumerate(cases):
        got = m.calc(f'{a}{o}{b}=')
        if got != e(a, o, b): fails += 1; print('FAIL', a, o, b, got, flush=True)
        if exhaustive and i % 5000 == 4999: print(i + 1, 'done, fails', fails, flush=True)
    return fails, len(cases)

if __name__ == '__main__':
    from calc_netlist import build
    n, out = build(gen=True); n.compile()
    pix = {}
    for k, _ in n.keys:
        r, c = int(k[4]), int(k[6]); i = (r - 1) * 5 + c - 1
        pix[k] = (i, 0); pix[k + '_n'] = (i, 1)
    m = Machine(n, out['segs'], out['sign'], pix)
    print(run_tests(m, int(sys.argv[1]) if len(sys.argv) > 1 else 200))
