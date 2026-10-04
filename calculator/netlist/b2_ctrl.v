// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Блок B2 «Управление и ввод»: два зеркальных дая и общий соединительный пакет.
// Порты на нижней кромке: входов 12, выходов 28. Переходов между даями: 3.

module b2_ctrl (
    alu_c2, btn, cls_clr, cls_eq, cls_minus, cls_mul,
    is_digit, is_op, key_bcd0, key_bcd1, key_bcd2, key_bcd3,
    alu_keep_r, alu_sub, en_r, ph1, ph2, ph3,
    run_step, sel_x, sign, st_neg, st_show, st_show_n,
    x_reg0, x_reg1, x_reg2, x_reg3, x_reg4, x_reg5,
    x_reg6, x_reg7, y_reg0, y_reg1, y_reg2, y_reg3,
    y_reg4, y_reg5, y_reg6, y_reg7
);
    input alu_c2;
    input btn;
    input cls_clr;
    input cls_eq;
    input cls_minus;
    input cls_mul;
    input is_digit;
    input is_op;
    input key_bcd0;
    input key_bcd1;
    input key_bcd2;
    input key_bcd3;
    output alu_keep_r;
    output alu_sub;
    output en_r;
    output ph1;
    output ph2;
    output ph3;
    output run_step;
    output sel_x;
    output sign;
    output st_neg;
    output st_show;
    output st_show_n;
    output x_reg0;
    output x_reg1;
    output x_reg2;
    output x_reg3;
    output x_reg4;
    output x_reg5;
    output x_reg6;
    output x_reg7;
    output y_reg0;
    output y_reg1;
    output y_reg2;
    output y_reg3;
    output y_reg4;
    output y_reg5;
    output y_reg6;
    output y_reg7;

    wire en_x, ev_digit, x_nonzero;

    d3_ctrl_a u_die_a (
        .alu_c2(alu_c2),
        .btn(btn),
        .cls_clr(cls_clr),
        .cls_eq(cls_eq),
        .cls_minus(cls_minus),
        .cls_mul(cls_mul),
        .is_digit(is_digit),
        .is_op(is_op),
        .ph1(ph1),
        .ph2(ph2),
        .ph3(ph3),
        .x_nonzero(x_nonzero),
        .x_reg0(x_reg0),
        .x_reg1(x_reg1),
        .x_reg2(x_reg2),
        .x_reg3(x_reg3),
        .x_reg4(x_reg4),
        .x_reg5(x_reg5),
        .x_reg6(x_reg6),
        .x_reg7(x_reg7),
        .alu_keep_r(alu_keep_r),
        .alu_sub(alu_sub),
        .en_r(en_r),
        .en_x(en_x),
        .ev_digit(ev_digit),
        .run_step(run_step),
        .sel_x(sel_x),
        .sign(sign),
        .st_neg(st_neg),
        .st_show(st_show),
        .st_show_n(st_show_n),
        .y_reg0(y_reg0),
        .y_reg1(y_reg1),
        .y_reg2(y_reg2),
        .y_reg3(y_reg3),
        .y_reg4(y_reg4),
        .y_reg5(y_reg5),
        .y_reg6(y_reg6),
        .y_reg7(y_reg7)
    );

    d4_ctrl_b u_die_b (
        .en_x(en_x),
        .ev_digit(ev_digit),
        .key_bcd0(key_bcd0),
        .key_bcd1(key_bcd1),
        .key_bcd2(key_bcd2),
        .key_bcd3(key_bcd3),
        .run_step(run_step),
        .st_show_n(st_show_n),
        .ph1(ph1),
        .ph2(ph2),
        .ph3(ph3),
        .x_nonzero(x_nonzero),
        .x_reg0(x_reg0),
        .x_reg1(x_reg1),
        .x_reg2(x_reg2),
        .x_reg3(x_reg3),
        .x_reg4(x_reg4),
        .x_reg5(x_reg5),
        .x_reg6(x_reg6),
        .x_reg7(x_reg7)
    );

endmodule
