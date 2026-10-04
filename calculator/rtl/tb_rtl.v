// Самопроверка высокоуровневой модели.
// Сгенерировано model/gen_testbenches.py.
`timescale 1ms/10us
module tb_rtl;
    reg  [34:0] pix = 0;
    reg         btn = 0;
    integer     fails = 0, t, a, b, o;
    reg         clk = 0;
    wire [27:0] seg;
    wire        sign;
    always #1 clk = ~clk;
    fluidic_calc_rtl dut (.clk(clk), .pix(pix), .btn(btn), .seg(seg), .sign(sign));
`include "calc_glyphs.vh"

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

    task cycle;
        begin
            @(posedge clk); #0.5;
        end
    endtask

    task press;
        input [7:0] c;
        begin
            pix = glyph(c); btn = 1;
            cycle; cycle; cycle;
            btn = 0; pix = 0;
            cycle;
            while ((dut.st_run === 1'b1 || dut.st_neg === 1'b1)) cycle;
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
            got = shown(seg, sign);
            if (got !== e) begin
                fails = fails + 1;
                $display("FAIL %0d %s %0d -> %0d, ожидалось %0d", a, op, b, got, e);
            end else
                $display("ok   %0d %s %0d = %0d", a, op, b, e);
        end
    endtask


    initial begin
        repeat (4) cycle;
        calc(12, "+", 34); calc(99, "+", 99); calc(5, "-", 8); calc(50, "-", 50);
        calc(99, "x", 99); calc(7, "x", 0);  calc(64, "x", 25);
        for (t = 0; t < 40; t = t + 1) begin
            a = {$random} % 100; b = {$random} % 100; o = {$random} % 3;
            calc(a, o == 0 ? "+" : o == 1 ? "-" : "x", b);
        end
        $display("ИТОГО ошибок: %0d", fails);
        if (fails) $display("РЕЗУЛЬТАТ: FAIL"); else $display("РЕЗУЛЬТАТ: OK");
        $finish;
    end
endmodule
