"""Иерархия нетлиста: верхний уровень → 4 блока → 8 даёв (числа берутся из netlist_info.json)."""
import json
from pathlib import Path

from svgkit import Svg, P, render, img

info = json.load(open(Path(__file__).resolve().parents[2] / 'netlist' / 'netlist_info.json'))
st, bl = info['stats'], info['blocks']
s = Svg(1500, 580, 'Иерархия структурного нетлиста')
s.box(560, 70, 380, 80, 'in', 'fluidic_calc_top', str(sum(v[0] for v in st.values())),
      ['pix[34:0], btn  →  seg[27:0], sign', f'межблочных линий: {info["interblock_nets"]} (соединений {info["interblock_links"]})'])
BLK = [('b1_retina', 'B1 «Сетчатка»', 'rec', ('d1_retina_a', 'd2_retina_b')),
       ('b2_ctrl', 'B2 «Управление и ввод»', 'ctl', ('d3_ctrl_a', 'd4_ctrl_b')),
       ('b3_alu', 'B3 «АЛУ и результат»', 'alu', ('d5_alu_a', 'd6_alu_b')),
       ('b4_disp', 'B4 «Индикация»', 'dsp', ('d7_disp_a', 'd8_disp_b'))]
DESC = {'d1_retina_a': ['19 ключей,', 'нейроны 0–7'], 'd2_retina_b': ['7 ключей, нейроны', '8, 9, + − × = C,', 'шифратор'],
        'd3_ctrl_a': ['автомат, синхр.,', 'регистр Y, OP, знак'], 'd4_ctrl_b': ['регистр X,', 'декремент,', 'генератор фаз'],
        'd5_alu_a': ['мукс B, доп. до 9,', 'BCD-сумматор'], 'd6_alu_b': ['регистр R,', 'маска A, инкремент'],
        'd7_disp_a': ['мукс индикации,', 'гашение, дешифр.', 'единиц и десятков'], 'd8_disp_b': ['дешифраторы', 'сотен и тысяч']}
for i, (bm, title, kind, dies) in enumerate(BLK):
    x = 30 + i * 365
    total = sum(st[d][0] for d in dies)
    s.box(x, 210, 340, 70, kind, bm, str(total), [title, f'порты на кромке: вход {bl[bm][0]}, выход {bl[bm][1]}'])
    s.line([(750, 150), (750, 180), (x + 170, 180), (x + 170, 208)])
    for j, dm in enumerate(dies):
        xx = x + j * 175
        n, i_, o_, cnt = st[dm]
        cells = ', '.join(f'{k} {v}' for k, v in sorted(cnt.items(), key=lambda kv: -kv[1]))
        lines = DESC[dm] + [f'вх. {i_} / вых. {o_}']
        s.box(xx, 340, 165, 170, kind, dm, str(n), lines, tsize=13)
        words, row, rows_ = cells.split(', '), '', []
        for w in words:
            if len(row) + len(w) > 22: rows_.append(row); row = w
            else: row = (row + ', ' + w) if row else w
        rows_.append(row)
        for r, t in enumerate(rows_):
            s.text(xx + 10, 458 + 15 * r, t, 11, P[kind][3])
        s.line([(x + 170, 280), (x + 170, 310), (xx + 82, 310), (xx + 82, 338)])
s.text(30, 550, 'Число в углу — элементы (экземпляры ячеек AND/OR/NOR/NOT/XOR/RS/KEY/OSC). Дай B каждого блока — та же плата, перевёрнутая.', 12, '#5F5E5A')
s.save(img('hierarchy.svg')); render(img('hierarchy.svg'), img('hierarchy.png'))
