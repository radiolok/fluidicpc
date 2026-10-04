// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Блок B3 «АЛУ и результат»: два зеркальных дая и общий соединительный пакет.
// Порты на нижней кромке: входов 25, выходов 26. Переходов между даями: 17.

module b3_alu (
    alu_keep_r, alu_sub, en_r, ph1, ph2, ph3,
    run_step, sel_x, st_neg, x_reg0, x_reg1, x_reg2,
    x_reg3, x_reg4, x_reg5, x_reg6, x_reg7, y_reg0,
    y_reg1, y_reg2, y_reg3, y_reg4, y_reg5, y_reg6,
    y_reg7, alu_c2, n_or582, r_reg0, r_reg1, r_reg10,
    r_reg11, r_reg12, r_reg13, r_reg14, r_reg15, r_reg2,
    r_reg3, r_reg4, r_reg5, r_reg6, r_reg7, r_reg8,
    r_reg9, r_reg_n10, r_reg_n11, r_reg_n12, r_reg_n13, r_reg_n14,
    r_reg_n15, r_reg_n8, r_reg_n9
);
    input alu_keep_r;
    input alu_sub;
    input en_r;
    input ph1;
    input ph2;
    input ph3;
    input run_step;
    input sel_x;
    input st_neg;
    input x_reg0;
    input x_reg1;
    input x_reg2;
    input x_reg3;
    input x_reg4;
    input x_reg5;
    input x_reg6;
    input x_reg7;
    input y_reg0;
    input y_reg1;
    input y_reg2;
    input y_reg3;
    input y_reg4;
    input y_reg5;
    input y_reg6;
    input y_reg7;
    output alu_c2;
    output n_or582;
    output r_reg0;
    output r_reg1;
    output r_reg10;
    output r_reg11;
    output r_reg12;
    output r_reg13;
    output r_reg14;
    output r_reg15;
    output r_reg2;
    output r_reg3;
    output r_reg4;
    output r_reg5;
    output r_reg6;
    output r_reg7;
    output r_reg8;
    output r_reg9;
    output r_reg_n10;
    output r_reg_n11;
    output r_reg_n12;
    output r_reg_n13;
    output r_reg_n14;
    output r_reg_n15;
    output r_reg_n8;
    output r_reg_n9;

    wire alu_a0, alu_a1, alu_a2, alu_a3, alu_a4, alu_a5, alu_a6, alu_a7;
    wire alu_c2_hi, alu_s0, alu_s1, alu_s2, alu_s3, alu_s4, alu_s5, alu_s6;
    wire alu_s7;

    d5_alu_a u_die_a (
        .alu_a0(alu_a0),
        .alu_a1(alu_a1),
        .alu_a2(alu_a2),
        .alu_a3(alu_a3),
        .alu_a4(alu_a4),
        .alu_a5(alu_a5),
        .alu_a6(alu_a6),
        .alu_a7(alu_a7),
        .alu_sub(alu_sub),
        .r_reg0(r_reg0),
        .r_reg1(r_reg1),
        .r_reg2(r_reg2),
        .r_reg3(r_reg3),
        .r_reg4(r_reg4),
        .r_reg5(r_reg5),
        .r_reg6(r_reg6),
        .r_reg7(r_reg7),
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
        .alu_c2_hi(alu_c2_hi),
        .alu_s0(alu_s0),
        .alu_s1(alu_s1),
        .alu_s2(alu_s2),
        .alu_s3(alu_s3),
        .alu_s4(alu_s4),
        .alu_s5(alu_s5),
        .alu_s6(alu_s6),
        .alu_s7(alu_s7)
    );

    d6_alu_b u_die_b (
        .alu_c2_hi(alu_c2_hi),
        .alu_keep_r(alu_keep_r),
        .alu_s0(alu_s0),
        .alu_s1(alu_s1),
        .alu_s2(alu_s2),
        .alu_s3(alu_s3),
        .alu_s4(alu_s4),
        .alu_s5(alu_s5),
        .alu_s6(alu_s6),
        .alu_s7(alu_s7),
        .en_r(en_r),
        .ph1(ph1),
        .ph2(ph2),
        .ph3(ph3),
        .alu_a0(alu_a0),
        .alu_a1(alu_a1),
        .alu_a2(alu_a2),
        .alu_a3(alu_a3),
        .alu_a4(alu_a4),
        .alu_a5(alu_a5),
        .alu_a6(alu_a6),
        .alu_a7(alu_a7),
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

endmodule
