"""Независимая проверка сгенерированного нетлиста.

1. Синтаксис: каждый файл разбирается BNF-парсером Verilog из verilog2netlist (pyparsing).
2. Структура: иерархия разворачивается, каждый элемент сверяется с эталонной моделью
   по типу и связям (биекция цепей).
3. Поведение: развёрнутый нетлист моделируется с настоящим генератором фаз.

Запуск: python3 check_netlist.py [число случайных примеров | full]
"""
import collections
import warnings
warnings.filterwarnings("ignore")
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
NETDIR = HERE.parent / 'netlist'
MODULE_FILES = sorted(p for p in NETDIR.glob('*.v') if not p.name.startswith('tb_'))

# ---------- 1. syntax via verilog2netlist BNF ----------
v2n = HERE.parent.parent / 'verilog2netlist'
try:
    sys.path.insert(0, str(v2n))
    from verilog_parse import Verilog_BNF
    bnf = Verilog_BNF()
    for f in MODULE_FILES:
        bnf.parseString(f.read_text(), parseAll=True)
    print(f'синтаксис: {len(MODULE_FILES)} файлов разобраны BNF-парсером verilog2netlist')
except ImportError as e:
    print('синтаксис: пропущено, нет pyparsing/verilog2netlist:', e)

# ---------- 2. parse + flatten ----------
mods = {}
for f in MODULE_FILES:
    txt = re.sub(r'//[^\n]*', '', f.read_text())
    for m in re.finditer(r'module\s+(\w+)\s*\((.*?)\);(.*?)endmodule', txt, re.S):
        name, _, body = m.groups()
        insts = []
        for im in re.finditer(r'^\s*(\w+)\s+(u_\w+)\s*\((.*?)\);', body, re.S | re.M):
            typ, iname, conns = im.groups()
            insts.append((typ, iname, dict((a, b.strip()) for a, b in re.findall(r'\.(\w+)\(([^)]*)\)', conns))))
        mods[name] = insts
CELLS = {'AND', 'OR', 'NOR', 'NOT', 'XOR', 'RS', 'KEY', 'OSC'}
leaves = []
def flatten(mod, path, pm):
    res = lambda net: net if net in ("1'b1", "1'b0", '') else pm.get(net, f'{path}.{net}')
    for typ, iname, cm in mods[mod]:
        if typ in CELLS: leaves.append((typ, f'{path}.{iname}', {p: res(v) for p, v in cm.items()}))
        else: flatten(typ, f'{path}.{iname}', {p: res(v) for p, v in cm.items()})
flatten('fluidic_calc_top', 'top', {})
clean = lambda x: x[4:] if x.startswith('top.') and ('[' in x or x in ('top.btn', 'top.sign')) else x
leaves = [(t, p, {k: clean(v) for k, v in c.items()}) for t, p, c in leaves]
print('элементов в нетлисте:', len(leaves), dict(collections.Counter(t for t, _, _ in leaves)))

from calc_netlist import build
n, out = build(gen=True); n.compile()
ref = {}
for t, o, a, b, blk in n.gates:
    key = re.sub(r'[^A-Za-z0-9_]', '_', o)
    ref[key] = ('NOT', {'A': a, 'Y': o}) if (t == 'NOR' and a == b) else (t, {'A': a, 'B': b, 'Y': o})
for nm_, (S, R, blk) in n.cells.items():
    ref[re.sub(r'[^A-Za-z0-9_]', '_', nm_)] = ('RS', {'S': S, 'R': R, 'Q': nm_ + '.Q', 'QN': nm_ + '.QN'})
for k, blk in n.keys: ref[k] = ('KEY', {'A': 'TUBE_' + k, 'Y': k, 'YN': k + '_n'})
ref['osc'] = ('OSC', {'Y': 'OSC'})
fwd, bwd, bad, ids = {}, {}, 0, set()
for t, path, conns in leaves:
    eid = path.split('.u_')[-1]
    assert eid not in ids, eid; ids.add(eid)
    rt, rc = ref[eid]
    if rt != t: bad += 1; continue
    for p, f in conns.items():
        o = rc[p]
        if f == '': continue
        if o in ('0', '1'):
            bad += f != ("1'b1" if o == '1' else "1'b0"); continue
        if fwd.setdefault(o, f) != f or bwd.setdefault(f, o) != o: bad += 1
missing = set(ref) - ids
print(f'структура: эталон {len(ref)} элементов, не найдено {len(missing)}, расхождений {bad}')
assert not missing and bad == 0

# ---------- 3. simulate the flattened netlist ----------
from netlist import NL
from sim import Machine, run_tests
m = NL()
cst = lambda x: '1' if x == "1'b1" else '0' if x == "1'b0" else x
pix_of = {}
for t, path, c in leaves:
    if t in ('AND', 'OR', 'NOR', 'XOR'): m.gates.append((t, c['Y'], cst(c['A']), cst(c['B']), 'v'))
    elif t == 'NOT': m.gates.append(('NOR', c['Y'], cst(c['A']), cst(c['A']), 'v'))
    elif t == 'RS':
        m.cells[path] = [cst(c['S']), cst(c['R']), 'v']
        if c.get('Q'): m.gates.append(('OR', c['Q'], path + '.Q', path + '.Q', 'alias'))
        if c.get('QN'): m.gates.append(('OR', c['QN'], path + '.QN', path + '.QN', 'alias'))
    elif t == 'KEY':
        i = int(re.match(r'pix\[(\d+)\]', c['A']).group(1))
        if c.get('Y'): pix_of[c['Y']] = (i, 0)
        if c.get('YN'): pix_of[c['YN']] = (i, 1)
    elif t == 'OSC': osc = c['Y']
m.inputs |= set(pix_of) | {'btn', osc}
m.compile()
segs = {f'd{k}': {s: f'seg[{7 * k + j}]' for j, s in enumerate('abcdefg')} for k in range(4)}
class VM(Machine):
    def clock(s, btn):
        s.n.v['btn'] = btn
        for _ in range(4):
            s.n.v[osc] = 1; s.n.settle(); s.n.v[osc] = 0; s.n.settle()
vm = VM(m, segs, 'sign', pix_of, run=fwd['run0.Q'], neg=fwd['neg0.Q'])
arg = sys.argv[1] if len(sys.argv) > 1 else '150'
fails, ncases = run_tests(vm, exhaustive=(arg == 'full'), nrand=0 if arg == 'full' else int(arg), seed=11)
print(f'моделирование нетлиста: {ncases} примеров, ошибок {fails}')
sys.exit(1 if fails else 0)
