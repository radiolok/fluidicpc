"""Подбор весов распознавателя: какие пиксели смотрит каждый из 15 нейронов.

Условия для нейрона класса c (нейрон срабатывает при ≤ 1 несовпадении):
  - любой другой символ отличается от c минимум в 3 пикселях из набора —
    тогда одна ошибка пикселя не вызывает ни пропуска, ни ложного срабатывания;
  - пустая и полностью закрытая матрица дают ≥ 2 несовпадения — нейрон молчит.
Среди наборов минимального размера k выбирается сочетание с наименьшим числом
используемых трубочек и нагрузкой на выход ключа не больше 3.
Нейрон на k пикселей — цепочка из 3k − 5 элементов 2И/2ИЛИ.

Запуск: python3 recognizer_weights.py           — подобрать и показать
        python3 recognizer_weights.py --write   — записать в model/weights.json
"""
import json
import random
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / 'model'))
from glyphs import G, CLASSES, pname

N = 35


def minimal_sets(c, kmax=9, limit=4000):
    others = [o for o in CLASSES if o != c]
    mm = {o: [int(G[c][i] != G[o][i]) for i in range(N)] for o in others}
    mm['пусто'] = [G[c][i] for i in range(N)]
    mm['всё закрыто'] = [1 - G[c][i] for i in range(N)]
    need = {o: 3 for o in others}; need['пусто'] = 2; need['всё закрыто'] = 2
    keys = list(mm)
    order = sorted(range(N), key=lambda i: -sum(mm[o][i] for o in keys))
    for k in range(3, kmax + 1):
        sols = []
        def dfs(start, chosen, deficit):
            if len(sols) >= limit: return
            rem = k - len(chosen)
            if rem == 0:
                if all(v <= 0 for v in deficit.values()): sols.append(tuple(sorted(chosen)))
                return
            if any(v > rem for v in deficit.values()): return
            for j in range(start, N):
                i = order[j]
                dfs(j + 1, chosen + [i], {o: deficit[o] - mm[o][i] for o in keys})
        dfs(0, [], dict(need))
        if sols: return sols
    raise RuntimeError(c)


def pick(S, restarts=200, seed=1):
    def cost(ch):
        fan = {}
        for c in CLASSES:
            for i in ch[c]: fan[(i, G[c][i])] = fan.get((i, G[c][i]), 0) + 1
        pix = len({i for c in CLASSES for i in ch[c]})
        return sum(max(0, v - 3) for v in fan.values()) * 10 + pix
    rng, best = random.Random(seed), None
    for _ in range(restarts):
        ch = {c: rng.choice(S[c]) for c in CLASSES}
        cur, improved = cost(ch), True
        while improved:
            improved = False
            for c in CLASSES:
                for s in S[c]:
                    old = ch[c]; ch[c] = s; v = cost(ch)
                    if v < cur: cur, improved = v, True
                    else: ch[c] = old
        if best is None or cur < best[0]: best = (cur, dict(ch))
    return best[1]


if __name__ == '__main__':
    S = {c: minimal_sets(c) for c in CLASSES}
    ch = pick(S)
    total = 0
    for c in CLASSES:
        lits = ' '.join(('' if G[c][i] else '¬') + pname(i) for i in ch[c])
        total += 3 * len(ch[c]) - 5
        print(f'{c}: k={len(ch[c])}  {lits}')
    print(f'трубочек: {len({i for c in CLASSES for i in ch[c]})}, элементов в нейронах: {total}')
    if '--write' in sys.argv:
        out = Path(__file__).resolve().parent.parent / 'model' / 'weights.json'
        json.dump({c: list(ch[c]) for c in CLASSES}, open(out, 'w'))
        print('записано в', out)
