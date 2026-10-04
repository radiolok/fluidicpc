// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Индикация, дай A: мультиплексор индикации, гашение, дешифраторы единиц и десятков
// Элементов: 112 (AND 53, NOR 12, NOT 9, OR 38)
// Портов: входов 23, выходов 16

module d7_disp_a (
    n_or582, r_reg0, r_reg1, r_reg12, r_reg13, r_reg14,
    r_reg15, r_reg2, r_reg3, r_reg4, r_reg5, r_reg6,
    r_reg7, st_show, st_show_n, x_reg0, x_reg1, x_reg2,
    x_reg3, x_reg4, x_reg5, x_reg6, x_reg7, disp_en2,
    disp_en3, seg_d0_a, seg_d0_b, seg_d0_c, seg_d0_d, seg_d0_e,
    seg_d0_f, seg_d0_g, seg_d1_a, seg_d1_b, seg_d1_c, seg_d1_d,
    seg_d1_e, seg_d1_f, seg_d1_g
);
    input n_or582;
    input r_reg0;
    input r_reg1;
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
    output disp_en2;
    output disp_en3;
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

    wire disp_en1, disp_lo0, disp_lo1, disp_lo2, disp_lo3, disp_lo4, disp_lo5, disp_lo6;
    wire disp_lo7, disp_nz3, n_and553, n_and554, n_and556, n_and557, n_and559, n_and560;
    wire n_and562, n_and563, n_and565, n_and566, n_and568, n_and569, n_and571, n_and572;
    wire n_and574, n_and575, n_and673, n_and674, n_and675, n_and676, n_and677, n_and678;
    wire n_and679, n_and680, n_and681, n_and682, n_and683, n_and684, n_and685, n_and686;
    wire n_and687, n_and688, n_and689, n_and690, n_and691, n_and715, n_and716, n_and717;
    wire n_and718, n_and719, n_and720, n_and721, n_and722, n_and723, n_and724, n_and725;
    wire n_and726, n_and727, n_and728, n_and729, n_and730, n_nor669, n_nor670, n_nor671;
    wire n_nor672, n_nor692, n_nor711, n_nor712, n_nor713, n_nor714, n_or577, n_or578;
    wire n_or583, n_or589, n_or590, n_or591, n_or693, n_or695, n_or699, n_or701;
    wire n_or702, n_or704, n_or705, n_or706, n_or708, n_or709, n_or731, n_or733;
    wire n_or737, n_or739, n_or740, n_or742, n_or743, n_or744, n_or746, n_or747;

    // ---- 7a Мультиплексор индикации ----
    AND u_and553 (.A(st_show), .B(r_reg0), .Y(n_and553));
    AND u_and554 (.A(st_show_n), .B(x_reg0), .Y(n_and554));
    OR u_or555 (.A(n_and553), .B(n_and554), .Y(disp_lo0));
    AND u_and556 (.A(st_show), .B(r_reg1), .Y(n_and556));
    AND u_and557 (.A(st_show_n), .B(x_reg1), .Y(n_and557));
    OR u_or558 (.A(n_and556), .B(n_and557), .Y(disp_lo1));
    AND u_and559 (.A(st_show), .B(r_reg2), .Y(n_and559));
    AND u_and560 (.A(st_show_n), .B(x_reg2), .Y(n_and560));
    OR u_or561 (.A(n_and559), .B(n_and560), .Y(disp_lo2));
    AND u_and562 (.A(st_show), .B(r_reg3), .Y(n_and562));
    AND u_and563 (.A(st_show_n), .B(x_reg3), .Y(n_and563));
    OR u_or564 (.A(n_and562), .B(n_and563), .Y(disp_lo3));
    AND u_and565 (.A(st_show), .B(r_reg4), .Y(n_and565));
    AND u_and566 (.A(st_show_n), .B(x_reg4), .Y(n_and566));
    OR u_or567 (.A(n_and565), .B(n_and566), .Y(disp_lo4));
    AND u_and568 (.A(st_show), .B(r_reg5), .Y(n_and568));
    AND u_and569 (.A(st_show_n), .B(x_reg5), .Y(n_and569));
    OR u_or570 (.A(n_and568), .B(n_and569), .Y(disp_lo5));
    AND u_and571 (.A(st_show), .B(r_reg6), .Y(n_and571));
    AND u_and572 (.A(st_show_n), .B(x_reg6), .Y(n_and572));
    OR u_or573 (.A(n_and571), .B(n_and572), .Y(disp_lo6));
    AND u_and574 (.A(st_show), .B(r_reg7), .Y(n_and574));
    AND u_and575 (.A(st_show_n), .B(x_reg7), .Y(n_and575));
    OR u_or576 (.A(n_and574), .B(n_and575), .Y(disp_lo7));

    // ---- 7b Гашение нулей ----
    OR u_or577 (.A(r_reg12), .B(r_reg13), .Y(n_or577));
    OR u_or578 (.A(r_reg14), .B(r_reg15), .Y(n_or578));
    OR u_or579 (.A(n_or577), .B(n_or578), .Y(disp_nz3));
    OR u_or583 (.A(disp_nz3), .B(n_or582), .Y(n_or583));
    AND u_and587 (.A(st_show), .B(disp_nz3), .Y(disp_en3));
    AND u_and588 (.A(st_show), .B(n_or583), .Y(disp_en2));
    OR u_or589 (.A(disp_lo4), .B(disp_lo5), .Y(n_or589));
    OR u_or590 (.A(disp_lo6), .B(disp_lo7), .Y(n_or590));
    OR u_or591 (.A(n_or589), .B(n_or590), .Y(n_or591));
    OR u_or592 (.A(disp_en2), .B(n_or591), .Y(disp_en1));

    // ---- 7c Дешифраторы 7-сегм. ×4 ----
    NOT u_nor669 (.A(disp_lo4), .Y(n_nor669));
    NOT u_nor670 (.A(disp_lo5), .Y(n_nor670));
    NOT u_nor671 (.A(disp_lo6), .Y(n_nor671));
    NOT u_nor672 (.A(disp_lo7), .Y(n_nor672));
    AND u_and673 (.A(n_nor670), .B(n_nor669), .Y(n_and673));
    AND u_and674 (.A(n_nor670), .B(disp_lo4), .Y(n_and674));
    AND u_and675 (.A(disp_lo5), .B(n_nor669), .Y(n_and675));
    AND u_and676 (.A(disp_lo5), .B(disp_lo4), .Y(n_and676));
    AND u_and677 (.A(n_nor672), .B(n_nor671), .Y(n_and677));
    AND u_and678 (.A(n_and677), .B(disp_en1), .Y(n_and678));
    AND u_and679 (.A(n_nor672), .B(disp_lo6), .Y(n_and679));
    AND u_and680 (.A(n_and679), .B(disp_en1), .Y(n_and680));
    AND u_and681 (.A(disp_lo7), .B(disp_en1), .Y(n_and681));
    AND u_and682 (.A(n_and678), .B(n_and673), .Y(n_and682));
    AND u_and683 (.A(n_and678), .B(n_and674), .Y(n_and683));
    AND u_and684 (.A(n_and678), .B(n_and675), .Y(n_and684));
    AND u_and685 (.A(n_and678), .B(n_and676), .Y(n_and685));
    AND u_and686 (.A(n_and680), .B(n_and673), .Y(n_and686));
    AND u_and687 (.A(n_and680), .B(n_and674), .Y(n_and687));
    AND u_and688 (.A(n_and680), .B(n_and675), .Y(n_and688));
    AND u_and689 (.A(n_and680), .B(n_and676), .Y(n_and689));
    AND u_and690 (.A(n_and681), .B(n_nor669), .Y(n_and690));
    AND u_and691 (.A(n_and681), .B(disp_lo4), .Y(n_and691));
    NOT u_nor692 (.A(disp_en1), .Y(n_nor692));
    OR u_or693 (.A(n_and683), .B(n_and686), .Y(n_or693));
    NOR u_nor694 (.A(n_nor692), .B(n_or693), .Y(seg_d1_a));
    OR u_or695 (.A(n_and687), .B(n_and688), .Y(n_or695));
    NOR u_nor696 (.A(n_nor692), .B(n_or695), .Y(seg_d1_b));
    NOR u_nor697 (.A(n_nor692), .B(n_and684), .Y(seg_d1_c));
    OR u_or699 (.A(n_or693), .B(n_and689), .Y(n_or699));
    NOR u_nor700 (.A(n_nor692), .B(n_or699), .Y(seg_d1_d));
    OR u_or701 (.A(n_and682), .B(n_and684), .Y(n_or701));
    OR u_or702 (.A(n_and688), .B(n_and690), .Y(n_or702));
    OR u_or703 (.A(n_or701), .B(n_or702), .Y(seg_d1_e));
    OR u_or704 (.A(n_and683), .B(n_and684), .Y(n_or704));
    OR u_or705 (.A(n_and685), .B(n_and689), .Y(n_or705));
    OR u_or706 (.A(n_or704), .B(n_or705), .Y(n_or706));
    NOR u_nor707 (.A(n_nor692), .B(n_or706), .Y(seg_d1_f));
    OR u_or708 (.A(n_and682), .B(n_and683), .Y(n_or708));
    OR u_or709 (.A(n_or708), .B(n_and689), .Y(n_or709));
    NOR u_nor710 (.A(n_nor692), .B(n_or709), .Y(seg_d1_g));
    NOT u_nor711 (.A(disp_lo0), .Y(n_nor711));
    NOT u_nor712 (.A(disp_lo1), .Y(n_nor712));
    NOT u_nor713 (.A(disp_lo2), .Y(n_nor713));
    NOT u_nor714 (.A(disp_lo3), .Y(n_nor714));
    AND u_and715 (.A(n_nor712), .B(n_nor711), .Y(n_and715));
    AND u_and716 (.A(n_nor712), .B(disp_lo0), .Y(n_and716));
    AND u_and717 (.A(disp_lo1), .B(n_nor711), .Y(n_and717));
    AND u_and718 (.A(disp_lo1), .B(disp_lo0), .Y(n_and718));
    AND u_and719 (.A(n_nor714), .B(n_nor713), .Y(n_and719));
    AND u_and720 (.A(n_nor714), .B(disp_lo2), .Y(n_and720));
    AND u_and721 (.A(n_and719), .B(n_and715), .Y(n_and721));
    AND u_and722 (.A(n_and719), .B(n_and716), .Y(n_and722));
    AND u_and723 (.A(n_and719), .B(n_and717), .Y(n_and723));
    AND u_and724 (.A(n_and719), .B(n_and718), .Y(n_and724));
    AND u_and725 (.A(n_and720), .B(n_and715), .Y(n_and725));
    AND u_and726 (.A(n_and720), .B(n_and716), .Y(n_and726));
    AND u_and727 (.A(n_and720), .B(n_and717), .Y(n_and727));
    AND u_and728 (.A(n_and720), .B(n_and718), .Y(n_and728));
    AND u_and729 (.A(disp_lo3), .B(n_nor711), .Y(n_and729));
    AND u_and730 (.A(disp_lo3), .B(disp_lo0), .Y(n_and730));
    OR u_or731 (.A(n_and722), .B(n_and725), .Y(n_or731));
    NOR u_nor732 (.A(1'b0), .B(n_or731), .Y(seg_d0_a));
    OR u_or733 (.A(n_and726), .B(n_and727), .Y(n_or733));
    NOR u_nor734 (.A(1'b0), .B(n_or733), .Y(seg_d0_b));
    NOR u_nor735 (.A(1'b0), .B(n_and723), .Y(seg_d0_c));
    OR u_or737 (.A(n_or731), .B(n_and728), .Y(n_or737));
    NOR u_nor738 (.A(1'b0), .B(n_or737), .Y(seg_d0_d));
    OR u_or739 (.A(n_and721), .B(n_and723), .Y(n_or739));
    OR u_or740 (.A(n_and727), .B(n_and729), .Y(n_or740));
    OR u_or741 (.A(n_or739), .B(n_or740), .Y(seg_d0_e));
    OR u_or742 (.A(n_and722), .B(n_and723), .Y(n_or742));
    OR u_or743 (.A(n_and724), .B(n_and728), .Y(n_or743));
    OR u_or744 (.A(n_or742), .B(n_or743), .Y(n_or744));
    NOR u_nor745 (.A(1'b0), .B(n_or744), .Y(seg_d0_f));
    OR u_or746 (.A(n_and721), .B(n_and722), .Y(n_or746));
    OR u_or747 (.A(n_or746), .B(n_and728), .Y(n_or747));
    NOR u_nor748 (.A(1'b0), .B(n_or747), .Y(seg_d0_g));

endmodule
