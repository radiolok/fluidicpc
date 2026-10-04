"""Isometric sketch helpers: x right-back, y left-back, z up (mm)."""
import math
C, S = math.cos(math.pi / 6), math.sin(math.pi / 6)

class Iso:
    def __init__(s, k=2.0, ox=0, oy=0):
        s.k, s.ox, s.oy, s.o = k, ox, oy, []
    def P(s, x, y, z):
        return (s.ox + (x - y) * C * s.k, s.oy + ((x + y) * S - z) * s.k)
    def poly(s, pts, fill, stroke='#444441', sw=0.8, op=1.0, extra=''):
        d = ' '.join('%.1f,%.1f' % s.P(*p) for p in pts)
        o = f' fill-opacity="{op}"' if op < 1 else ''
        s.o.append(f'<polygon points="{d}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"{o} {extra}/>')
    def box(s, x, y, z, w, d, h, top, side1, side2, stroke='#444441', sw=0.8, op=1.0):
        # visible faces: top, front (y = y+d), right (x = x+w)
        s.poly([(x, y + d, z), (x + w, y + d, z), (x + w, y + d, z + h), (x, y + d, z + h)], side1, stroke, sw, op)
        s.poly([(x + w, y, z), (x + w, y + d, z), (x + w, y + d, z + h), (x + w, y, z + h)], side2, stroke, sw, op)
        s.poly([(x, y, z + h), (x + w, y, z + h), (x + w, y + d, z + h), (x, y + d, z + h)], top, stroke, sw, op)
    def rect_on_top(s, x, y, z, w, d, fill, stroke='none', sw=0.6, op=1.0):
        s.poly([(x, y, z), (x + w, y, z), (x + w, y + d, z), (x, y + d, z)], fill, stroke, sw, op)
    def circle_on_top(s, cx, cy, z, r, fill, stroke='none', sw=0.6, n=14):
        pts = [(cx + r * math.cos(2 * math.pi * i / n), cy + r * math.sin(2 * math.pi * i / n), z) for i in range(n)]
        s.poly(pts, fill, stroke, sw)
    def line3(s, a, b, color='#444441', sw=1.0, dash=None):
        (x1, y1), (x2, y2) = s.P(*a), s.P(*b)
        dd = f' stroke-dasharray="{dash}"' if dash else ''
        s.o.append(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}" stroke="{color}" stroke-width="{sw}"{dd}/>')
    def cyl(s, cx, cy, z, r, h, top, side, stroke='#444441', sw=0.8, n=24):
        # vertical cylinder: side as hull band + top ellipse
        pts_b = [(cx + r * math.cos(2 * math.pi * i / n), cy + r * math.sin(2 * math.pi * i / n)) for i in range(n)]
        # silhouette: take extreme points in screen x
        scr = [(s.P(px, py, z)[0], i) for i, (px, py) in enumerate(pts_b)]
        il = min(scr)[1]; ir = max(scr)[1]
        # front arc from ir to il going through front (larger x+y)
        arc = []
        i = ir
        while True:
            arc.append(pts_b[i])
            if i == il: break
            i = (i + 1) % n
        if sum(px + py for px, py in arc) / len(arc) < cx + cy:
            arc = []
            i = ir
            while True:
                arc.append(pts_b[i])
                if i == il: break
                i = (i - 1) % n
        band = [(px, py, z) for px, py in arc] + [(px, py, z + h) for px, py in reversed(arc)]
        s.poly(band, side, stroke, sw)
        s.poly([(px, py, z + h) for px, py in pts_b], top, stroke, sw)
    def label(s, p3, tx, ty, text, size=13, color='#2C2C2A', anchor='start', weight=400):
        text = text.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        x, y = s.P(*p3)
        s.o.append(f'<line x1="{x:.1f}" y1="{y:.1f}" x2="{tx}" y2="{ty-4}" stroke="#888780" stroke-width="0.8"/>')
        s.o.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="2" fill="#888780"/>')
        s.o.append(f'<text x="{tx + (4 if anchor=="start" else -4)}" y="{ty}" font-size="{size}" fill="{color}" text-anchor="{anchor}" font-weight="{weight}">{text}</text>')
    def text(s, x, y, t, size=13, color='#2C2C2A', anchor='start', weight=400):
        t = t.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        s.o.append(f'<text x="{x}" y="{y}" font-size="{size}" fill="{color}" text-anchor="{anchor}" font-weight="{weight}">{t}</text>')
    def raw(s, t): s.o.append(t)

def save(path, W, H, body, title):
    svg = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" font-family="DejaVu Sans, Arial, sans-serif">'
           f'<rect width="{W}" height="{H}" fill="#FFFFFF"/>'
           f'<text x="30" y="36" font-size="20" font-weight="600" fill="#2C2C2A">{title}</text>' + ''.join(body) + '</svg>')
    open(path, 'w').write(svg)

# palette
COL = {
 'elem': ('#FAC775', '#EF9F27', '#BA7517'),
 'plen': ('#B5D4F4', '#85B7EB', '#378ADD'),
 'exh':  ('#F1EFE8', '#D3D1C7', '#B4B2A9'),
 'rout': ('#EEEDFE', '#CECBF6', '#AFA9EC'),
 'cov':  ('#D3D1C7', '#B4B2A9', '#888780'),
 'base': ('#B4B2A9', '#888780', '#5F5E5A'),
}
