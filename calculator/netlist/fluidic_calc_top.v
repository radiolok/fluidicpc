// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Верхний уровень: 4 вертикальных блока на объединительной плите.
// pix[r*5+c]: r = 0..6 строка сверху, c = 0..4 столбец слева; 1 — трубочка закрыта силуэтом.
// seg[7*k+j]: k = 0 единицы ... 3 тысячи; j = 0..6 сегменты a..g; 1 — блинкер открыт.
// btn — кнопка «Ввод» (или 36-я трубочка в рамке трафарета); sign — блинкер «−».

module fluidic_calc_top (pix, btn, seg, sign);
    input [34:0] pix;
    input btn;
    output [27:0] seg;
    output sign;

    // межблочные линии — каналы объединительной плиты: 63
    wire alu_c2, alu_keep_r, alu_sub, cls_clr, cls_eq, cls_minus, cls_mul, en_r;
    wire is_digit, is_op, key_bcd0, key_bcd1, key_bcd2, key_bcd3, n_or582, ph1;
    wire ph2, ph3, r_reg0, r_reg1, r_reg10, r_reg11, r_reg12, r_reg13;
    wire r_reg14, r_reg15, r_reg2, r_reg3, r_reg4, r_reg5, r_reg6, r_reg7;
    wire r_reg8, r_reg9, r_reg_n10, r_reg_n11, r_reg_n12, r_reg_n13, r_reg_n14, r_reg_n15;
    wire r_reg_n8, r_reg_n9, run_step, sel_x, st_neg, st_show, st_show_n, x_reg0;
    wire x_reg1, x_reg2, x_reg3, x_reg4, x_reg5, x_reg6, x_reg7, y_reg0;
    wire y_reg1, y_reg2, y_reg3, y_reg4, y_reg5, y_reg6, y_reg7;

    // Блок B1 «Сетчатка»
    b1_retina u_b1_retina (
        .tube_r1c3(pix[2]),
        .tube_r1c4(pix[3]),
        .tube_r1c5(pix[4]),
        .tube_r2c2(pix[6]),
        .tube_r2c3(pix[7]),
        .tube_r2c4(pix[8]),
        .tube_r2c5(pix[9]),
        .tube_r3c1(pix[10]),
        .tube_r3c2(pix[11]),
        .tube_r3c3(pix[12]),
        .tube_r3c4(pix[13]),
        .tube_r3c5(pix[14]),
        .tube_r4c1(pix[15]),
        .tube_r4c2(pix[16]),
        .tube_r4c3(pix[17]),
        .tube_r4c4(pix[18]),
        .tube_r4c5(pix[19]),
        .tube_r5c1(pix[20]),
        .tube_r5c2(pix[21]),
        .tube_r5c3(pix[22]),
        .tube_r6c2(pix[26]),
        .tube_r6c3(pix[27]),
        .tube_r6c4(pix[28]),
        .tube_r6c5(pix[29]),
        .tube_r7c1(pix[30]),
        .tube_r7c4(pix[33]),
        .cls_clr(cls_clr),
        .cls_eq(cls_eq),
        .cls_minus(cls_minus),
        .cls_mul(cls_mul),
        .is_digit(is_digit),
        .is_op(is_op),
        .key_bcd0(key_bcd0),
        .key_bcd1(key_bcd1),
        .key_bcd2(key_bcd2),
        .key_bcd3(key_bcd3)
    );

    // Блок B2 «Управление и ввод»
    b2_ctrl u_b2_ctrl (
        .alu_c2(alu_c2),
        .btn(btn),
        .cls_clr(cls_clr),
        .cls_eq(cls_eq),
        .cls_minus(cls_minus),
        .cls_mul(cls_mul),
        .is_digit(is_digit),
        .is_op(is_op),
        .key_bcd0(key_bcd0),
        .key_bcd1(key_bcd1),
        .key_bcd2(key_bcd2),
        .key_bcd3(key_bcd3),
        .alu_keep_r(alu_keep_r),
        .alu_sub(alu_sub),
        .en_r(en_r),
        .ph1(ph1),
        .ph2(ph2),
        .ph3(ph3),
        .run_step(run_step),
        .sel_x(sel_x),
        .sign(sign),
        .st_neg(st_neg),
        .st_show(st_show),
        .st_show_n(st_show_n),
        .x_reg0(x_reg0),
        .x_reg1(x_reg1),
        .x_reg2(x_reg2),
        .x_reg3(x_reg3),
        .x_reg4(x_reg4),
        .x_reg5(x_reg5),
        .x_reg6(x_reg6),
        .x_reg7(x_reg7),
        .y_reg0(y_reg0),
        .y_reg1(y_reg1),
        .y_reg2(y_reg2),
        .y_reg3(y_reg3),
        .y_reg4(y_reg4),
        .y_reg5(y_reg5),
        .y_reg6(y_reg6),
        .y_reg7(y_reg7)
    );

    // Блок B3 «АЛУ и результат»
    b3_alu u_b3_alu (
        .alu_keep_r(alu_keep_r),
        .alu_sub(alu_sub),
        .en_r(en_r),
        .ph1(ph1),
        .ph2(ph2),
        .ph3(ph3),
        .run_step(run_step),
        .sel_x(sel_x),
        .st_neg(st_neg),
        .x_reg0(x_reg0),
        .x_reg1(x_reg1),
        .x_reg2(x_reg2),
        .x_reg3(x_reg3),
        .x_reg4(x_reg4),
        .x_reg5(x_reg5),
        .x_reg6(x_reg6),
        .x_reg7(x_reg7),
        .y_reg0(y_reg0),
        .y_reg1(y_reg1),
        .y_reg2(y_reg2),
        .y_reg3(y_reg3),
        .y_reg4(y_reg4),
        .y_reg5(y_reg5),
        .y_reg6(y_reg6),
        .y_reg7(y_reg7),
        .alu_c2(alu_c2),
        .n_or582(n_or582),
        .r_reg0(r_reg0),
        .r_reg1(r_reg1),
        .r_reg10(r_reg10),
        .r_reg11(r_reg11),
        .r_reg12(r_reg12),
        .r_reg13(r_reg13),
        .r_reg14(r_reg14),
        .r_reg15(r_reg15),
        .r_reg2(r_reg2),
        .r_reg3(r_reg3),
        .r_reg4(r_reg4),
        .r_reg5(r_reg5),
        .r_reg6(r_reg6),
        .r_reg7(r_reg7),
        .r_reg8(r_reg8),
        .r_reg9(r_reg9),
        .r_reg_n10(r_reg_n10),
        .r_reg_n11(r_reg_n11),
        .r_reg_n12(r_reg_n12),
        .r_reg_n13(r_reg_n13),
        .r_reg_n14(r_reg_n14),
        .r_reg_n15(r_reg_n15),
        .r_reg_n8(r_reg_n8),
        .r_reg_n9(r_reg_n9)
    );

    // Блок B4 «Индикация»
    b4_disp u_b4_disp (
        .n_or582(n_or582),
        .r_reg0(r_reg0),
        .r_reg1(r_reg1),
        .r_reg10(r_reg10),
        .r_reg11(r_reg11),
        .r_reg12(r_reg12),
        .r_reg13(r_reg13),
        .r_reg14(r_reg14),
        .r_reg15(r_reg15),
        .r_reg2(r_reg2),
        .r_reg3(r_reg3),
        .r_reg4(r_reg4),
        .r_reg5(r_reg5),
        .r_reg6(r_reg6),
        .r_reg7(r_reg7),
        .r_reg8(r_reg8),
        .r_reg9(r_reg9),
        .r_reg_n10(r_reg_n10),
        .r_reg_n11(r_reg_n11),
        .r_reg_n12(r_reg_n12),
        .r_reg_n13(r_reg_n13),
        .r_reg_n14(r_reg_n14),
        .r_reg_n15(r_reg_n15),
        .r_reg_n8(r_reg_n8),
        .r_reg_n9(r_reg_n9),
        .st_show(st_show),
        .st_show_n(st_show_n),
        .x_reg0(x_reg0),
        .x_reg1(x_reg1),
        .x_reg2(x_reg2),
        .x_reg3(x_reg3),
        .x_reg4(x_reg4),
        .x_reg5(x_reg5),
        .x_reg6(x_reg6),
        .x_reg7(x_reg7),
        .seg_d0_a(seg[0]),
        .seg_d0_b(seg[1]),
        .seg_d0_c(seg[2]),
        .seg_d0_d(seg[3]),
        .seg_d0_e(seg[4]),
        .seg_d0_f(seg[5]),
        .seg_d0_g(seg[6]),
        .seg_d1_a(seg[7]),
        .seg_d1_b(seg[8]),
        .seg_d1_c(seg[9]),
        .seg_d1_d(seg[10]),
        .seg_d1_e(seg[11]),
        .seg_d1_f(seg[12]),
        .seg_d1_g(seg[13]),
        .seg_d2_a(seg[14]),
        .seg_d2_b(seg[15]),
        .seg_d2_c(seg[16]),
        .seg_d2_d(seg[17]),
        .seg_d2_e(seg[18]),
        .seg_d2_f(seg[19]),
        .seg_d2_g(seg[20]),
        .seg_d3_a(seg[21]),
        .seg_d3_b(seg[22]),
        .seg_d3_c(seg[23]),
        .seg_d3_d(seg[24]),
        .seg_d3_e(seg[25]),
        .seg_d3_f(seg[26]),
        .seg_d3_g(seg[27])
    );

endmodule
