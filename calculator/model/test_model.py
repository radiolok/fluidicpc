"""Тесты эталонной модели: примеры, случайные, с ошибкой пикселя, полный перебор.

Запуск: python3 test_model.py            — примеры + 300 случайных + 300 с ошибкой пикселя
        python3 test_model.py full       — полный перебор a op b, a, b = 0..99 (≈ 1 ч)
"""
import random
import sys

from calc_netlist import build
from glyphs import G
from sim import Machine, run_tests

n, out = build(gen=True); n.compile()
pix = {}
for k, _ in n.keys:
    i = (int(k[4]) - 1) * 5 + int(k[6]) - 1
    pix[k] = (i, 0); pix[k + '_n'] = (i, 1)


class NoisyMachine(Machine):
    """Каждое нажатие подаёт символ с одним случайно перевёрнутым пикселем."""
    rng = random.Random(3)

    def press(s, ch):
        bits = list(G[ch]); bits[s.rng.randrange(35)] ^= 1
        s.setpix(bits); s.clock(1); s.clock(1); s.clock(1); s.setpix([0] * 35); s.clock(0)
        k = 0
        while s.n.v[s.run] or s.n.v[s.neg]:
            s.clock(0); k += 1
        s.clock(0)


m = Machine(n, out['segs'], out['sign'], pix)
full = len(sys.argv) > 1 and sys.argv[1] == 'full'
f1, c1 = run_tests(m, nrand=300, exhaustive=full)
print(f'чистые символы: {c1} примеров (+9 заданных), ошибок {f1}')
f2 = 0
if not full:
    nm = NoisyMachine(n, out['segs'], out['sign'], pix)
    f2, c2 = run_tests(nm, nrand=300, seed=21)
    print(f'одна ошибка пикселя на каждом нажатии: {c2} примеров, ошибок {f2}')
sys.exit(1 if f1 or f2 else 0)
