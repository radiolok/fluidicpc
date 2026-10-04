"""Шрифт 5×7 и веса нейронов: какие пиксели смотрит каждый нейрон."""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'model'))
from glyphs import G, CLASSES
from svgkit import Svg, render, img

W = json.load(open(Path(__file__).resolve().parents[2] / 'model' / 'weights.json'))
NAMES = {'x': '×', '-': '−'}
cell, gap = 22, 70
cols = 8
s = Svg(30 + cols * (5 * cell + gap) - gap + 30, 640, 'Шрифт 5×7 и веса распознавателя')
for idx, c in enumerate(CLASSES):
    r, k = divmod(idx, cols)
    x0, y0 = 30 + k * (5 * cell + gap), 80 + r * (7 * cell + 120)
    s.text(x0 + 2.5 * cell, y0 - 12, f'«{NAMES.get(c, c)}»', 16, '#2C2C2A', 'middle', 600)
    for i in range(35):
        yy, xx = divmod(i, 5)
        x, y = x0 + xx * cell, y0 + yy * cell
        on = G[c][i]
        s.rect(x, y, cell, cell, '#5F5E5A' if on else '#F1EFE8', '#D3D1C7', 0.8, 2)
        if i in W[c]:
            if on:
                s.raw(f'<circle cx="{x+cell/2}" cy="{y+cell/2}" r="{cell*0.3}" fill="#5DCAA5" stroke="#085041" stroke-width="1.5"/>')
            else:
                s.raw(f'<circle cx="{x+cell/2}" cy="{y+cell/2}" r="{cell*0.3}" fill="#FFFFFF" stroke="#D85A30" stroke-width="2"/>')
    kk = len(W[c])
    s.text(x0 + 2.5 * cell, y0 + 7 * cell + 20, f'k = {kk}, {3*kk-5} эл.', 12, '#5F5E5A', 'middle')
ly = 600
s.rect(30, ly - 14, 18, 18, '#5F5E5A', '#D3D1C7', 0.8, 2); s.text(56, ly, 'пиксель символа', 12)
s.raw(f'<circle cx="219" cy="{ly-5}" r="7" fill="#5DCAA5" stroke="#085041" stroke-width="1.5"/>'); s.text(232, ly, 'вес +1: трубочка должна быть закрыта', 12)
s.raw(f'<circle cx="519" cy="{ly-5}" r="7" fill="#FFFFFF" stroke="#D85A30" stroke-width="2"/>'); s.text(532, ly, 'вес −1: трубочка должна быть открыта', 12)
s.text(830, ly, 'нейрон срабатывает при ≤ 1 несовпадении; 26 рабочих трубочек из 35', 12, '#5F5E5A')
s.save(img('glyphs.svg')); render(img('glyphs.svg'), img('glyphs.png'))
