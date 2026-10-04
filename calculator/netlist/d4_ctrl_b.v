// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Управление, дай B: регистр X, декремент, X = 0, генератор трёх фаз
// Элементов: 113 (AND 64, NOR 1, NOT 1, OR 17, OSC 1, RS 20, XOR 9)
// Портов: входов 8, выходов 12

module d4_ctrl_b (
    en_x, ev_digit, key_bcd0, key_bcd1, key_bcd2, key_bcd3,
    run_step, st_show_n, ph1, ph2, ph3, x_nonzero,
    x_reg0, x_reg1, x_reg2, x_reg3, x_reg4, x_reg5,
    x_reg6, x_reg7
);
    input en_x;
    input ev_digit;
    input key_bcd0;
    input key_bcd1;
    input key_bcd2;
    input key_bcd3;
    input run_step;
    input st_show_n;
    output ph1;
    output ph2;
    output ph3;
    output x_nonzero;
    output x_reg0;
    output x_reg1;
    output x_reg2;
    output x_reg3;
    output x_reg4;
    output x_reg5;
    output x_reg6;
    output x_reg7;

    wire X0_m_q, X0_m_qn, X1_m_q, X1_m_qn, X2_m_q, X2_m_qn, X3_m_q, X3_m_qn;
    wire X4_m_q, X4_m_qn, X5_m_q, X5_m_qn, X6_m_q, X6_m_qn, X7_m_q, X7_m_qn;
    wire gA_m_q, gA_m_qn, gA_q, gA_qn, gB_m_q, gB_m_qn, gB_q, gB_qn;
    wire gen_master_en, gen_slave_en, n_and400, n_and402, n_and408, n_and410, n_and412, n_and414;
    wire n_and415, n_and416, n_and418, n_and419, n_and421, n_and422, n_and424, n_and425;
    wire n_and427, n_and428, n_and430, n_and431, n_and433, n_and434, n_and436, n_and437;
    wire n_and439, n_and440, n_and441, n_and442, n_and443, n_and444, n_and445, n_and446;
    wire n_and447, n_and448, n_and449, n_and450, n_and451, n_and452, n_and453, n_and454;
    wire n_and455, n_and456, n_and457, n_and458, n_and459, n_and460, n_and461, n_and462;
    wire n_and463, n_and464, n_and753, n_and754, n_and755, n_and756, n_and757, n_and758;
    wire n_and759, n_and760, n_and761, n_and763, n_and765, n_nor222, n_or215, n_or216;
    wire n_or217, n_or218, n_or219, n_or220, n_or417, n_or420, n_or423, n_or426;
    wire n_or429, n_or432, n_or435, n_or438, n_xor399, n_xor401, osc, osc_d1;
    wire osc_d2, x_dec0, x_dec1, x_dec2, x_dec3, x_dec4, x_dec5, x_dec6;
    wire x_dec7, x_dec_borrow, x_reg_n1, x_reg_n2, x_reg_n3, x_reg_n4, x_reg_n5, x_reg_n6;
    wire x_reg_n7;

    // ---- 4f Декремент X, X=0 ----
    OR u_or215 (.A(x_reg0), .B(x_reg1), .Y(n_or215));
    OR u_or216 (.A(x_reg2), .B(x_reg3), .Y(n_or216));
    OR u_or217 (.A(x_reg4), .B(x_reg5), .Y(n_or217));
    OR u_or218 (.A(x_reg6), .B(x_reg7), .Y(n_or218));
    OR u_or219 (.A(n_or215), .B(n_or216), .Y(n_or219));
    OR u_or220 (.A(n_or217), .B(n_or218), .Y(n_or220));
    OR u_or221 (.A(n_or219), .B(n_or220), .Y(x_nonzero));
    NOT u_nor222 (.A(x_nonzero), .Y(n_nor222));
    XOR u_xor399 (.A(x_reg1), .B(x_dec0), .Y(n_xor399));
    AND u_and400 (.A(x_dec0), .B(x_reg_n1), .Y(n_and400));
    XOR u_xor401 (.A(x_reg2), .B(n_and400), .Y(n_xor401));
    AND u_and402 (.A(n_and400), .B(x_reg_n2), .Y(n_and402));
    XOR u_xor403 (.A(x_reg3), .B(n_and402), .Y(x_dec3));
    AND u_and404 (.A(n_and402), .B(x_reg_n3), .Y(x_dec_borrow));
    XOR u_xor405 (.A(n_xor399), .B(x_dec_borrow), .Y(x_dec1));
    XOR u_xor406 (.A(n_xor401), .B(x_dec_borrow), .Y(x_dec2));
    XOR u_xor407 (.A(x_reg4), .B(x_dec_borrow), .Y(x_dec4));
    AND u_and408 (.A(x_reg_n4), .B(x_dec_borrow), .Y(n_and408));
    XOR u_xor409 (.A(x_reg5), .B(n_and408), .Y(x_dec5));
    AND u_and410 (.A(x_reg_n5), .B(n_and408), .Y(n_and410));
    XOR u_xor411 (.A(x_reg6), .B(n_and410), .Y(x_dec6));
    AND u_and412 (.A(x_reg_n6), .B(n_and410), .Y(n_and412));
    XOR u_xor413 (.A(x_reg7), .B(n_and412), .Y(x_dec7));

    // ---- 5 Регистры ----
    RS u_X0_m (.S(n_and441), .R(n_and439), .Q(X0_m_q), .QN(X0_m_qn));
    RS u_X0 (.S(n_and442), .R(n_and443), .Q(x_reg0), .QN(x_dec0));
    RS u_X1_m (.S(n_and444), .R(n_and439), .Q(X1_m_q), .QN(X1_m_qn));
    RS u_X1 (.S(n_and445), .R(n_and446), .Q(x_reg1), .QN(x_reg_n1));
    RS u_X2_m (.S(n_and447), .R(n_and439), .Q(X2_m_q), .QN(X2_m_qn));
    RS u_X2 (.S(n_and448), .R(n_and449), .Q(x_reg2), .QN(x_reg_n2));
    RS u_X3_m (.S(n_and450), .R(n_and439), .Q(X3_m_q), .QN(X3_m_qn));
    RS u_X3 (.S(n_and451), .R(n_and452), .Q(x_reg3), .QN(x_reg_n3));
    RS u_X4_m (.S(n_and453), .R(n_and439), .Q(X4_m_q), .QN(X4_m_qn));
    RS u_X4 (.S(n_and454), .R(n_and455), .Q(x_reg4), .QN(x_reg_n4));
    RS u_X5_m (.S(n_and456), .R(n_and439), .Q(X5_m_q), .QN(X5_m_qn));
    RS u_X5 (.S(n_and457), .R(n_and458), .Q(x_reg5), .QN(x_reg_n5));
    RS u_X6_m (.S(n_and459), .R(n_and439), .Q(X6_m_q), .QN(X6_m_qn));
    RS u_X6 (.S(n_and460), .R(n_and461), .Q(x_reg6), .QN(x_reg_n6));
    RS u_X7_m (.S(n_and462), .R(n_and439), .Q(X7_m_q), .QN(X7_m_qn));
    RS u_X7 (.S(n_and463), .R(n_and464), .Q(x_reg7), .QN(x_reg_n7));

    // ---- 5a Регистр X ----
    AND u_and414 (.A(ev_digit), .B(st_show_n), .Y(n_and414));
    AND u_and415 (.A(ev_digit), .B(key_bcd0), .Y(n_and415));
    AND u_and416 (.A(run_step), .B(x_dec0), .Y(n_and416));
    OR u_or417 (.A(n_and415), .B(n_and416), .Y(n_or417));
    AND u_and418 (.A(ev_digit), .B(key_bcd1), .Y(n_and418));
    AND u_and419 (.A(run_step), .B(x_dec1), .Y(n_and419));
    OR u_or420 (.A(n_and418), .B(n_and419), .Y(n_or420));
    AND u_and421 (.A(ev_digit), .B(key_bcd2), .Y(n_and421));
    AND u_and422 (.A(run_step), .B(x_dec2), .Y(n_and422));
    OR u_or423 (.A(n_and421), .B(n_and422), .Y(n_or423));
    AND u_and424 (.A(ev_digit), .B(key_bcd3), .Y(n_and424));
    AND u_and425 (.A(run_step), .B(x_dec3), .Y(n_and425));
    OR u_or426 (.A(n_and424), .B(n_and425), .Y(n_or426));
    AND u_and427 (.A(n_and414), .B(x_reg0), .Y(n_and427));
    AND u_and428 (.A(run_step), .B(x_dec4), .Y(n_and428));
    OR u_or429 (.A(n_and427), .B(n_and428), .Y(n_or429));
    AND u_and430 (.A(n_and414), .B(x_reg1), .Y(n_and430));
    AND u_and431 (.A(run_step), .B(x_dec5), .Y(n_and431));
    OR u_or432 (.A(n_and430), .B(n_and431), .Y(n_or432));
    AND u_and433 (.A(n_and414), .B(x_reg2), .Y(n_and433));
    AND u_and434 (.A(run_step), .B(x_dec6), .Y(n_and434));
    OR u_or435 (.A(n_and433), .B(n_and434), .Y(n_or435));
    AND u_and436 (.A(n_and414), .B(x_reg3), .Y(n_and436));
    AND u_and437 (.A(run_step), .B(x_dec7), .Y(n_and437));
    OR u_or438 (.A(n_and436), .B(n_and437), .Y(n_or438));
    AND u_and439 (.A(ph1), .B(en_x), .Y(n_and439));
    AND u_and440 (.A(ph2), .B(en_x), .Y(n_and440));
    AND u_and441 (.A(n_or417), .B(n_and440), .Y(n_and441));
    AND u_and442 (.A(X0_m_q), .B(ph3), .Y(n_and442));
    AND u_and443 (.A(X0_m_qn), .B(ph3), .Y(n_and443));
    AND u_and444 (.A(n_or420), .B(n_and440), .Y(n_and444));
    AND u_and445 (.A(X1_m_q), .B(ph3), .Y(n_and445));
    AND u_and446 (.A(X1_m_qn), .B(ph3), .Y(n_and446));
    AND u_and447 (.A(n_or423), .B(n_and440), .Y(n_and447));
    AND u_and448 (.A(X2_m_q), .B(ph3), .Y(n_and448));
    AND u_and449 (.A(X2_m_qn), .B(ph3), .Y(n_and449));
    AND u_and450 (.A(n_or426), .B(n_and440), .Y(n_and450));
    AND u_and451 (.A(X3_m_q), .B(ph3), .Y(n_and451));
    AND u_and452 (.A(X3_m_qn), .B(ph3), .Y(n_and452));
    AND u_and453 (.A(n_or429), .B(n_and440), .Y(n_and453));
    AND u_and454 (.A(X4_m_q), .B(ph3), .Y(n_and454));
    AND u_and455 (.A(X4_m_qn), .B(ph3), .Y(n_and455));
    AND u_and456 (.A(n_or432), .B(n_and440), .Y(n_and456));
    AND u_and457 (.A(X5_m_q), .B(ph3), .Y(n_and457));
    AND u_and458 (.A(X5_m_qn), .B(ph3), .Y(n_and458));
    AND u_and459 (.A(n_or435), .B(n_and440), .Y(n_and459));
    AND u_and460 (.A(X6_m_q), .B(ph3), .Y(n_and460));
    AND u_and461 (.A(X6_m_qn), .B(ph3), .Y(n_and461));
    AND u_and462 (.A(n_or438), .B(n_and440), .Y(n_and462));
    AND u_and463 (.A(X7_m_q), .B(ph3), .Y(n_and463));
    AND u_and464 (.A(X7_m_qn), .B(ph3), .Y(n_and464));

    // ---- 8 Генератор фаз ----
    OR u_or749 (.A(osc), .B(osc), .Y(osc_d1));
    OR u_or750 (.A(osc_d1), .B(osc_d1), .Y(osc_d2));
    AND u_and751 (.A(osc), .B(osc_d2), .Y(gen_master_en));
    NOR u_nor752 (.A(osc), .B(osc_d2), .Y(gen_slave_en));
    AND u_and753 (.A(gB_qn), .B(gen_master_en), .Y(n_and753));
    AND u_and754 (.A(gB_q), .B(gen_master_en), .Y(n_and754));
    AND u_and755 (.A(gA_q), .B(gen_master_en), .Y(n_and755));
    AND u_and756 (.A(gA_qn), .B(gen_master_en), .Y(n_and756));
    AND u_and757 (.A(gA_m_q), .B(gen_slave_en), .Y(n_and757));
    AND u_and758 (.A(gA_m_qn), .B(gen_slave_en), .Y(n_and758));
    AND u_and759 (.A(gB_m_q), .B(gen_slave_en), .Y(n_and759));
    AND u_and760 (.A(gB_m_qn), .B(gen_slave_en), .Y(n_and760));
    AND u_and761 (.A(gA_q), .B(gB_qn), .Y(n_and761));
    AND u_PH1 (.A(n_and761), .B(gen_master_en), .Y(ph1));
    AND u_and763 (.A(gA_q), .B(gB_q), .Y(n_and763));
    AND u_PH2 (.A(n_and763), .B(gen_master_en), .Y(ph2));
    AND u_and765 (.A(gA_qn), .B(gB_q), .Y(n_and765));
    AND u_PH3 (.A(n_and765), .B(gen_master_en), .Y(ph3));
    RS u_gA_m (.S(n_and753), .R(n_and754), .Q(gA_m_q), .QN(gA_m_qn));
    RS u_gA (.S(n_and757), .R(n_and758), .Q(gA_q), .QN(gA_qn));
    RS u_gB_m (.S(n_and755), .R(n_and756), .Q(gB_m_q), .QN(gB_m_qn));
    RS u_gB (.S(n_and759), .R(n_and760), .Q(gB_q), .QN(gB_qn));
    OSC u_osc (.Y(osc));

endmodule
