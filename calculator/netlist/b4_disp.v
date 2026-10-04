// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Блок B4 «Индикация»: два зеркальных дая и общий соединительный пакет.
// Порты на нижней кромке: входов 35, выходов 28. Переходов между даями: 2.

module b4_disp (
    n_or582, r_reg0, r_reg1, r_reg10, r_reg11, r_reg12,
    r_reg13, r_reg14, r_reg15, r_reg2, r_reg3, r_reg4,
    r_reg5, r_reg6, r_reg7, r_reg8, r_reg9, r_reg_n10,
    r_reg_n11, r_reg_n12, r_reg_n13, r_reg_n14, r_reg_n15, r_reg_n8,
    r_reg_n9, st_show, st_show_n, x_reg0, x_reg1, x_reg2,
    x_reg3, x_reg4, x_reg5, x_reg6, x_reg7, seg_d0_a,
    seg_d0_b, seg_d0_c, seg_d0_d, seg_d0_e, seg_d0_f, seg_d0_g,
    seg_d1_a, seg_d1_b, seg_d1_c, seg_d1_d, seg_d1_e, seg_d1_f,
    seg_d1_g, seg_d2_a, seg_d2_b, seg_d2_c, seg_d2_d, seg_d2_e,
    seg_d2_f, seg_d2_g, seg_d3_a, seg_d3_b, seg_d3_c, seg_d3_d,
    seg_d3_e, seg_d3_f, seg_d3_g
);
    input n_or582;
    input r_reg0;
    input r_reg1;
    input r_reg10;
    input r_reg11;
    input r_reg12;
    input r_reg13;
    input r_reg14;
    input r_reg15;
    input r_reg2;
    input r_reg3;
    input r_reg4;
    input r_reg5;
    input r_reg6;
    input r_reg7;
    input r_reg8;
    input r_reg9;
    input r_reg_n10;
    input r_reg_n11;
    input r_reg_n12;
    input r_reg_n13;
    input r_reg_n14;
    input r_reg_n15;
    input r_reg_n8;
    input r_reg_n9;
    input st_show;
    input st_show_n;
    input x_reg0;
    input x_reg1;
    input x_reg2;
    input x_reg3;
    input x_reg4;
    input x_reg5;
    input x_reg6;
    input x_reg7;
    output seg_d0_a;
    output seg_d0_b;
    output seg_d0_c;
    output seg_d0_d;
    output seg_d0_e;
    output seg_d0_f;
    output seg_d0_g;
    output seg_d1_a;
    output seg_d1_b;
    output seg_d1_c;
    output seg_d1_d;
    output seg_d1_e;
    output seg_d1_f;
    output seg_d1_g;
    output seg_d2_a;
    output seg_d2_b;
    output seg_d2_c;
    output seg_d2_d;
    output seg_d2_e;
    output seg_d2_f;
    output seg_d2_g;
    output seg_d3_a;
    output seg_d3_b;
    output seg_d3_c;
    output seg_d3_d;
    output seg_d3_e;
    output seg_d3_f;
    output seg_d3_g;

    wire disp_en2, disp_en3;

    d7_disp_a u_die_a (
        .n_or582(n_or582),
        .r_reg0(r_reg0),
        .r_reg1(r_reg1),
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
        .disp_en2(disp_en2),
        .disp_en3(disp_en3),
        .seg_d0_a(seg_d0_a),
        .seg_d0_b(seg_d0_b),
        .seg_d0_c(seg_d0_c),
        .seg_d0_d(seg_d0_d),
        .seg_d0_e(seg_d0_e),
        .seg_d0_f(seg_d0_f),
        .seg_d0_g(seg_d0_g),
        .seg_d1_a(seg_d1_a),
        .seg_d1_b(seg_d1_b),
        .seg_d1_c(seg_d1_c),
        .seg_d1_d(seg_d1_d),
        .seg_d1_e(seg_d1_e),
        .seg_d1_f(seg_d1_f),
        .seg_d1_g(seg_d1_g)
    );

    d8_disp_b u_die_b (
        .disp_en2(disp_en2),
        .disp_en3(disp_en3),
        .r_reg10(r_reg10),
        .r_reg11(r_reg11),
        .r_reg12(r_reg12),
        .r_reg13(r_reg13),
        .r_reg14(r_reg14),
        .r_reg15(r_reg15),
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
        .seg_d2_a(seg_d2_a),
        .seg_d2_b(seg_d2_b),
        .seg_d2_c(seg_d2_c),
        .seg_d2_d(seg_d2_d),
        .seg_d2_e(seg_d2_e),
        .seg_d2_f(seg_d2_f),
        .seg_d2_g(seg_d2_g),
        .seg_d3_a(seg_d3_a),
        .seg_d3_b(seg_d3_b),
        .seg_d3_c(seg_d3_c),
        .seg_d3_d(seg_d3_d),
        .seg_d3_e(seg_d3_e),
        .seg_d3_f(seg_d3_f),
        .seg_d3_g(seg_d3_g)
    );

endmodule
