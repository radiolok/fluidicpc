"""Tiny SVG helper shared by the schematic diagrams."""
P = {  # fill, stroke, title, text
 'in':   ('#F1EFE8', '#888780', '#2C2C2A', '#5F5E5A'),
 'rec':  ('#E1F5EE', '#1D9E75', '#04342C', '#0F6E56'),
 'reg':  ('#EEEDFE', '#7F77DD', '#26215C', '#534AB7'),
 'alu':  ('#E6F1FB', '#378ADD', '#042C53', '#185FA5'),
 'ctl':  ('#FAECE7', '#D85A30', '#4A1B0C', '#993C1D'),
 'dsp':  ('#FAEEDA', '#BA7517', '#412402', '#854F0B'),
 'air':  ('#E6F1FB', '#378ADD', '#042C53', '#185FA5'),
 'exh':  ('#F1EFE8', '#888780', '#2C2C2A', '#5F5E5A'),
}
class Svg:
    def __init__(s, W, H, title=None):
        s.W, s.H, s.o, s.title = W, H, [], title
    def esc(s, t): return t.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
    def text(s, x, y, t, size=13, color='#2C2C2A', anchor='start', weight=400, italic=False):
        st = ' font-style="italic"' if italic else ''
        s.o.append(f'<text x="{x}" y="{y}" font-size="{size}" fill="{color}" text-anchor="{anchor}" font-weight="{weight}"{st}>{s.esc(t)}</text>')
    def rect(s, x, y, w, h, fill, stroke, sw=1.5, rx=6, dash=None):
        d = f' stroke-dasharray="{dash}"' if dash else ''
        s.o.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"{d}/>')
    def box(s, x, y, w, h, kind, title, count='', lines=(), tsize=14):
        f, st, t, tx = P[kind]
        s.rect(x, y, w, h, f, st)
        s.text(x + 10, y + 20, title, tsize, t, weight=600)
        if count: s.text(x + w - 10, y + 20, count, 13, t, 'end', 600)
        for i, l in enumerate(lines): s.text(x + 10, y + 38 + 16 * i, l, 12, tx)
    def line(s, pts, label=None, lx=None, ly=None, kind='data', head=True, la='start', width=None):
        st = {'data': ('#444441', '', 1.6), 'ctl': ('#D85A30', 'stroke-dasharray="6 4"', 1.4),
              'clk': ('#7F77DD', 'stroke-dasharray="2 4"', 1.6), 'air': ('#378ADD', '', 3.0),
              'exh': ('#888780', 'stroke-dasharray="8 5"', 2.2)}[kind]
        d = 'M' + ' L'.join(f'{x},{y}' for x, y in pts)
        mk = f'marker-end="url(#ah_{kind})"' if head else ''
        s.o.append(f'<path d="{d}" fill="none" stroke="{st[0]}" stroke-width="{width or st[2]}" {st[1]} {mk}/>')
        if label:
            if lx is None: lx, ly = pts[-2][0] + 4, pts[-2][1] - 5
            s.text(lx, ly, label, 12, st[0], la)
    def raw(s, t): s.o.append(t)
    def save(s, path):
        defs = ''.join(f'<marker id="ah_{k}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M1 1L9 5L1 9" fill="none" stroke="{c}" stroke-width="1.6"/></marker>'
                       for k, c in [('data', '#444441'), ('ctl', '#D85A30'), ('clk', '#7F77DD'), ('air', '#378ADD'), ('exh', '#888780')])
        head = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{s.W}" height="{s.H}" viewBox="0 0 {s.W} {s.H}" font-family="DejaVu Sans, Arial, sans-serif">'
                f'<defs>{defs}</defs><rect width="{s.W}" height="{s.H}" fill="#FFFFFF"/>')
        if s.title: head += f'<text x="30" y="34" font-size="20" font-weight="600" fill="#2C2C2A">{s.esc(s.title)}</text>'
        open(path, 'w').write(head + ''.join(s.o) + '</svg>')

from render import render, img  # noqa: E402,F401
