"""Vertical block: assembled view + exploded view, standing on a base stub."""
from iso import Iso, save, COL
from svgkit import render, img
W, H = 1600, 1040
T = 41                 # block thickness (x)
BW, BH = 200, 190      # width (y) and height (z)
AY, AZ = 25, 20        # array origin on the face (y, z)

def face_x(I, x, y0, z0, w, h, fill, stroke='none', sw=0.6):
    I.poly([(x, y0, z0), (x, y0 + w, z0), (x, y0 + w, z0 + h), (x, y0, z0 + h)], fill, stroke, sw)
def circ_x(I, x, cy, cz, r, fill, n=10):
    import math
    I.poly([(x, cy + r * math.cos(2 * math.pi * i / n), cz + r * math.sin(2 * math.pi * i / n)) for i in range(n)], fill, 'none')

def block(I, x0, y0, z0, exploded=False):
    groups = [('die A', [('cov', 3), ('plen', 5), ('elem', 8)]),
              ('rout', [('rout', 3), ('rout', 3), ('rout', 3)]),
              ('die B', [('elem', 8), ('plen', 5), ('cov', 3)])]
    x = x0
    pos = {}
    for gi, (gname, parts) in enumerate(groups):
        gx0 = x
        for col, t in parts:
            c3 = COL[col]
            I.box(x, y0, z0, t, BW, BH, c3[0], c3[1], c3[0], sw=0.6)
            x += t
        pos[gname] = (gx0, x)
        # details on the +x face of the group
        if gname == 'die A' and exploded:
            for c in range(15):
                for r in range(10):
                    face_x(I, x, y0 + AY + c * 10 + 0.5, z0 + AZ + r * 15 + 0.5, 9, 14, '#FAEEDA', '#BA7517', 0.3)
                    face_x(I, x, y0 + AY + c * 10 + 3, z0 + AZ + r * 15 + 3, 4, 8, '#EF9F27')
        if gname == 'rout' and exploded:
            for r in range(28):
                I.line3((x, y0 + AY, z0 + AZ + 3 + r * 5.3), (x, y0 + AY + 150, z0 + AZ + 3 + r * 5.3), '#7F77DD', 0.6)
        if gname == 'die B':
            for c in range(15):
                for r in range(10):
                    circ_x(I, x, y0 + AY + c * 10 + 5, z0 + AZ + r * 15 + 7.5, 1.5, '#5F5E5A')
        # side ducts on +x face (shown as outlines)
        for yy in (4, BW - 21):
            face_x(I, x, y0 + yy, z0, 17, BH - 20, 'none', '#378ADD', 0.9)
        if exploded and gi < 2:
            x += 85
    return pos, x

# ---------------- left: exploded ----------------
I = Iso(k=1.5, ox=420, oy=520)
I.box(-20, -20, -40, 300, BW + 40, 40, *COL['base'])
for yy in (4, BW - 21):
    for xx in (0, 85 + 16 + 9 + 85):
        pass
pos, xe = block(I, 0, 0, 0, exploded=True)
# air up the side ducts of die B group (front duct visible)
gx0, gx1 = pos['die B']
for xx in ((gx0 + gx1) / 2,):
    I.line3((xx, BW - 12, 0), (xx, BW - 12, BH - 10), '#378ADD', 3)
gx0, gx1 = pos['die A']
I.line3(((gx0 + gx1) / 2, BW - 12, 0), ((gx0 + gx1) / 2, BW - 12, 60), '#378ADD', 3)
# vents out of the outer face of die B
for r in range(3):
    for c in range(3):
        y, z = AY + 25 + c * 50, AZ + 30 + r * 45
        I.line3((xe, y, z), (xe + 45, y, z), '#888780', 1.8, '4 3')
        ex, ey = I.P(xe + 45, y, z); I.raw(f'<circle cx="{ex:.1f}" cy="{ey:.1f}" r="3" fill="#888780"/>')
# signal ports at the bottom edge of the routing pack
rx0, rx1 = pos['rout']
for k in range(6):
    yy = 40 + k * 25
    I.line3(((rx0 + rx1) / 2, yy, 0), ((rx0 + rx1) / 2, yy, -40), '#26215C', 1.6, '3 2')

def lab(I, p, tx, ty, t1, t2=''):
    I.label(p, tx, ty, t1, 13, weight=600)
    if t2: I.text(tx + 8, ty + 17, t2, 12, '#5F5E5A')
x, y = I.P(pos['die A'][1], 60, 120)
lab(I, (pos['die A'][1], 60, 120), 40, 90, 'Дай A', 'элементы смотрят внутрь, к соединительному пакету')
lab(I, (pos['rout'][1], 40, 175), 380, 70, 'Соединительный пакет H / V / H', 'общий для 300 элементов, порты — на нижнюю кромку')
lab(I, (pos['die B'][1], 160, 160), 780, 90, 'Дай B (зеркальный)', 'наружу — крышка с вент. отверстиями')
lab(I, (xe + 45, AY + 125, AZ + 120), 780, 400, 'Выхлоп', 'на обе стороны блока, прямо в зазор')
lab(I, (pos['die B'][0] + 8, BW - 12, 100), 40, 800, 'Стояки питания в боковых полях', 'открыты снизу в полость основания, окна в обе полости')
lab(I, ((rx0 + rx1) / 2, 40, -10), 40, 880, 'Сигнальные порты на нижней кромке пакета', 'ложатся на прокладку объединительной плиты основания')

# ---------------- right: assembled ----------------
J = Iso(k=1.55, ox=1230, oy=640)
J.box(-30, -25, -40, T + 60, BW + 50, 40, *COL['base'])
for yy in (12, 188):
    J.circle_on_top(T / 2 - 0.5, yy, 0, 6, '#378ADD', '#185FA5', 0.6, 12)
pos2, xe2 = block(J, 0, 0, 0)
# layer stripes are visible on the front edge already; arrows
for r in range(3):
    for c in range(3):
        y, z = AY + 25 + c * 50, AZ + 30 + r * 45
        J.line3((xe2, y, z), (xe2 + 40, y, z), '#888780', 1.8, '4 3')
        ex, ey = J.P(xe2 + 40, y, z); J.raw(f'<circle cx="{ex:.1f}" cy="{ey:.1f}" r="3" fill="#888780"/>')
J.text(1180, 975, 'Блок в сборе: 41 × 200 × 190 мм', 13, '#2C2C2A', 'middle', 600)
J.text(1180, 993, 'стоит на основании как плата в корзине', 12, '#5F5E5A', 'middle')

body = I.o + J.o
save(img('iso_block.svg'), W, H, body, 'Вертикальный блок: два зеркальных дая и общий соединительный пакет')
render(img('iso_block.svg'), img('iso_block.png'))
