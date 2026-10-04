from iso import Iso, save, COL
from svgkit import render, img
import math
W, H = 1600, 900
I = Iso(k=1.1, ox=580, oy=510)
BX, BY = 265, 240
ZL, ZB0, ZB1 = 100, 160, 180       # legs top / plenum top / backplane top
T, BW, BH, GAP = 41, 200, 190, 20
X0s = [20 + i * (T + GAP) for i in range(4)]
NAMES = ['B1', 'B2', 'B3', 'B4']
TINT = {'B1': '#E1F5EE', 'B2': '#FAECE7', 'B3': '#E6F1FB', 'B4': '#FAEEDA'}
STR = {'B1': '#1D9E75', 'B2': '#D85A30', 'B3': '#378ADD', 'B4': '#BA7517'}

# fans + filter under the base
for x, y in ((30, 30), (140, 30), (30, 130), (140, 130)):
    I.box(x, y, 20, 90, 80, 45, '#D3D1C7', '#B4B2A9', '#888780')
    I.circle_on_top(x + 45, y + 40, 65, 25, '#888780', '#5F5E5A', 0.8, 20)
    I.circle_on_top(x + 45, y + 40, 65, 8, '#5F5E5A', 'none', 0.8, 12)
    I.box(x + 35, y + 30, 65, 20, 20, 30, '#B5D4F4', '#85B7EB', '#378ADD')
I.box(20, 20, 0, 225, 200, 14, '#F1EFE8', '#D3D1C7', '#B4B2A9')
for x in range(30, 245, 10):
    I.line3((x, 20, 14), (x, 220, 14), '#B4B2A9', 0.6)
for x, y in ((0, 0), (BX - 18, 0), (0, BY - 18), (BX - 18, BY - 18)):
    I.box(x, y, 0, 18, 18, ZL, '#888780', '#5F5E5A', '#444441')
# base: buffer plenum (translucent) + backplane plate
I.box(0, 0, ZL, BX, BY, ZB0 - ZL, '#B5D4F4', '#85B7EB', '#378ADD', op=0.45)
I.box(0, 0, ZB0, BX, BY, ZB1 - ZB0, '#EEEDFE', '#CECBF6', '#AFA9EC')
# backplane channels between block slots
for k in range(14):
    y = 40 + k * 12
    I.line3((15, y, ZB1), (BX - 15, y, ZB1), '#7F77DD', 0.7)
# feed openings at block ends
for x0 in X0s:
    for y in (8, BW + 22):
        I.rect_on_top(x0 + 3, y, ZB1, T - 6, 10, '#378ADD', '#185FA5', 0.6)

# blocks (back to front)
def block(x0, nm):
    x = x0
    for col, t in (('cov', 3), ('plen', 5), ('elem', 8), ('rout', 3), ('rout', 3), ('rout', 3), ('elem', 8), ('plen', 5), ('cov', 3)):
        c3 = COL[col]
        I.box(x, 20, ZB1, t, BW, BH, c3[0], c3[1], c3[0], sw=0.5)
        x += t
    # outer face (+x): vent holes
    for c in range(15):
        for r in range(10):
            cy, cz = 20 + 25 + c * 10 + 5, ZB1 + 20 + r * 15 + 7.5
            I.poly([(x, cy + 1.6 * math.cos(2 * math.pi * i / 8), cz + 1.6 * math.sin(2 * math.pi * i / 8)) for i in range(8)], '#5F5E5A', 'none')
    # coloured frame band to tell blocks apart
    I.poly([(x, 20, ZB1 + BH), (x, 20 + BW, ZB1 + BH), (x, 20 + BW, ZB1 + BH - 8), (x, 20, ZB1 + BH - 8)], TINT[nm], STR[nm], 0.8)
    for yy in (24, 20 + BW - 21):
        I.poly([(x, yy, ZB1), (x, yy + 17, ZB1), (x, yy + 17, ZB1 + BH - 20), (x, yy, ZB1 + BH - 20)], 'none', '#378ADD', 0.9)
    tx, ty = I.P(x, 20 + BW / 2, ZB1 + BH + 18)
    I.text(int(tx), int(ty), nm, 20, STR[nm], 'middle', 600)
    return x
for x0, nm in zip(X0s, NAMES):
    xe = block(x0, nm)
# exhaust arrows: out of the last face and up out of the gaps
for c in range(3):
    for r in range(3):
        y, z = 70 + c * 50, ZB1 + 50 + r * 50
        I.line3((xe, y, z), (xe + 40, y, z), '#888780', 1.8, '4 3')
        ex, ey = I.P(xe + 40, y, z); I.raw(f'<circle cx="{ex:.1f}" cy="{ey:.1f}" r="3" fill="#888780"/>')
for x0 in X0s[1:]:
    gx = x0 - GAP / 2
    for y in (70, 120, 170):
        I.line3((gx, y, ZB1 + BH - 10), (gx, y, ZB1 + BH + 45), '#888780', 1.8, '4 3')
        ex, ey = I.P(gx, y, ZB1 + BH + 45); I.raw(f'<circle cx="{ex:.1f}" cy="{ey:.1f}" r="3" fill="#888780"/>')

# manostat on the right
I.cyl(330, 150, 0, 26, 130, '#E6F1FB', '#B5D4F4', '#378ADD')
I.cyl(330, 150, 0, 24, 90, '#85B7EB', '#85B7EB', '#378ADD')
I.line3((330, 150, 175), (330, 150, 25), '#185FA5', 3)
I.line3((330, 150, 175), (330, 150, 190), '#185FA5', 3)
I.line3((330, 150, 190), (BX, 150, 190), '#185FA5', 3)
I.line3((BX, 150, 190), (BX, 150, 130), '#185FA5', 3)

# front panel on the left
PXL, PXR, PYF = -260, -50, 250
def front_poly(pts, fill):
    I.poly([(x, PYF + 10, z) for x, z in pts], fill, 'none')
I.box(PXL, PYF, 0, PXR - PXL, 10, 330, '#F1EFE8', '#D3D1C7', '#B4B2A9')
for r in range(7):
    for c in range(5):
        x, z = PXL + 55 + c * 24, 310 - r * 24
        front_poly([(x + 7 * math.cos(2 * math.pi * i / 12), z + 7 * math.sin(2 * math.pi * i / 12)) for i in range(12)], '#444441')
SEG = {'a': (6, 66, 22, 5), 'b': (28, 38, 5, 28), 'c': (28, 6, 5, 28), 'd': (6, 0, 22, 5), 'e': (1, 6, 5, 28), 'f': (1, 38, 5, 28), 'g': (6, 33, 22, 5)}
for k, dg in enumerate(('abcdfg', 'abcdefg', 'abcdef', 'bc')):
    for sname, (sx, sz, sw, sh) in SEG.items():
        x0, z0 = PXL + 20 + k * 45 + sx, 40 + sz
        front_poly([(x0, z0), (x0 + sw, z0), (x0 + sw, z0 + sh), (x0, z0 + sh)], '#EF9F27' if sname in dg else '#D3D1C7')
front_poly([(PXL + 190, 150), (PXL + 205, 150), (PXL + 205, 165), (PXL + 190, 165)], '#D85A30')
I.line3((PXR, PYF, 120), (0, PYF - 40, ZB0 + 5), '#5F5E5A', 2.5, '6 3')

def lab(p, y, t1, t2=''):
    I.label(p, 1150, y, t1, 14, weight=600)
    if t2: I.text(1158, y + 18, t2, 12, '#5F5E5A')
lab((X0s[3] + T, 120, ZB1 + 150), 110, 'Блоки B1 → B4 стоят в ряд', 'данные идут слева направо: матрица → B1 … B4 → табло')
lab((X0s[3] + T + 30, 145, ZB1 + 100), 240, 'Выхлоп на обе стороны блока', 'в зазоры 20 мм и вверх, противодавление < 0,1 Па')
lab((BX, 200, ZB1 - 2), 390, 'Объединительная плита', 'порты блоков на прокладке, 68 + 3 линии каналами 2×2 мм')
lab((BX, 120, ZB0 - 20), 500, 'Буферная полость ≈ 5 л', 'окна питания под боковыми стояками каждого блока')
lab((200, 170, 65), 620, 'Турбовентиляторы ×4', 'обратные клапаны, фильтр снизу')
lab((354, 150, 70), 740, 'Гидрозатвор-маностат', '102 мм вод. ст. = 1,00 кПа')
I.label((PXL + 100, PYF + 10, 330), 40, 90, 'Передняя панель: матрица 5×7, кнопка, табло', 13, '#2C2C2A', weight=600)
I.text(30, 850, 'Эскиз, масштаб условный. Основание ≈ 265 × 240 мм, блоки 41 × 200 × 190 мм с шагом 61 мм; высота сборки ≈ 370 мм вместе с ножками.', 12, '#5F5E5A')
I.text(30, 870, 'По площади основания — в 3,5 раза меньше варианта 2×2. Самая длинная межблочная трасса ≈ 250 мм (B2 → B4).', 12, '#5F5E5A')
save(img('iso_assembly.svg'), W, H, I.o, 'Сборка: 4 вертикальных блока на объединительной плите')
render(img('iso_assembly.svg'), img('iso_assembly.png'))
