"""Генератор структурного нетлиста калькулятора: 8 даёв, 4 блока, верхний уровень.

Каждый экземпляр — один физический элемент. Имена ячеек и пинов — как в adder/fluidic.lib
(AND, OR, NOR, NOT, XOR с пинами A/B/Y; плюс RS, KEY, OSC). Порты модулей объявлены
в стиле Verilog-1995, как в выводе yosys, чтобы файлы читал verilog2netlist.

Запуск: python3 gen_netlist.py   → ../netlist/*.v
"""
import collections
import json
import re
from pathlib import Path

from calc_netlist import build

HERE = Path(__file__).resolve().parent
OUT = HERE.parent / 'netlist'
OUT.mkdir(exist_ok=True)

n, out = build(gen=True)
n.compile()
assign = json.load(open(HERE / 'partition.json'))['die']

DIE = {1: ('d1_retina_a', 'Сетчатка, дай A: 19 входных ключей, нейроны 0–7'),
       2: ('d2_retina_b', 'Сетчатка, дай B: 7 ключей, нейроны 8, 9, + − × = C, шифратор'),
       3: ('d3_ctrl_a', 'Управление, дай A: синхронизатор кнопки, автомат, регистр Y, OP, знак'),
       4: ('d4_ctrl_b', 'Управление, дай B: регистр X, декремент, X = 0, генератор трёх фаз'),
       5: ('d5_alu_a', 'АЛУ, дай A: мультиплексор B, дополнение до 9, BCD-сумматор'),
       6: ('d6_alu_b', 'АЛУ, дай B: регистр R, маска A, инкремент сотен и тысяч'),
       7: ('d7_disp_a', 'Индикация, дай A: мультиплексор индикации, гашение, дешифраторы единиц и десятков'),
       8: ('d8_disp_b', 'Индикация, дай B: дешифраторы сотен и тысяч')}
BLOCK = {1: ('b1_retina', 'Блок B1 «Сетчатка»', (1, 2)), 2: ('b2_ctrl', 'Блок B2 «Управление и ввод»', (3, 4)),
         3: ('b3_alu', 'Блок B3 «АЛУ и результат»', (5, 6)), 4: ('b4_disp', 'Блок B4 «Индикация»', (7, 8))}
DIE2BLK = {d: b for b, (_, _, ds) in BLOCK.items() for d in ds}
HDR = ('// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.\n'
       '// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).\n'
       '`timescale 1ms/10us\n')

# ---------------- elements: (id, cell, [(pin, net) inputs], [(pin, net) outputs], sub-block) ----------------
elems = []
for t, o, a, b, blk in n.gates:
    if t == 'NOR' and a == b:
        elems.append((o, 'NOT', [('A', a)], [('Y', o)], blk))
    else:
        elems.append((o, t, [('A', a), ('B', b)], [('Y', o)], blk))
for nm_, (S, R, blk) in n.cells.items():
    elems.append((nm_, 'RS', [('S', S), ('R', R)], [('Q', nm_ + '.Q'), ('QN', nm_ + '.QN')], blk))
for k, blk in n.keys:
    elems.append((k, 'KEY', [('A', 'TUBE_' + k)], [('Y', k), ('YN', k + '_n')], blk))
elems.append(('osc', 'OSC', [], [('Y', 'OSC')], '8 Генератор фаз'))

die = {e[0]: (4 if e[4].startswith('8') else assign[e[0]]) for e in elems}

# ---------------- net names ----------------
def pretty(net):
    if net in n.names: return n.names[net]
    if net.startswith('TUBE_px_'): return 'tube_' + net[8:].lower()
    m = re.match(r'(.+)\.(Q|QN)$', net)
    if m: return m.group(1).rstrip('_') + ('_q' if m.group(2) == 'Q' else '_qn')
    if net in ('PH1', 'PH2', 'PH3', 'OSC', 'BTN'): return net.lower()
    if net.startswith('px_'): return 'pix_' + net[3:].lower()
    return 'n_' + net
NAME, seen = {}, {}
for e in elems:
    for _, net in e[2] + e[3]:
        if net in ('0', '1') or net in NAME: continue
        p = re.sub(r'[^A-Za-z0-9_]', '_', pretty(net))
        if p in seen and seen[p] != net: p = p + '_' + re.sub(r'[^A-Za-z0-9_]', '_', net)
        seen[p] = net; NAME[net] = p
V = lambda net: "1'b1" if net == '1' else "1'b0" if net == '0' else NAME[net]

driver = {net: e[0] for e in elems for _, net in e[3]}
users = collections.defaultdict(set)
for e in elems:
    for _, net in e[2]:
        if net not in ('0', '1'): users[net].add(e[0])

seg_nets = {out['segs'][tag][s]: 7 * k + j for k, tag in enumerate(('d0', 'd1', 'd2', 'd3')) for j, s in enumerate('abcdefg')}
TOP_OUT = set(seg_nets) | {out['sign']}
TOP_IN = {'BTN'} | {'TUBE_' + k for k, _ in n.keys}
pix_index = {'TUBE_' + k: (int(k[4]) - 1) * 5 + int(k[6]) - 1 for k, _ in n.keys}

def die_ports(d):
    ins, outs = set(), set()
    for e in elems:
        if die[e[0]] != d: continue
        for _, net in e[2]:
            if net not in ('0', '1') and (net in TOP_IN or die[driver[net]] != d): ins.add(net)
        for _, net in e[3]:
            if ({die[u] for u in users.get(net, ())} - {d}) or net in TOP_OUT: outs.add(net)
    key = lambda x: NAME[x]
    return sorted(ins, key=key), sorted(outs, key=key)
DP = {d: die_ports(d) for d in DIE}

def header(mod, ins, outs, extra=()):
    names = [NAME[x] for x in ins + outs]
    L = [f'module {mod} (']
    for i in range(0, len(names), 6):
        L.append('    ' + ', '.join(names[i:i + 6]) + (',' if i + 6 < len(names) else ''))
    L.append(');')
    L += [f'    input {NAME[x]};' for x in ins] + [f'    output {NAME[x]};' for x in outs]
    return L

def wires(names):
    names = sorted(names)
    return ['    wire ' + ', '.join(names[i:i + 8]) + ';' for i in range(0, len(names), 8)]

stats = {}
for d, (mod, desc) in DIE.items():
    ins, outs = DP[d]
    mine = [e for e in elems if die[e[0]] == d]
    cnt = collections.Counter(e[1] for e in mine); stats[mod] = (len(mine), len(ins), len(outs), dict(cnt))
    ports = set(ins) | set(outs)
    internal = {net for e in mine for _, net in e[2] + e[3] if net not in ('0', '1') and net not in ports}
    L = [HDR, f'// {desc}',
         f'// Элементов: {len(mine)} ({", ".join(f"{k} {v}" for k, v in sorted(cnt.items()))})',
         f'// Портов: входов {len(ins)}, выходов {len(outs)}', '']
    L += header(mod, ins, outs) + [''] + wires({NAME[x] for x in internal})
    cur = None
    for e in sorted(mine, key=lambda e: (e[4], 0 if e[1] == 'KEY' else 1)):
        eid, cell, ip, op, blk = e
        if blk != cur: L.append(f'\n    // ---- {blk} ----'); cur = blk
        conns = [f'.{p}({V(net)})' for p, net in ip] + \
                [f'.{p}({V(net) if (net in internal or net in ports) else ""})' for p, net in op]
        L.append(f'    {cell} u_{re.sub(r"[^A-Za-z0-9_]", "_", eid)} ({", ".join(conns)});')
    L.append('\nendmodule\n')
    (OUT / f'{mod}.v').write_text('\n'.join(L))

BP = {}
for b, (bmod, bdesc, (da, db)) in BLOCK.items():
    ins, outs = set(), set()
    for d in (da, db):
        di, do = DP[d]
        ins |= {x for x in di if x in TOP_IN or DIE2BLK[die[driver[x]]] != b}
        outs |= {x for x in do if x in TOP_OUT or any(DIE2BLK[die[u]] != b for u in users.get(x, ()))}
    ins = sorted(ins, key=lambda x: NAME[x]); outs = sorted(outs, key=lambda x: NAME[x]); BP[b] = (ins, outs)
    inner = {NAME[x] for d in (da, db) for x in DP[d][0] + DP[d][1]} - {NAME[x] for x in ins + outs}
    L = [HDR, f'// {bdesc}: два зеркальных дая и общий соединительный пакет.',
         f'// Порты на нижней кромке: входов {len(ins)}, выходов {len(outs)}. Переходов между даями: {len(inner)}.', '']
    L += header(bmod, ins, outs) + [''] + wires(inner)
    for d, tag in ((da, 'die_a'), (db, 'die_b')):
        di, do = DP[d]
        conns = ',\n'.join(f'        .{NAME[x]}({NAME[x]})' for x in di + do)
        L.append(f'\n    {DIE[d][0]} u_{tag} (\n{conns}\n    );')
    L.append('\nendmodule\n')
    (OUT / f'{bmod}.v').write_text('\n'.join(L))

def topnet(x):
    if x == 'BTN': return 'btn'
    if x in pix_index: return f'pix[{pix_index[x]}]'
    if x == out['sign']: return 'sign'
    if x in seg_nets: return f'seg[{seg_nets[x]}]'
    return NAME[x]
inter = {NAME[x] for b in BP for x in BP[b][0] + BP[b][1] if x not in TOP_IN and x not in TOP_OUT}
L = [HDR, '// Верхний уровень: 4 вертикальных блока на объединительной плите.',
     '// pix[r*5+c]: r = 0..6 строка сверху, c = 0..4 столбец слева; 1 — трубочка закрыта силуэтом.',
     '// seg[7*k+j]: k = 0 единицы ... 3 тысячи; j = 0..6 сегменты a..g; 1 — блинкер открыт.',
     '// btn — кнопка «Ввод» (или 36-я трубочка в рамке трафарета); sign — блинкер «−».', '',
     'module fluidic_calc_top (pix, btn, seg, sign);', '    input [34:0] pix;', '    input btn;',
     '    output [27:0] seg;', '    output sign;', '',
     f'    // межблочные линии — каналы объединительной плиты: {len(inter)}'] + wires(inter)
for b, (bmod, bdesc, _) in BLOCK.items():
    ins, outs = BP[b]
    conns = ',\n'.join(f'        .{NAME[x]}({topnet(x)})' for x in ins + outs)
    L.append(f'\n    // {bdesc}\n    {bmod} u_{bmod} (\n{conns}\n    );')
L.append('\nendmodule\n')
(OUT / 'fluidic_calc_top.v').write_text('\n'.join(L))

# hierarchical paths the testbenches need
def hpath(eid, net):
    d = die[eid]; b = DIE2BLK[d]
    return f"u_{BLOCK[b][0]}.u_{'die_a' if BLOCK[b][2][0] == d else 'die_b'}.{NAME[net]}"
paths = {'osc': hpath('osc', 'OSC'), 'ph1': hpath('PH1', 'PH1'), 'ph2': hpath('PH2', 'PH2'), 'ph3': hpath('PH3', 'PH3'),
         'run': hpath('run0', 'run0.Q'), 'neg': hpath('neg0', 'neg0.Q')}
json.dump({'paths': paths, 'stats': stats,
           'blocks': {BLOCK[b][0]: [len(BP[b][0]), len(BP[b][1])] for b in BLOCK},
           'interblock_nets': len(inter),
           'interblock_links': sum(len({DIE2BLK[die[u]] for u in users.get(x, ())} - {DIE2BLK[die[driver[x]]]})
                                   for b in BP for x in BP[b][1] if x not in TOP_OUT)},
          open(OUT / 'netlist_info.json', 'w'), ensure_ascii=False, indent=1)
print('elements', sum(s[0] for s in stats.values()))
for m, s in stats.items(): print(f'  {m:12s} {s[0]:4d}  in {s[1]:3d} out {s[2]:3d}  {s[3]}')
print('paths', paths)
