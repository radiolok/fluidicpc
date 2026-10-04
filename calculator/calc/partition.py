"""Разбиение схемы по даям и блокам: оценка и доработка.

Метрики — число межплатных соединений (цепь + плата-получатель = одна трубка/порт).
По умолчанию печатает метрики текущего разбиения model/partition.json:
  - 8 отдельных даёв (вариант «трубки между всеми даями»);
  - 4 блока по 2 дая (вертикальные блоки на объединительной плите);
  - лучший порядок блоков в ряду (перебор).
С --refine запускает жадную доработку: элемент переносится на другую плату, если это
уменьшает число соединений и не переполняет плату (по умолчанию 130 элементов на дай).

Запуск: python3 partition.py [--refine [ёмкость]]
"""
import collections
import itertools
import json
import random
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'model'))
from calc_netlist import build

n, _ = build(gen=True)
n.compile()
part = json.load(open(ROOT / 'model' / 'partition.json'))['die']
BLOCK_OF = {1: 1, 2: 1, 3: 2, 4: 2, 5: 3, 6: 3, 7: 4, 8: 4}

elems = []                                   # (id, inputs, outputs, sub-block)
for t, o, a, b, blk in n.gates: elems.append((o, [a, b], [o], blk))
for nm, (S, R, blk) in n.cells.items(): elems.append((nm, [S, R], [nm + '.Q', nm + '.QN'], blk))
for k, blk in n.keys: elems.append((k, [], [k, k + '_n'], blk))
die = {e[0]: (4 if e[3].startswith('8') else part[e[0]]) for e in elems}
driver = {net: e[0] for e in elems for net in e[2]}
users = collections.defaultdict(set)
for e in elems:
    for net in e[1]:
        if net in driver: users[net].add(e[0])


def links(assign):
    pairs = collections.Counter()
    for net, us in users.items():
        s = assign[driver[net]]
        for d in {assign[u] for u in us} - {s}:
            pairs[(min(s, d), max(s, d))] += 1
    return pairs


def report():
    sizes = collections.Counter(die.values())
    p8 = links(die)
    print('8 даёв:', ', '.join(f'D{d} {sizes[d]}' for d in sorted(sizes)), f'| межплатных трубок {sum(p8.values())}')
    blk = {e: BLOCK_OF[d] for e, d in die.items()}
    p4 = links(blk)
    vias = collections.Counter()
    for (a, b), v in p8.items():
        if BLOCK_OF[a] == BLOCK_OF[b]: vias[BLOCK_OF[a]] += v
    print('4 блока:', ', '.join(f'B{b} {sum(sizes[d] for d in sizes if BLOCK_OF[d] == b)}' for b in range(1, 5)),
          f'| межблочных соединений {sum(p4.values())}, переходов A↔B внутри блоков', dict(sorted(vias.items())))
    print('   по парам блоков:', dict(sorted(p4.items())))
    best = min(itertools.permutations(range(1, 5)),
               key=lambda p: sum(v * abs(p.index(a) - p.index(b)) for (a, b), v in p4.items()))
    span = collections.Counter()
    for (a, b), v in p4.items(): span[abs(best.index(a) - best.index(b))] += v
    print('   лучший порядок в ряду:', ' → '.join(f'B{b}' for b in best), '| соединений через 0/1/2 блока:',
          [span.get(i, 0) for i in (1, 2, 3)])


def refine(cap=130, seed=1):
    a = dict(die)
    enets = collections.defaultdict(list)
    for net, us in users.items():
        enets[driver[net]].append(net)
        for u in us: enets[u].append(net)
    cost = lambda net: len({a[u] for u in users[net]} - {a[driver[net]]})
    ids = list(a); rng = random.Random(seed)
    for _ in range(40):
        gained = 0; rng.shuffle(ids); sz = collections.Counter(a.values())
        for e in ids:
            cur = a[e]; nets = set(enets[e]); base = sum(cost(x) for x in nets)
            cands = {a[driver[x]] for x in nets} | {a[u] for x in nets for u in users[x]}
            best_d, best_g = None, 0
            for d in cands:
                if d == cur or sz[d] >= cap: continue
                a[e] = d; g = base - sum(cost(x) for x in nets); a[e] = cur
                if g > best_g: best_d, best_g = d, g
            if best_d: a[e] = best_d; sz[cur] -= 1; sz[best_d] += 1; gained += best_g
        if not gained: break
    moved = sum(1 for e in a if a[e] != die[e])
    print(f'доработка (ёмкость {cap}): перенесено {moved} элементов, трубок {sum(links(die).values())} → {sum(links(a).values())}')


if __name__ == '__main__':
    report()
    if '--refine' in sys.argv:
        i = sys.argv.index('--refine')
        refine(int(sys.argv[i + 1]) if len(sys.argv) > i + 1 else 130)
