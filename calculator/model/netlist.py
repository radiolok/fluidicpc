"""Gate-level netlist builder and phase-accurate simulator for the fluidic calculator.

Element set (each counts as 1 module):
  AND, OR, NOR, XOR  -- 2-input jet elements (NOT = NOR with tied inputs)
  CELL               -- bistable memory cell: inputs S, R; outputs Q and QN
  KEY                -- input key on a pixel tube: outputs x and xn
Clock phases PH1, PH2, PH3 come from the clock block (counted separately).
"""
from collections import defaultdict

class NL:
    def __init__(self):
        self.gates = []          # (type, out, a, b, block)
        self.cells = {}          # name -> [S, R, block]
        self.keys = []           # (name, block)
        self.inputs = set(['0', '1'])
        self.block = 'misc'
        self.n = 0

    def _new(self, p='n'):
        self.n += 1
        return f'{p}{self.n}'

    def inp(self, name):
        self.inputs.add(name); return name

    def key(self, name):
        self.keys.append((name, self.block))
        self.inputs.add(name); self.inputs.add(name + '_n')
        return name, name + '_n'

    def _g(self, t, a, b):
        o = self._new(t.lower())
        self.gates.append((t, o, a, b, self.block))
        return o

    def AND(self, a, b):
        if '0' in (a, b): return '0'
        if a == '1': return b
        if b == '1': return a
        return self._g('AND', a, b)

    def OR(self, a, b):
        if '1' in (a, b): return '1'
        if a == '0': return b
        if b == '0': return a
        return self._g('OR', a, b)

    def XOR(self, a, b):
        if a == '0': return b
        if b == '0': return a
        return self._g('XOR', a, b)

    def NOR(self, a, b):
        if '1' in (a, b): return '0'
        return self._g('NOR', a, b)

    def NOT(self, a):
        if a == '0': return '1'
        if a == '1': return '0'
        return self._g('NOR', a, a)

    def ORn(self, xs):
        xs = list(xs)
        while len(xs) > 1:
            nx = [self.OR(xs[i], xs[i+1]) for i in range(0, len(xs) - 1, 2)]
            if len(xs) % 2: nx.append(xs[-1])
            xs = nx
        return xs[0] if xs else '0'

    def cell(self, name):
        self.cells[name] = [None, None, self.block]
        return name + '.Q', name + '.QN'

    def connect(self, name, S, R):
        self.cells[name][0] = S; self.cells[name][1] = R

    # ---- statistics -------------------------------------------------------
    def counts(self):
        c = defaultdict(lambda: defaultdict(int))
        for t, o, a, b, blk in self.gates: c[blk][t] += 1
        for nm, (S, R, blk) in self.cells.items(): c[blk]['CELL'] += 1
        for nm, blk in self.keys: c[blk]['KEY'] += 1
        return c

    def fanout(self):
        f = defaultdict(int)
        for t, o, a, b, blk in self.gates:
            f[a] += 1
            if b != a: f[b] += 1
        for nm, (S, R, blk) in self.cells.items():
            f[S] += 1; f[R] += 1
        return f

    # ---- simulation -------------------------------------------------------
    def compile(self):
        drv = {o: i for i, (t, o, a, b, blk) in enumerate(self.gates)}
        order, state = [], {}
        def visit(i):
            if state.get(i) == 2: return
            if state.get(i) == 1: raise RuntimeError('combinational loop at ' + self.gates[i][1])
            state[i] = 1
            t, o, a, b, blk = self.gates[i]
            for x in (a, b):
                if x in drv: visit(drv[x])
            state[i] = 2; order.append(i)
        for i in range(len(self.gates)): visit(i)
        self.order = [self.gates[i] for i in order]
        for nm, (S, R, blk) in self.cells.items():
            assert S is not None and R is not None, 'unconnected cell ' + nm
        self.v = defaultdict(int); self.v['1'] = 1
        for nm in self.cells: self.v[nm + '.Q'] = 0; self.v[nm + '.QN'] = 1

    def depth(self, sources_reset=True):
        d = defaultdict(int)
        for t, o, a, b, blk in self.order:
            d[o] = 1 + max(d[a], d[b])
        return d

    def settle(self, maxit=50):
        v = self.v
        for it in range(maxit):
            for t, o, a, b, blk in self.order:
                x, y = v[a], v[b]
                v[o] = (x & y) if t == 'AND' else (x | y) if t == 'OR' else (x ^ y) if t == 'XOR' else 1 - (x | y)
            changed = False
            for nm, (S, R, blk) in self.cells.items():
                s, r = v[S], v[R]
                if s and r: raise RuntimeError(f'S and R both active on cell {nm}')
                q = 1 if s else 0 if r else v[nm + '.Q']
                if q != v[nm + '.Q']:
                    v[nm + '.Q'] = q; v[nm + '.QN'] = 1 - q; changed = True
            if not changed: return
        raise RuntimeError('did not settle (oscillation)')
