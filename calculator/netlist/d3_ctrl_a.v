// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Управление, дай A: синхронизатор кнопки, автомат, регистр Y, OP, знак
// Элементов: 90 (AND 47, NOR 2, NOT 4, OR 16, RS 21)
// Портов: входов 20, выходов 19

module d3_ctrl_a (
    alu_c2, btn, cls_clr, cls_eq, cls_minus, cls_mul,
    is_digit, is_op, ph1, ph2, ph3, x_nonzero,
    x_reg0, x_reg1, x_reg2, x_reg3, x_reg4, x_reg5,
    x_reg6, x_reg7, alu_keep_r, alu_sub, en_r, en_x,
    ev_digit, run_step, sel_x, sign, st_neg, st_show,
    st_show_n, y_reg0, y_reg1, y_reg2, y_reg3, y_reg4,
    y_reg5, y_reg6, y_reg7
);
    input alu_c2;
    input btn;
    input cls_clr;
    input cls_eq;
    input cls_minus;
    input cls_mul;
    input is_digit;
    input is_op;
    input ph1;
    input ph2;
    input ph3;
    input x_nonzero;
    input x_reg0;
    input x_reg1;
    input x_reg2;
    input x_reg3;
    input x_reg4;
    input x_reg5;
    input x_reg6;
    input x_reg7;
    output alu_keep_r;
    output alu_sub;
    output en_r;
    output en_x;
    output ev_digit;
    output run_step;
    output sel_x;
    output sign;
    output st_neg;
    output st_show;
    output st_show_n;
    output y_reg0;
    output y_reg1;
    output y_reg2;
    output y_reg3;
    output y_reg4;
    output y_reg5;
    output y_reg6;
    output y_reg7;

    wire OP0_qn, SGN0_qn, Y0_qn, Y1_qn, Y2_qn, Y3_qn, Y4_qn, Y5_qn;
    wire Y6_qn, Y7_qn, ev_clr, ev_clr_all, ev_eq, ev_eq_addsub, ev_eq_sub, ev_fresh;
    wire ev_op, key_act, key_pulse, ld_op, n_and198, n_and199, n_and200, n_and201;
    wire n_and202, n_and203, n_and208, n_and210, n_and228, n_and515, n_and516, n_and517;
    wire n_and518, n_and519, n_and520, n_and521, n_and522, n_and523, n_and524, n_and525;
    wire n_and526, n_and527, n_and528, n_and529, n_and532, n_and534, n_and535, n_and536;
    wire n_and538, n_and539, n_and540, n_and541, n_and543, n_and547, n_and550, n_and551;
    wire n_and552, n_nor205, n_nor227, n_nor537, n_nor542, n_nor546, n_or230, n_or231;
    wire n_or233, n_or234, n_or235, n_or237, n_or238, n_or533, n_or548, n_or549;
    wire neg0_m_q, neg0_m_qn, neg0_qn, op_mul, op_mul_n, op_sub, run0_m_q, run0_m_qn;
    wire run0_qn, show0_m_q, show0_m_qn, st_run, sync1_0_m_q, sync1_0_m_qn, sync1_0_q, sync1_0_qn;
    wire sync2_0_m_q, sync2_0_m_qn, sync2_0_q, sync2_0_qn;

    // ---- 5 Регистры ----
    RS u_Y0 (.S(n_and517), .R(n_and515), .Q(y_reg0), .QN(Y0_qn));
    RS u_Y1 (.S(n_and518), .R(n_and515), .Q(y_reg1), .QN(Y1_qn));
    RS u_Y2 (.S(n_and519), .R(n_and515), .Q(y_reg2), .QN(Y2_qn));
    RS u_Y3 (.S(n_and520), .R(n_and515), .Q(y_reg3), .QN(Y3_qn));
    RS u_Y4 (.S(n_and521), .R(n_and515), .Q(y_reg4), .QN(Y4_qn));
    RS u_Y5 (.S(n_and522), .R(n_and515), .Q(y_reg5), .QN(Y5_qn));
    RS u_Y6 (.S(n_and523), .R(n_and515), .Q(y_reg6), .QN(Y6_qn));
    RS u_Y7 (.S(n_and524), .R(n_and515), .Q(y_reg7), .QN(Y7_qn));
    RS u_OP0 (.S(n_and527), .R(n_and525), .Q(op_sub), .QN(OP0_qn));
    RS u_OP1 (.S(n_and528), .R(n_and525), .Q(op_mul), .QN(op_mul_n));
    RS u_SGN0 (.S(n_and529), .R(n_and525), .Q(sign), .QN(SGN0_qn));

    // ---- 5c Регистр Y ----
    AND u_and515 (.A(ph1), .B(ev_op), .Y(n_and515));
    AND u_and516 (.A(ph2), .B(ev_op), .Y(n_and516));
    AND u_and517 (.A(x_reg0), .B(n_and516), .Y(n_and517));
    AND u_and518 (.A(x_reg1), .B(n_and516), .Y(n_and518));
    AND u_and519 (.A(x_reg2), .B(n_and516), .Y(n_and519));
    AND u_and520 (.A(x_reg3), .B(n_and516), .Y(n_and520));
    AND u_and521 (.A(x_reg4), .B(n_and516), .Y(n_and521));
    AND u_and522 (.A(x_reg5), .B(n_and516), .Y(n_and522));
    AND u_and523 (.A(x_reg6), .B(n_and516), .Y(n_and523));
    AND u_and524 (.A(x_reg7), .B(n_and516), .Y(n_and524));

    // ---- 5d OP и знак ----
    AND u_and525 (.A(ph1), .B(ld_op), .Y(n_and525));
    AND u_and526 (.A(ph2), .B(ld_op), .Y(n_and526));
    AND u_and527 (.A(cls_minus), .B(n_and526), .Y(n_and527));
    AND u_and528 (.A(cls_mul), .B(n_and526), .Y(n_and528));
    AND u_and529 (.A(ph2), .B(st_neg), .Y(n_and529));

    // ---- 6 Управление ----
    AND u_and198 (.A(btn), .B(ph2), .Y(n_and198));
    AND u_and199 (.A(sync1_0_m_q), .B(ph3), .Y(n_and199));
    AND u_and200 (.A(sync1_0_m_qn), .B(ph3), .Y(n_and200));
    AND u_and201 (.A(sync1_0_q), .B(ph2), .Y(n_and201));
    AND u_and202 (.A(sync2_0_m_q), .B(ph3), .Y(n_and202));
    AND u_and203 (.A(sync2_0_m_qn), .B(ph3), .Y(n_and203));
    AND u_and204 (.A(sync1_0_q), .B(sync2_0_qn), .Y(key_pulse));
    NOR u_nor205 (.A(st_run), .B(st_neg), .Y(n_nor205));
    AND u_and206 (.A(key_pulse), .B(n_nor205), .Y(key_act));
    AND u_and207 (.A(key_act), .B(is_digit), .Y(ev_digit));
    AND u_and208 (.A(key_act), .B(is_op), .Y(n_and208));
    AND u_and209 (.A(n_and208), .B(st_show_n), .Y(ev_op));
    AND u_and210 (.A(key_act), .B(cls_eq), .Y(n_and210));
    AND u_and211 (.A(n_and210), .B(st_show_n), .Y(ev_eq));
    AND u_and212 (.A(key_act), .B(cls_clr), .Y(ev_clr));
    AND u_and213 (.A(ev_digit), .B(st_show), .Y(ev_fresh));
    OR u_or214 (.A(ev_clr), .B(ev_fresh), .Y(ev_clr_all));
    AND u_and223 (.A(st_run), .B(x_nonzero), .Y(run_step));
    AND u_and224 (.A(ev_eq), .B(op_mul_n), .Y(ev_eq_addsub));
    AND u_and225 (.A(ev_eq), .B(op_sub), .Y(ev_eq_sub));
    OR u_or226 (.A(ev_eq_sub), .B(st_neg), .Y(alu_sub));
    NOT u_nor227 (.A(cls_mul), .Y(n_nor227));
    AND u_and228 (.A(ev_op), .B(n_nor227), .Y(n_and228));
    OR u_or229 (.A(n_and228), .B(ev_eq_addsub), .Y(sel_x));
    OR u_or230 (.A(ev_op), .B(st_neg), .Y(n_or230));
    OR u_or231 (.A(n_or230), .B(ev_clr_all), .Y(n_or231));
    NOT u_nor232 (.A(n_or231), .Y(alu_keep_r));
    OR u_or233 (.A(ev_op), .B(ev_eq_addsub), .Y(n_or233));
    OR u_or234 (.A(run_step), .B(st_neg), .Y(n_or234));
    OR u_or235 (.A(n_or233), .B(n_or234), .Y(n_or235));
    OR u_or236 (.A(n_or235), .B(ev_clr_all), .Y(en_r));
    OR u_or237 (.A(ev_digit), .B(ev_op), .Y(n_or237));
    OR u_or238 (.A(ev_clr), .B(run_step), .Y(n_or238));
    OR u_or239 (.A(n_or237), .B(n_or238), .Y(en_x));
    OR u_or240 (.A(ev_op), .B(ev_clr_all), .Y(ld_op));
    AND u_and532 (.A(ev_eq), .B(op_mul), .Y(n_and532));
    OR u_or533 (.A(n_and532), .B(run_step), .Y(n_or533));
    AND u_and534 (.A(n_or533), .B(ph2), .Y(n_and534));
    AND u_and535 (.A(run0_m_q), .B(ph3), .Y(n_and535));
    AND u_and536 (.A(run0_m_qn), .B(ph3), .Y(n_and536));
    NOT u_nor537 (.A(alu_c2), .Y(n_nor537));
    AND u_and538 (.A(ev_eq_sub), .B(n_nor537), .Y(n_and538));
    AND u_and539 (.A(n_and538), .B(ph2), .Y(n_and539));
    AND u_and540 (.A(neg0_m_q), .B(ph3), .Y(n_and540));
    AND u_and541 (.A(neg0_m_qn), .B(ph3), .Y(n_and541));
    NOR u_nor542 (.A(ev_digit), .B(ev_clr), .Y(n_nor542));
    AND u_and543 (.A(st_show), .B(n_nor542), .Y(n_and543));
    NOT u_nor546 (.A(n_and538), .Y(n_nor546));
    AND u_and547 (.A(ev_eq), .B(n_nor546), .Y(n_and547));
    OR u_or548 (.A(n_and547), .B(st_neg), .Y(n_or548));
    OR u_or549 (.A(n_and543), .B(n_or548), .Y(n_or549));
    AND u_and550 (.A(n_or549), .B(ph2), .Y(n_and550));
    AND u_and551 (.A(show0_m_q), .B(ph3), .Y(n_and551));
    AND u_and552 (.A(show0_m_qn), .B(ph3), .Y(n_and552));
    RS u_sync1_0_m (.S(n_and198), .R(ph1), .Q(sync1_0_m_q), .QN(sync1_0_m_qn));
    RS u_sync1_0 (.S(n_and199), .R(n_and200), .Q(sync1_0_q), .QN(sync1_0_qn));
    RS u_sync2_0_m (.S(n_and201), .R(ph1), .Q(sync2_0_m_q), .QN(sync2_0_m_qn));
    RS u_sync2_0 (.S(n_and202), .R(n_and203), .Q(sync2_0_q), .QN(sync2_0_qn));
    RS u_run0_m (.S(n_and534), .R(ph1), .Q(run0_m_q), .QN(run0_m_qn));
    RS u_run0 (.S(n_and535), .R(n_and536), .Q(st_run), .QN(run0_qn));
    RS u_neg0_m (.S(n_and539), .R(ph1), .Q(neg0_m_q), .QN(neg0_m_qn));
    RS u_neg0 (.S(n_and540), .R(n_and541), .Q(st_neg), .QN(neg0_qn));
    RS u_show0_m (.S(n_and550), .R(ph1), .Q(show0_m_q), .QN(show0_m_qn));
    RS u_show0 (.S(n_and551), .R(n_and552), .Q(st_show), .QN(st_show_n));

endmodule
