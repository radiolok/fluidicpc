// Струйный калькулятор — высокоуровневая (поведенческая) модель.
//
// Эталон для сверки со структурным нетлистом: те же регистры, события и уравнения,
// но записанные арифметикой, а не вентилями. Один фронт clk — один такт машины
// (в нетлисте это фаза Ф3, когда ведомые ячейки перенимают новое состояние).
// Потактовая эквивалентность с вентильной моделью проверена model/rtl_model.py
// и тестбенчем netlist/tb_cosim.v.
//
// pix[r*5+c]: r = 0..6 строка сверху, c = 0..4 столбец слева; 1 — трубочка закрыта.
// seg[7*k+j]: k = 0 единицы ... 3 тысячи; j = 0..6 сегменты a..g.

`timescale 1ms/10us

// ---------------------------------------------------------------------------
// Распознаватель: 15 нейронов с троичными весами. Нейрон срабатывает, если среди
// пикселей, на которые он смотрит, не совпал с образцом максимум один.
// cls: [9:0] цифры 0..9, [10] «+», [11] «−», [12] «×», [13] «=», [14] «C».
// ---------------------------------------------------------------------------
module calc_recognizer (
    input  wire [34:0] pix,
    output wire [14:0] cls
);
    //                 смотрим на пиксели          их ожидаемые значения
    localparam [34:0] CARE_D0    = 35'h00069c000, VAL_D0    = 35'h00028c000;
    localparam [34:0] CARE_D1    = 35'h228040040, VAL_D1    = 35'h208000040;
    localparam [34:0] CARE_D2    = 35'h044520000, VAL_D2    = 35'h044400000;
    localparam [34:0] CARE_D3    = 35'h020002510, VAL_D3    = 35'h020000110;
    localparam [34:0] CARE_D4    = 35'h010001184, VAL_D4    = 35'h010000180;
    localparam [34:0] CARE_D5    = 35'h0002c0810, VAL_D5    = 35'h000080810;
    localparam [34:0] CARE_D6    = 35'h000098640, VAL_D6    = 35'h000018440;
    localparam [34:0] CARE_D7    = 35'h204200810, VAL_D7    = 35'h004200010;
    localparam [34:0] CARE_D8    = 35'h02019c200, VAL_D8    = 35'h020114200;
    localparam [34:0] CARE_D9    = 35'h230040404, VAL_D9    = 35'h010040404;
    localparam [34:0] CARE_PLUS  = 35'h208410084, VAL_PLUS  = 35'h008410080;
    localparam [34:0] CARE_MINUS = 35'h00048b488, VAL_MINUS = 35'h000088000;
    localparam [34:0] CARE_MUL   = 35'h020000e08, VAL_MUL   = 35'h020000a00;
    localparam [34:0] CARE_EQ    = 35'h000125008, VAL_EQ    = 35'h000105000;
    localparam [34:0] CARE_CLR   = 35'h000166200, VAL_CLR   = 35'h000100200;

    function match;                       // не более одного несовпадения
        input [34:0] p, care, val;
        integer i, miss;
        begin
            miss = 0;
            for (i = 0; i < 35; i = i + 1)
                if (care[i] && (p[i] != val[i])) miss = miss + 1;
            match = (miss <= 1);
        end
    endfunction

    assign cls = {match(pix, CARE_CLR,  VAL_CLR),  match(pix, CARE_EQ,    VAL_EQ),
                  match(pix, CARE_MUL,  VAL_MUL),  match(pix, CARE_MINUS, VAL_MINUS),
                  match(pix, CARE_PLUS, VAL_PLUS),
                  match(pix, CARE_D9, VAL_D9), match(pix, CARE_D8, VAL_D8), match(pix, CARE_D7, VAL_D7),
                  match(pix, CARE_D6, VAL_D6), match(pix, CARE_D5, VAL_D5), match(pix, CARE_D4, VAL_D4),
                  match(pix, CARE_D3, VAL_D3), match(pix, CARE_D2, VAL_D2), match(pix, CARE_D1, VAL_D1),
                  match(pix, CARE_D0, VAL_D0)};
endmodule

// ---------------------------------------------------------------------------
// Дешифратор цифры в 7 сегментов {g,f,e,d,c,b,a} с гашением.
// ---------------------------------------------------------------------------
module calc_seg7 (
    input  wire [3:0] digit,
    input  wire       en,
    output reg  [6:0] seg
);
    always @* begin
        if (!en) seg = 7'h00;
        else case (digit)
            4'd0: seg = 7'h3F;  4'd1: seg = 7'h06;  4'd2: seg = 7'h5B;  4'd3: seg = 7'h4F;
            4'd4: seg = 7'h66;  4'd5: seg = 7'h6D;  4'd6: seg = 7'h7D;  4'd7: seg = 7'h07;
            4'd8: seg = 7'h7F;  4'd9: seg = 7'h6F;
            default: seg = 7'h00;
        endcase
    end
endmodule

// ---------------------------------------------------------------------------
// Калькулятор
// ---------------------------------------------------------------------------
module fluidic_calc_rtl (
    input  wire        clk,     // такт машины
    input  wire [34:0] pix,
    input  wire        btn,     // кнопка «Ввод»
    output wire [27:0] seg,
    output wire        sign
);
    // ---------------- состояние ----------------
    reg       s1, s2;           // синхронизатор кнопки
    reg       st_run;           // идёт умножение
    reg       st_neg;           // такт коррекции отрицательного результата
    reg       st_show;          // на табло результат (иначе — набираемое число)
    reg [7:0] x_reg;            // набираемое число, 2 BCD-цифры {десятки, единицы}
    reg [7:0] y_reg;            // первый операнд
    reg [15:0] r_reg;           // результат, 4 BCD-цифры
    reg       op_sub, op_mul;   // отложенная операция («+», если обе 0)
    reg       sgn;              // знак результата

    initial begin
        s1 = 0; s2 = 0; st_run = 0; st_neg = 0; st_show = 0;
        x_reg = 0; y_reg = 0; r_reg = 0; op_sub = 0; op_mul = 0; sgn = 0;
    end

    // ---------------- распознавание и шифратор ----------------
    wire [14:0] cls;
    calc_recognizer u_rec (.pix(pix), .cls(cls));
    wire [9:0] d = cls[9:0];
    wire k_plus = cls[10], k_minus = cls[11], k_mul = cls[12], k_eq = cls[13], k_clr = cls[14];
    // шифратор — ИЛИ по классам, как в нетлисте
    wire [3:0] key_bcd = {d[8] | d[9],
                          d[4] | d[5] | d[6] | d[7],
                          d[2] | d[3] | d[6] | d[7],
                          d[1] | d[3] | d[5] | d[7] | d[9]};
    wire is_digit = |d;
    wire is_op    = k_plus | k_minus | k_mul;

    // ---------------- события (один такт на нажатие) ----------------
    wire key_pulse   = s1 & ~s2;
    wire key_act     = key_pulse & ~(st_run | st_neg);     // во время счёта кнопки не принимаются
    wire ev_digit    = key_act & is_digit;
    wire ev_op       = key_act & is_op & ~st_show;         // после результата операции не принимаются
    wire ev_eq       = key_act & k_eq  & ~st_show;
    wire ev_clr      = key_act & k_clr;
    wire ev_fresh    = ev_digit & st_show;                 // цифра после результата — новый пример
    wire ev_clr_all  = ev_clr | ev_fresh;

    wire x_nonzero   = |x_reg;
    wire run_step    = st_run & x_nonzero;                 // шаг умножения: R += Y, X -= 1
    wire eq_addsub   = ev_eq & ~op_mul;
    wire eq_sub      = ev_eq & op_sub;
    wire alu_sub     = eq_sub | st_neg;                    // вычитание: B -> 99 - B, перенос 1
    wire sel_x       = (ev_op & ~k_mul) | eq_addsub;
    wire sel_y       = run_step;
    wire sel_r       = st_neg;
    wire alu_keep_r  = ~(ev_op | st_neg | ev_clr_all);     // иначе A = 0
    wire en_r        = ev_op | eq_addsub | run_step | st_neg | ev_clr_all;
    wire en_x        = ev_digit | ev_op | ev_clr | run_step;
    wire ld_op       = ev_op | ev_clr_all;

    // ---------------- АЛУ ----------------
    function [4:0] bcd_add;                // {перенос, цифра}
        input [3:0] a, b;
        input       cin;
        reg   [4:0] s;
        begin
            s = a + b + cin;
            bcd_add = (s > 9) ? {1'b1, s[3:0] + 4'd6} : {1'b0, s[3:0]};
        end
    endfunction

    wire [7:0]  b_sel = ({8{sel_x}} & x_reg) | ({8{sel_y}} & y_reg) | ({8{sel_r}} & r_reg[7:0]);
    wire [7:0]  b_op  = alu_sub ? {4'd9 - b_sel[7:4], 4'd9 - b_sel[3:0]} : b_sel;
    wire [15:0] a_op  = alu_keep_r ? r_reg : 16'd0;
    wire [4:0]  add0  = bcd_add(a_op[3:0],   b_op[3:0], alu_sub);
    wire [4:0]  add1  = bcd_add(a_op[7:4],   b_op[7:4], add0[4]);
    wire        c2    = add1[4];
    wire [4:0]  inc2  = bcd_add(a_op[11:8],  4'd0, c2 & ~alu_sub);   // при вычитании старшие не трогаем
    wire [4:0]  inc3  = bcd_add(a_op[15:12], 4'd0, inc2[4]);
    wire [15:0] alu_sum = {inc3[3:0], inc2[3:0], add1[3:0], add0[3:0]};

    // счётчик умножения: X - 1 в BCD
    wire [7:0] x_dec = (x_reg[3:0] == 4'd0) ? {x_reg[7:4] - 4'd1, 4'd9}
                                             : {x_reg[7:4], x_reg[3:0] - 4'd1};

    // ---------------- переход ----------------
    always @(posedge clk) begin
        s1 <= btn;
        s2 <= s1;
        st_run  <= (ev_eq & op_mul) | run_step;
        st_neg  <= eq_sub & ~c2;                           // разность отрицательна: ещё такт
        st_show <= (st_show & ~(ev_digit | ev_clr)) | (ev_eq & ~(eq_sub & ~c2)) | st_neg;
        if (en_x)
            x_reg <= ev_digit ? {(st_show ? 4'd0 : x_reg[3:0]), key_bcd}
                   : run_step ? x_dec
                   : 8'd0;
        if (en_r)  r_reg <= alu_sum;
        if (ev_op) y_reg <= x_reg;
        if (ld_op) {op_mul, op_sub} <= {k_mul, k_minus};
        if (st_neg)                    sgn <= 1'b1;
        else if (ev_op | ev_clr_all)   sgn <= 1'b0;
    end

    // ---------------- индикация с гашением незначащих нулей ----------------
    wire [7:0] disp_lo = st_show ? r_reg[7:0] : x_reg;
    wire nz3 = |r_reg[15:12];
    wire nz2 = |r_reg[11:8];
    wire en3 = st_show & nz3;
    wire en2 = st_show & (nz3 | nz2);
    wire en1 = en2 | (|disp_lo[7:4]);

    calc_seg7 u_seg0 (.digit(disp_lo[3:0]), .en(1'b1), .seg(seg[6:0]));
    calc_seg7 u_seg1 (.digit(disp_lo[7:4]), .en(en1),  .seg(seg[13:7]));
    calc_seg7 u_seg2 (.digit(r_reg[11:8]),  .en(en2),  .seg(seg[20:14]));
    calc_seg7 u_seg3 (.digit(r_reg[15:12]), .en(en3),  .seg(seg[27:21]));
    assign sign = sgn;
endmodule
