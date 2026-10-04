"""Временная диаграмма генератора трёх фаз (D4): OSC, разрешения, счётчик Джонсона, Ф1–Ф3."""
from svgkit import Svg, render, img

T = 150            # период OSC, px
D = 16             # задержка двух буферов (условно увеличена)
X0, NP = 190, 6
s = Svg(X0 + NP * T + 40, 565, 'Генератор трёх фаз: один такт машины = 4 периода OSC')
rows = []
def wave(name, segs, color='#444441', note=''):
    """segs: список (t0, t1) интервалов высокого уровня."""
    y = 110 + len(rows) * 50
    rows.append(name)
    s.text(30, y + 4, name, 13, '#2C2C2A', weight=600)
    if note: s.text(30, y + 20, note, 11, '#5F5E5A')
    hi, lo = y - 14, y + 10
    pts, level, t = [(X0, lo)], 0, X0
    for a, b in segs:
        pts += [(X0 + a, lo), (X0 + a, hi), (X0 + b, hi), (X0 + b, lo)]
    pts.append((X0 + NP * T, lo))
    d = 'M' + ' L'.join(f'{px},{py}' for px, py in pts)
    s.raw(f'<path d="{d}" fill="none" stroke="{color}" stroke-width="2"/>')
    for a, b in segs:
        s.raw(f'<rect x="{X0+a}" y="{hi}" width="{b-a}" height="{lo-hi}" fill="{color}" fill-opacity="0.12"/>')
    return y
def bus(name, values):
    y = 110 + len(rows) * 50
    rows.append(name)
    s.text(30, y + 4, name, 13, '#2C2C2A', weight=600)
    for i, v in enumerate(values):
        a, b = X0 + i * T + T / 2 + D, X0 + (i + 1) * T + T / 2 + D
        a = max(a, X0); b = min(b, X0 + NP * T)
        s.raw(f'<polygon points="{a},{y-4} {a+6},{y-14} {b-6},{y-14} {b},{y-4} {b-6},{y+6} {a+6},{y+6}" fill="#EEEDFE" stroke="#7F77DD"/>')
        s.text((a + b) / 2, y - 0, v, 12, '#26215C', 'middle')
    # первый неполный сегмент
    s.raw(f'<polygon points="{X0},{y-14} {X0+T/2+D},{y-14} {X0+T/2+D+6},{y-4} {X0+T/2+D},{y+6} {X0},{y+6}" fill="#F1EFE8" stroke="#B4B2A9"/>')
    s.text(X0 + T / 4, y, '00', 12, '#5F5E5A', 'middle')
    return y
osc = [(i * T, i * T + T / 2) for i in range(NP)]
wave('OSC', osc, '#185FA5', 'струйный генератор')
wave('osc_d2', [(a + D, b + D) for a, b in osc], '#378ADD', 'через 2 буфера')
wave('master_en', [(a + D, b) for a, b in osc], '#0F6E56', 'OSC ∧ osc_d2')
wave('slave_en', [(b + D, a + T) for a, b in osc], '#993C1D', 'OSC ∨ osc_d2 = 0')
bus('A B (счётчик)', ['10', '11', '01', '00', '10', '11'])
ph = {1: 'Ф1 сброс ведущих', 2: 'Ф2 запись ведущих', 3: 'Ф3 перенос в ведомые'}
for k, (name, per) in enumerate((('Ф1', 1), ('Ф2', 2), ('Ф3', 3))):
    segs = [(p * T + D, p * T + T / 2) for p in (per, per + 4) if p < NP]
    wave(name, segs, ['#D85A30', '#BA7517', '#534AB7'][k], ph[k + 1].split(' ', 1)[1])
# такт машины
yb = 110 + len(rows) * 50 - 10
s.raw(f'<path d="M{X0+T},{yb} L{X0+T},{yb+12} L{X0+5*T},{yb+12} L{X0+5*T},{yb}" fill="none" stroke="#2C2C2A" stroke-width="1.5"/>')
s.text(X0 + 3 * T, yb + 30, 'такт машины: Ф1, Ф2, Ф3 и пауза; ведущие и ведомые ячейки никогда не открыты одновременно', 13, '#2C2C2A', 'middle')
for i in range(NP + 1):
    s.raw(f'<line x1="{X0+i*T}" y1="80" x2="{X0+i*T}" y2="{yb-4}" stroke="#D3D1C7" stroke-dasharray="2 4"/>')
s.save(img('clock_phases.svg')); render(img('clock_phases.svg'), img('clock_phases.png'))
