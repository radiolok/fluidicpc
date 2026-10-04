// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Индикация, дай B: дешифраторы сотен и тысяч
// Элементов: 74 (AND 38, NOR 12, NOT 2, OR 22)
// Портов: входов 18, выходов 14

module d8_disp_b (
    disp_en2, disp_en3, r_reg10, r_reg11, r_reg12, r_reg13,
    r_reg14, r_reg15, r_reg8, r_reg9, r_reg_n10, r_reg_n11,
    r_reg_n12, r_reg_n13, r_reg_n14, r_reg_n15, r_reg_n8, r_reg_n9,
    seg_d2_a, seg_d2_b, seg_d2_c, seg_d2_d, seg_d2_e, seg_d2_f,
    seg_d2_g, seg_d3_a, seg_d3_b, seg_d3_c, seg_d3_d, seg_d3_e,
    seg_d3_f, seg_d3_g
);
    input disp_en2;
    input disp_en3;
    input r_reg10;
    input r_reg11;
    input r_reg12;
    input r_reg13;
    input r_reg14;
    input r_reg15;
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

    wire n_and593, n_and594, n_and595, n_and596, n_and597, n_and598, n_and599, n_and600;
    wire n_and601, n_and602, n_and603, n_and604, n_and605, n_and606, n_and607, n_and608;
    wire n_and609, n_and610, n_and611, n_and631, n_and632, n_and633, n_and634, n_and635;
    wire n_and636, n_and637, n_and638, n_and639, n_and640, n_and641, n_and642, n_and643;
    wire n_and644, n_and645, n_and646, n_and647, n_and648, n_and649, n_nor612, n_nor650;
    wire n_or613, n_or615, n_or619, n_or621, n_or622, n_or624, n_or625, n_or626;
    wire n_or628, n_or629, n_or651, n_or653, n_or657, n_or659, n_or660, n_or662;
    wire n_or663, n_or664, n_or666, n_or667;

    // ---- 7c Дешифраторы 7-сегм. ×4 ----
    AND u_and593 (.A(r_reg_n13), .B(r_reg_n12), .Y(n_and593));
    AND u_and594 (.A(r_reg_n13), .B(r_reg12), .Y(n_and594));
    AND u_and595 (.A(r_reg13), .B(r_reg_n12), .Y(n_and595));
    AND u_and596 (.A(r_reg13), .B(r_reg12), .Y(n_and596));
    AND u_and597 (.A(r_reg_n15), .B(r_reg_n14), .Y(n_and597));
    AND u_and598 (.A(n_and597), .B(disp_en3), .Y(n_and598));
    AND u_and599 (.A(r_reg_n15), .B(r_reg14), .Y(n_and599));
    AND u_and600 (.A(n_and599), .B(disp_en3), .Y(n_and600));
    AND u_and601 (.A(r_reg15), .B(disp_en3), .Y(n_and601));
    AND u_and602 (.A(n_and598), .B(n_and593), .Y(n_and602));
    AND u_and603 (.A(n_and598), .B(n_and594), .Y(n_and603));
    AND u_and604 (.A(n_and598), .B(n_and595), .Y(n_and604));
    AND u_and605 (.A(n_and598), .B(n_and596), .Y(n_and605));
    AND u_and606 (.A(n_and600), .B(n_and593), .Y(n_and606));
    AND u_and607 (.A(n_and600), .B(n_and594), .Y(n_and607));
    AND u_and608 (.A(n_and600), .B(n_and595), .Y(n_and608));
    AND u_and609 (.A(n_and600), .B(n_and596), .Y(n_and609));
    AND u_and610 (.A(n_and601), .B(r_reg_n12), .Y(n_and610));
    AND u_and611 (.A(n_and601), .B(r_reg12), .Y(n_and611));
    NOT u_nor612 (.A(disp_en3), .Y(n_nor612));
    OR u_or613 (.A(n_and603), .B(n_and606), .Y(n_or613));
    NOR u_nor614 (.A(n_nor612), .B(n_or613), .Y(seg_d3_a));
    OR u_or615 (.A(n_and607), .B(n_and608), .Y(n_or615));
    NOR u_nor616 (.A(n_nor612), .B(n_or615), .Y(seg_d3_b));
    NOR u_nor617 (.A(n_nor612), .B(n_and604), .Y(seg_d3_c));
    OR u_or619 (.A(n_or613), .B(n_and609), .Y(n_or619));
    NOR u_nor620 (.A(n_nor612), .B(n_or619), .Y(seg_d3_d));
    OR u_or621 (.A(n_and602), .B(n_and604), .Y(n_or621));
    OR u_or622 (.A(n_and608), .B(n_and610), .Y(n_or622));
    OR u_or623 (.A(n_or621), .B(n_or622), .Y(seg_d3_e));
    OR u_or624 (.A(n_and603), .B(n_and604), .Y(n_or624));
    OR u_or625 (.A(n_and605), .B(n_and609), .Y(n_or625));
    OR u_or626 (.A(n_or624), .B(n_or625), .Y(n_or626));
    NOR u_nor627 (.A(n_nor612), .B(n_or626), .Y(seg_d3_f));
    OR u_or628 (.A(n_and602), .B(n_and603), .Y(n_or628));
    OR u_or629 (.A(n_or628), .B(n_and609), .Y(n_or629));
    NOR u_nor630 (.A(n_nor612), .B(n_or629), .Y(seg_d3_g));
    AND u_and631 (.A(r_reg_n9), .B(r_reg_n8), .Y(n_and631));
    AND u_and632 (.A(r_reg_n9), .B(r_reg8), .Y(n_and632));
    AND u_and633 (.A(r_reg9), .B(r_reg_n8), .Y(n_and633));
    AND u_and634 (.A(r_reg9), .B(r_reg8), .Y(n_and634));
    AND u_and635 (.A(r_reg_n11), .B(r_reg_n10), .Y(n_and635));
    AND u_and636 (.A(n_and635), .B(disp_en2), .Y(n_and636));
    AND u_and637 (.A(r_reg_n11), .B(r_reg10), .Y(n_and637));
    AND u_and638 (.A(n_and637), .B(disp_en2), .Y(n_and638));
    AND u_and639 (.A(r_reg11), .B(disp_en2), .Y(n_and639));
    AND u_and640 (.A(n_and636), .B(n_and631), .Y(n_and640));
    AND u_and641 (.A(n_and636), .B(n_and632), .Y(n_and641));
    AND u_and642 (.A(n_and636), .B(n_and633), .Y(n_and642));
    AND u_and643 (.A(n_and636), .B(n_and634), .Y(n_and643));
    AND u_and644 (.A(n_and638), .B(n_and631), .Y(n_and644));
    AND u_and645 (.A(n_and638), .B(n_and632), .Y(n_and645));
    AND u_and646 (.A(n_and638), .B(n_and633), .Y(n_and646));
    AND u_and647 (.A(n_and638), .B(n_and634), .Y(n_and647));
    AND u_and648 (.A(n_and639), .B(r_reg_n8), .Y(n_and648));
    AND u_and649 (.A(n_and639), .B(r_reg8), .Y(n_and649));
    NOT u_nor650 (.A(disp_en2), .Y(n_nor650));
    OR u_or651 (.A(n_and641), .B(n_and644), .Y(n_or651));
    NOR u_nor652 (.A(n_nor650), .B(n_or651), .Y(seg_d2_a));
    OR u_or653 (.A(n_and645), .B(n_and646), .Y(n_or653));
    NOR u_nor654 (.A(n_nor650), .B(n_or653), .Y(seg_d2_b));
    NOR u_nor655 (.A(n_nor650), .B(n_and642), .Y(seg_d2_c));
    OR u_or657 (.A(n_or651), .B(n_and647), .Y(n_or657));
    NOR u_nor658 (.A(n_nor650), .B(n_or657), .Y(seg_d2_d));
    OR u_or659 (.A(n_and640), .B(n_and642), .Y(n_or659));
    OR u_or660 (.A(n_and646), .B(n_and648), .Y(n_or660));
    OR u_or661 (.A(n_or659), .B(n_or660), .Y(seg_d2_e));
    OR u_or662 (.A(n_and641), .B(n_and642), .Y(n_or662));
    OR u_or663 (.A(n_and643), .B(n_and647), .Y(n_or663));
    OR u_or664 (.A(n_or662), .B(n_or663), .Y(n_or664));
    NOR u_nor665 (.A(n_nor650), .B(n_or664), .Y(seg_d2_f));
    OR u_or666 (.A(n_and640), .B(n_and641), .Y(n_or666));
    OR u_or667 (.A(n_or666), .B(n_and647), .Y(n_or667));
    NOR u_nor668 (.A(n_nor650), .B(n_or667), .Y(seg_d2_g));

endmodule
