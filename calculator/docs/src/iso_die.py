"""Die sketch for the vertical-block variant (drawn lying flat, outer side down)."""
from iso import Iso, save, COL
from svgkit import render, img
W, H = 1500, 1260
K = 2.15
I = Iso(k=K, ox=400, oy=620)
PX, PY = 200, 190          # width × height of the die (PY edge = bottom edge in the block)
AX, AY = 25, 20            # array origin
GAP = 46
DUCTS = [(4, 21), (179, 196)]

def ducts(zt, windows=False):
    for x0, x1 in DUCTS:
        I.rect_on_top(x0, AY, zt, x1 - x0, PY - AY, '#85B7EB', '#185FA5', 0.7)
        if windows:
            xx = x1 if x0 < 100 else x0
            for y in range(AY + 10, AY + 150, 20):
                I.line3((xx, y, zt), (xx + (6 if x0 < 100 else -6), y, zt), '#185FA5', 2.2)

layers = []
z = 0
def layer(name, h, col, deco=None, edge_ports=False):
    global z
    t, s1, s2 = COL[col]
    I.box(0, 0, z, PX, PY, h, t, s1, s2)
    if deco: deco(z + h)
    ducts(z + h, name == 'plen')
    if edge_ports:
        for x in range(30, 172, 5):
            I.poly([(x, PY, z + 0.8), (x + 2, PY, z + 0.8), (x + 2, PY, z + h - 0.8), (x, PY, z + h - 0.8)], '#26215C', 'none')
    layers.append((name, z + h))
    z += h + GAP

def d_cover(zt):
    for c in range(15):
        for r in range(10):
            for vx in (2, 8):
                I.circle_on_top(AX + c * 10 + vx, AY + r * 15 + 13, zt, 1.5, '#5F5E5A', 'none', 0.4, 8)
def d_plenum(zt):
    I.rect_on_top(AX - 2, AY - 2, zt, 154, 154, '#E6F1FB', '#378ADD', 0.8)
    for c in range(15):
        for r in range(10):
            for vx in (2, 8):
                I.circle_on_top(AX + c * 10 + vx, AY + r * 15 + 13, zt, 1.9, '#D3D1C7', '#888780', 0.4, 8)
def d_elements(zt):
    for c in range(15):
        for r in range(10):
            x, y = AX + c * 10, AY + r * 15
            I.rect_on_top(x + 0.4, y + 0.4, zt, 9.2, 14.2, '#FAEEDA', '#BA7517', 0.4)
            I.rect_on_top(x + 3, y + 3, zt, 4, 8, '#EF9F27')
            I.circle_on_top(x + 3.5, y + 12.8, zt, 0.9, '#412402', n=8)
            I.circle_on_top(x + 6.5, y + 12.8, zt, 0.9, '#412402', n=8)
            for yy in (5, 9):
                I.circle_on_top(x + 1.3, y + yy, zt, 0.7, '#7F77DD', n=6)
                I.circle_on_top(x + 8.7, y + yy, zt, 0.7, '#7F77DD', n=6)
def d_routH(zt):
    for r in range(30):
        I.line3((AX, AY + 2.5 + r * 5, zt), (AX + 150, AY + 2.5 + r * 5, zt), '#7F77DD', 0.7)
def d_routV(zt):
    for c in range(29):
        I.line3((AX + 4 + c * 5, AY, zt), (AX + 4 + c * 5, PY, zt), '#534AB7', 0.7)

layer('cov', 3, 'cov', d_cover)
layer('plen', 5, 'plen', d_plenum)
layer('elem', 8, 'elem', d_elements)
layer('routH', 3, 'rout', d_routH, True)
layer('routV', 3, 'rout', d_routV, True)

LBL = {'cov': ('Наружная крышка', 'вентиляционные отверстия — прямо в атмосферу'),
       'plen': ('Полость питания, h = 5 мм', 'окна в стояки; по 2 вент. втулки на элемент'),
       'elem': ('Плата элементов 15 × 10', '150 мест 10 × 15 мм; питание и выхлоп — наружу'),
       'routH': ('Соединительный слой H', 'общий с зеркальным даем'),
       'routV': ('Соединительный слой V', 'каналы выходят на нижнюю кромку — порты')}
for name, zt in layers:
    t1, t2 = LBL[name]
    x, y = I.P(PX, PY * 0.6, zt - 2)
    I.label((PX, PY * 0.6, zt - 2), 900, int(y) + 4, t1, 14, weight=600)
    I.text(908, int(y) + 22, t2, 12, '#5F5E5A')
top = layers[-1][1]
I.label((12, 60, top), 60, 80, 'боковые стояки питания (25 мм поля),', 12, '#185FA5')
I.text(64, 96, 'открыты снизу в полость основания', 12, '#185FA5')
I.label((100, PY, top - 1.5), 560, 1180, 'нижняя кромка: порты соединительных слоёв → основание', 12, '#26215C')

# inset: element cell
ox, oy, k = 1230, 930, 15
def R(x, y, w, h, f, st='none', sw=1, rx=2): I.raw(f'<rect x="{ox+x*k}" y="{oy+y*k}" width="{w*k}" height="{h*k}" rx="{rx}" fill="{f}" stroke="{st}" stroke-width="{sw}"/>')
def Ci(x, y, r, f, st='none'): I.raw(f'<circle cx="{ox+x*k}" cy="{oy+y*k}" r="{r*k}" fill="{f}" stroke="{st}"/>')
def T(x, y, t, a='start', c='#2C2C2A', s=12): I.raw(f'<text x="{x}" y="{y}" font-size="{s}" fill="{c}" text-anchor="{a}">{t}</text>')
I.raw(f'<text x="{ox-90}" y="{oy-40}" font-size="14" font-weight="600" fill="#2C2C2A">Место элемента 10 × 15 мм</text>')
R(0, 0, 10, 15, '#FAEEDA', '#BA7517', 1.5, 4)
R(3, 3, 4, 8, '#EF9F27', '#BA7517', 1)
I.raw(f'<path d="M{ox+5*k},{oy+3*k} L{ox+5*k},{oy+7*k} M{ox+4*k},{oy+11*k} L{ox+5*k},{oy+8*k} L{ox+6*k},{oy+11*k}" stroke="#412402" stroke-width="1.5" fill="none"/>')
Ci(5, 1.8, 0.9, '#378ADD', '#185FA5'); Ci(1.8, 13.2, 1.2, '#888780'); Ci(8.2, 13.2, 1.2, '#888780'); Ci(3.8, 12.8, 0.8, '#412402'); Ci(6.2, 12.8, 0.8, '#412402')
for yy in (5, 9):
    Ci(1.3, yy, 0.7, '#7F77DD'); Ci(8.7, yy, 0.7, '#7F77DD')
T(ox + 5 * k, oy - 12, 'питание — из полости', 'middle', '#185FA5')
T(ox - 10, oy + 7 * k, 'управление', 'end', '#534AB7'); T(ox - 10, oy + 7 * k + 15, '×2', 'end', '#534AB7')
T(ox + 10 * k + 10, oy + 7 * k, 'управление', 'start', '#534AB7'); T(ox + 10 * k + 10, oy + 7 * k + 15, '×2', 'start', '#534AB7')
T(ox + 5 * k, oy + 15 * k + 20, 'выходы → соединительные слои', 'middle', '#412402')
T(ox + 5 * k, oy + 15 * k + 36, 'серые — 2 вент. окна у выходов → наружу', 'middle', '#5F5E5A')

I.text(30, 1215, 'Эскиз, масштаб условный; дай показан лёжа, в блоке он стоит вертикально нижней кромкой (на рисунке — ближняя) на основании.', 12, '#5F5E5A')
I.text(30, 1233, 'Плата 200 × 190 мм: массив 150 × 150 мм, по бокам поля 25 мм под стояки питания, снизу 20 мм под порты.', 12, '#5F5E5A')
save(img('iso_die.svg'), W, H, I.o, 'Дай для вертикального блока, разнесённый вид')
render(img('iso_die.svg'), img('iso_die.png'))
