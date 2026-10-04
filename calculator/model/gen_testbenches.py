"""Генератор тестбенчей и таблицы символов.

  rtl/calc_glyphs.vh     — функция glyph(c): 35-битный образ символа 5×7
  netlist/tb_netlist.v   — самопроверка структурного нетлиста с настоящим генератором фаз
  netlist/tb_cosim.v     — сверка нетлиста и высокоуровневой модели такт в такт

Запуск после gen_netlist.py: python3 gen_testbenches.py
"""
import json
from pathlib import Path

from glyphs import G, CLASSES

HERE = Path(__file__).resolve().parent
RTL, NET = HERE.parent / 'rtl', HERE.parent / 'netlist'
info = json.load(open(NET / 'netlist_info.json'))
P = {k: 'dut.' + v for k, v in info['paths'].items()}

L = ['// Образы символов 5×7 для тестбенчей. Сгенерировано model/gen_testbenches.py.',
     '// Бит r*5+c — строка r сверху, столбец c слева; 1 — пиксель силуэта.',
     'function [34:0] glyph;', '    input [7:0] c;', '    begin', '        case (c)']
for c in CLASSES:
    bits = ''.join(str(G[c][i]) for i in reversed(range(35)))
    L.append(f'            "{c}": glyph = 35\'b{bits};')
L += ["            default: glyph = 35'b0;", '        endcase', '    end', 'endfunction', '']
(RTL / 'calc_glyphs.vh').write_text('\n'.join(L))

COMMON = r'''
    // ---- проверка по табло ----
    function integer dig;
        input [6:0] s;
        begin
            case (s)
                7'h3F: dig = 0;  7'h06: dig = 1;  7'h5B: dig = 2;  7'h4F: dig = 3;  7'h66: dig = 4;
                7'h6D: dig = 5;  7'h7D: dig = 6;  7'h07: dig = 7;  7'h7F: dig = 8;  7'h6F: dig = 9;
                7'h00: dig = -1;
                default: dig = -2;
            endcase
        end
    endfunction
    function integer shown;
        input [27:0] s;
        input sg;
        integer k, v, x;
        begin
            v = 0;
            for (k = 3; k >= 0; k = k - 1) begin
                x = dig(s[7*k +: 7]);
                if (x == -2) v = 99999; else if (x >= 0) v = v * 10 + x;
            end
            shown = sg ? -v : v;
        end
    endfunction
'''

TASKS = r'''
    task press;
        input [7:0] c;
        begin
            pix = glyph(c); btn = 1;
            cycle; cycle; cycle;
            btn = 0; pix = 0;
            cycle;
            while (BUSY) cycle;
            cycle;
        end
    endtask

    task calc;
        input integer a;
        input [7:0] op;
        input integer b;
        integer e, got;
        begin
            press("C");
            if (a >= 10) press("0" + a / 10);
            press("0" + a % 10);
            press(op);
            if (b >= 10) press("0" + b / 10);
            press("0" + b % 10);
            press("=");
            e = (op == "+") ? a + b : (op == "-") ? a - b : a * b;
            got = shown(SEG, SIGN);
            if (got !== e) begin
                fails = fails + 1;
                $display("FAIL %0d %s %0d -> %0d, ожидалось %0d", a, op, b, got, e);
            end else
                $display("ok   %0d %s %0d = %0d", a, op, b, e);
        end
    endtask
'''

def tb(name, title, decls, cycle_body, busy, seg, sign, extra=''):
    return f'''// {title}
// Сгенерировано model/gen_testbenches.py.
`timescale 1ms/10us
module {name};
    reg  [34:0] pix = 0;
    reg         btn = 0;
    integer     fails = 0, t, a, b, o;
{decls}
`include "calc_glyphs.vh"
{COMMON}
    task cycle;
        begin
{cycle_body}
        end
    endtask
{TASKS.replace('BUSY', busy).replace('SEG', seg).replace('SIGN', sign)}
{extra}
    initial begin
        repeat (4) cycle;
        calc(12, "+", 34); calc(99, "+", 99); calc(5, "-", 8); calc(50, "-", 50);
        calc(99, "x", 99); calc(7, "x", 0);  calc(64, "x", 25);
        for (t = 0; t < 40; t = t + 1) begin
            a = {{$random}} % 100; b = {{$random}} % 100; o = {{$random}} % 3;
            calc(a, o == 0 ? "+" : o == 1 ? "-" : "x", b);
        end
        $display("ИТОГО ошибок: %0d", fails);
        if (fails) $display("РЕЗУЛЬТАТ: FAIL"); else $display("РЕЗУЛЬТАТ: OK");
        $finish;
    end
endmodule
'''

(NET / 'tb_netlist.v').write_text(tb(
    'tb_netlist', 'Самопроверка структурного нетлиста с генератором фаз (такт = фаза Ф3).',
    '    wire [27:0] seg;\n    wire        sign;\n'
    '    fluidic_calc_top dut (.pix(pix), .btn(btn), .seg(seg), .sign(sign));',
    f'            @(posedge {P["ph3"]});',
    f"({P['run']} === 1'b1 || {P['neg']} === 1'b1)", 'seg', 'sign'))

(NET / 'tb_cosim.v').write_text(tb(
    'tb_cosim', 'Сверка структурного нетлиста и высокоуровневой модели такт в такт.\n'
    '// Модель тактируется фазой Ф3 нетлиста, а входы берёт защёлкнутыми на Ф2 — как нетлист.',
    '    wire [27:0] seg, seg_rtl;\n    wire        sign, sign_rtl;\n    reg  [34:0] pix_s = 0;\n    reg         btn_s = 0;\n'
    '    integer     mism = 0, cycles = 0;\n'
    '    fluidic_calc_top dut (.pix(pix), .btn(btn), .seg(seg), .sign(sign));\n'
    f'    always @(posedge {P["ph2"]}) begin pix_s <= pix; btn_s <= btn; end\n'
    f'    fluidic_calc_rtl u_ref (.clk({P["ph3"]}), .pix(pix_s), .btn(btn_s), .seg(seg_rtl), .sign(sign_rtl));',
    f'            @(posedge {P["ph3"]});',
    f"({P['run']} === 1'b1 || {P['neg']} === 1'b1)", 'seg', 'sign',
    extra=f'''    // сверка каждый такт: на Ф1 следующего такта оба табло установились
    always @(posedge {P['ph1']}) begin
        cycles = cycles + 1;
        if (seg !== seg_rtl || sign !== sign_rtl) begin
            mism = mism + 1;
            if (mism < 10) $display("%t РАСХОЖДЕНИЕ: нетлист %h/%b, модель %h/%b", $time, seg, sign, seg_rtl, sign_rtl);
        end
    end
''').replace('        $display("ИТОГО ошибок: %0d", fails);\n        if (fails) $display("РЕЗУЛЬТАТ: FAIL"); else $display("РЕЗУЛЬТАТ: OK");',
             '        $display("ИТОГО ошибок: %0d, тактов сверено: %0d, расхождений: %0d", fails, cycles, mism);\n        if (fails || mism) $display("РЕЗУЛЬТАТ: FAIL"); else $display("РЕЗУЛЬТАТ: OK");'))
(RTL / 'tb_rtl.v').write_text(tb(
    'tb_rtl', 'Самопроверка высокоуровневой модели.',
    '    reg         clk = 0;\n    wire [27:0] seg;\n    wire        sign;\n    always #1 clk = ~clk;\n'
    '    fluidic_calc_rtl dut (.clk(clk), .pix(pix), .btn(btn), .seg(seg), .sign(sign));',
    '            @(posedge clk); #0.5;',
    "(dut.st_run === 1'b1 || dut.st_neg === 1'b1)", 'seg', 'sign'))
print('ok')
