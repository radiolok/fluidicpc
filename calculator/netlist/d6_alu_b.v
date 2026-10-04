// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// АЛУ, дай B: регистр R, маска A, инкремент сотен и тысяч
// Элементов: 123 (AND 76, OR 3, RS 32, XOR 12)
// Портов: входов 14, выходов 33

module d6_alu_b (
    alu_c2_hi, alu_keep_r, alu_s0, alu_s1, alu_s2, alu_s3,
    alu_s4, alu_s5, alu_s6, alu_s7, en_r, ph1,
    ph2, ph3, alu_a0, alu_a1, alu_a2, alu_a3,
    alu_a4, alu_a5, alu_a6, alu_a7, n_or582, r_reg0,
    r_reg1, r_reg10, r_reg11, r_reg12, r_reg13, r_reg14,
    r_reg15, r_reg2, r_reg3, r_reg4, r_reg5, r_reg6,
    r_reg7, r_reg8, r_reg9, r_reg_n10, r_reg_n11, r_reg_n12,
    r_reg_n13, r_reg_n14, r_reg_n15, r_reg_n8, r_reg_n9
);
    input alu_c2_hi;
    input alu_keep_r;
    input alu_s0;
    input alu_s1;
    input alu_s2;
    input alu_s3;
    input alu_s4;
    input alu_s5;
    input alu_s6;
    input alu_s7;
    input en_r;
    input ph1;
    input ph2;
    input ph3;
    output alu_a0;
    output alu_a1;
    output alu_a2;
    output alu_a3;
    output alu_a4;
    output alu_a5;
    output alu_a6;
    output alu_a7;
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

    wire R0_m_q, R0_m_qn, R10_m_q, R10_m_qn, R11_m_q, R11_m_qn, R12_m_q, R12_m_qn;
    wire R13_m_q, R13_m_qn, R14_m_q, R14_m_qn, R15_m_q, R15_m_qn, R1_m_q, R1_m_qn;
    wire R2_m_q, R2_m_qn, R3_m_q, R3_m_qn, R4_m_q, R4_m_qn, R5_m_q, R5_m_qn;
    wire R6_m_q, R6_m_qn, R7_m_q, R7_m_qn, R8_m_q, R8_m_qn, R9_m_q, R9_m_qn;
    wire alu_a10, alu_a11, alu_a12, alu_a13, alu_a14, alu_a15, alu_a8, alu_a9;
    wire alu_c3, alu_s10, alu_s11, alu_s12, alu_s13, alu_s14, alu_s15, alu_s8;
    wire alu_s9, n_and378, n_and380, n_and382, n_and384, n_and389, n_and391, n_and393;
    wire n_and395, n_and396, n_and465, n_and466, n_and467, n_and468, n_and469, n_and470;
    wire n_and471, n_and472, n_and473, n_and474, n_and475, n_and476, n_and477, n_and478;
    wire n_and479, n_and480, n_and481, n_and482, n_and483, n_and484, n_and485, n_and486;
    wire n_and487, n_and488, n_and489, n_and490, n_and491, n_and492, n_and493, n_and494;
    wire n_and495, n_and496, n_and497, n_and498, n_and499, n_and500, n_and501, n_and502;
    wire n_and503, n_and504, n_and505, n_and506, n_and507, n_and508, n_and509, n_and510;
    wire n_and511, n_and512, n_and513, n_and514, n_or580, n_or581, n_xor379, n_xor383;
    wire n_xor390, n_xor394, r_reg_n0, r_reg_n1, r_reg_n2, r_reg_n3, r_reg_n4, r_reg_n5;
    wire r_reg_n6, r_reg_n7;

    // ---- 4c Маска A ----
    AND u_and298 (.A(r_reg0), .B(alu_keep_r), .Y(alu_a0));
    AND u_and299 (.A(r_reg1), .B(alu_keep_r), .Y(alu_a1));
    AND u_and300 (.A(r_reg2), .B(alu_keep_r), .Y(alu_a2));
    AND u_and301 (.A(r_reg3), .B(alu_keep_r), .Y(alu_a3));
    AND u_and302 (.A(r_reg4), .B(alu_keep_r), .Y(alu_a4));
    AND u_and303 (.A(r_reg5), .B(alu_keep_r), .Y(alu_a5));
    AND u_and304 (.A(r_reg6), .B(alu_keep_r), .Y(alu_a6));
    AND u_and305 (.A(r_reg7), .B(alu_keep_r), .Y(alu_a7));
    AND u_and306 (.A(r_reg8), .B(alu_keep_r), .Y(alu_a8));
    AND u_and307 (.A(r_reg9), .B(alu_keep_r), .Y(alu_a9));
    AND u_and308 (.A(r_reg10), .B(alu_keep_r), .Y(alu_a10));
    AND u_and309 (.A(r_reg11), .B(alu_keep_r), .Y(alu_a11));
    AND u_and310 (.A(r_reg12), .B(alu_keep_r), .Y(alu_a12));
    AND u_and311 (.A(r_reg13), .B(alu_keep_r), .Y(alu_a13));
    AND u_and312 (.A(r_reg14), .B(alu_keep_r), .Y(alu_a14));
    AND u_and313 (.A(r_reg15), .B(alu_keep_r), .Y(alu_a15));

    // ---- 4e Инкремент сотен/тысяч ----
    XOR u_xor377 (.A(alu_a8), .B(alu_c2_hi), .Y(alu_s8));
    AND u_and378 (.A(alu_a8), .B(alu_c2_hi), .Y(n_and378));
    XOR u_xor379 (.A(alu_a9), .B(n_and378), .Y(n_xor379));
    AND u_and380 (.A(alu_a9), .B(n_and378), .Y(n_and380));
    XOR u_xor381 (.A(alu_a10), .B(n_and380), .Y(alu_s10));
    AND u_and382 (.A(alu_a10), .B(n_and380), .Y(n_and382));
    XOR u_xor383 (.A(alu_a11), .B(n_and382), .Y(n_xor383));
    AND u_and384 (.A(alu_a11), .B(alu_a8), .Y(n_and384));
    AND u_and385 (.A(n_and384), .B(alu_c2_hi), .Y(alu_c3));
    XOR u_xor386 (.A(n_xor379), .B(alu_c3), .Y(alu_s9));
    XOR u_xor387 (.A(n_xor383), .B(alu_c3), .Y(alu_s11));
    XOR u_xor388 (.A(alu_a12), .B(alu_c3), .Y(alu_s12));
    AND u_and389 (.A(alu_a12), .B(alu_c3), .Y(n_and389));
    XOR u_xor390 (.A(alu_a13), .B(n_and389), .Y(n_xor390));
    AND u_and391 (.A(alu_a13), .B(n_and389), .Y(n_and391));
    XOR u_xor392 (.A(alu_a14), .B(n_and391), .Y(alu_s14));
    AND u_and393 (.A(alu_a14), .B(n_and391), .Y(n_and393));
    XOR u_xor394 (.A(alu_a15), .B(n_and393), .Y(n_xor394));
    AND u_and395 (.A(alu_a15), .B(alu_a12), .Y(n_and395));
    AND u_and396 (.A(n_and395), .B(alu_c3), .Y(n_and396));
    XOR u_xor397 (.A(n_xor390), .B(n_and396), .Y(alu_s13));
    XOR u_xor398 (.A(n_xor394), .B(n_and396), .Y(alu_s15));

    // ---- 5 Регистры ----
    RS u_R0_m (.S(n_and467), .R(n_and465), .Q(R0_m_q), .QN(R0_m_qn));
    RS u_R0 (.S(n_and468), .R(n_and469), .Q(r_reg0), .QN(r_reg_n0));
    RS u_R1_m (.S(n_and470), .R(n_and465), .Q(R1_m_q), .QN(R1_m_qn));
    RS u_R1 (.S(n_and471), .R(n_and472), .Q(r_reg1), .QN(r_reg_n1));
    RS u_R2_m (.S(n_and473), .R(n_and465), .Q(R2_m_q), .QN(R2_m_qn));
    RS u_R2 (.S(n_and474), .R(n_and475), .Q(r_reg2), .QN(r_reg_n2));
    RS u_R3_m (.S(n_and476), .R(n_and465), .Q(R3_m_q), .QN(R3_m_qn));
    RS u_R3 (.S(n_and477), .R(n_and478), .Q(r_reg3), .QN(r_reg_n3));
    RS u_R4_m (.S(n_and479), .R(n_and465), .Q(R4_m_q), .QN(R4_m_qn));
    RS u_R4 (.S(n_and480), .R(n_and481), .Q(r_reg4), .QN(r_reg_n4));
    RS u_R5_m (.S(n_and482), .R(n_and465), .Q(R5_m_q), .QN(R5_m_qn));
    RS u_R5 (.S(n_and483), .R(n_and484), .Q(r_reg5), .QN(r_reg_n5));
    RS u_R6_m (.S(n_and485), .R(n_and465), .Q(R6_m_q), .QN(R6_m_qn));
    RS u_R6 (.S(n_and486), .R(n_and487), .Q(r_reg6), .QN(r_reg_n6));
    RS u_R7_m (.S(n_and488), .R(n_and465), .Q(R7_m_q), .QN(R7_m_qn));
    RS u_R7 (.S(n_and489), .R(n_and490), .Q(r_reg7), .QN(r_reg_n7));
    RS u_R8_m (.S(n_and491), .R(n_and465), .Q(R8_m_q), .QN(R8_m_qn));
    RS u_R8 (.S(n_and492), .R(n_and493), .Q(r_reg8), .QN(r_reg_n8));
    RS u_R9_m (.S(n_and494), .R(n_and465), .Q(R9_m_q), .QN(R9_m_qn));
    RS u_R9 (.S(n_and495), .R(n_and496), .Q(r_reg9), .QN(r_reg_n9));
    RS u_R10_m (.S(n_and497), .R(n_and465), .Q(R10_m_q), .QN(R10_m_qn));
    RS u_R10 (.S(n_and498), .R(n_and499), .Q(r_reg10), .QN(r_reg_n10));
    RS u_R11_m (.S(n_and500), .R(n_and465), .Q(R11_m_q), .QN(R11_m_qn));
    RS u_R11 (.S(n_and501), .R(n_and502), .Q(r_reg11), .QN(r_reg_n11));
    RS u_R12_m (.S(n_and503), .R(n_and465), .Q(R12_m_q), .QN(R12_m_qn));
    RS u_R12 (.S(n_and504), .R(n_and505), .Q(r_reg12), .QN(r_reg_n12));
    RS u_R13_m (.S(n_and506), .R(n_and465), .Q(R13_m_q), .QN(R13_m_qn));
    RS u_R13 (.S(n_and507), .R(n_and508), .Q(r_reg13), .QN(r_reg_n13));
    RS u_R14_m (.S(n_and509), .R(n_and465), .Q(R14_m_q), .QN(R14_m_qn));
    RS u_R14 (.S(n_and510), .R(n_and511), .Q(r_reg14), .QN(r_reg_n14));
    RS u_R15_m (.S(n_and512), .R(n_and465), .Q(R15_m_q), .QN(R15_m_qn));
    RS u_R15 (.S(n_and513), .R(n_and514), .Q(r_reg15), .QN(r_reg_n15));

    // ---- 5b Регистр R ----
    AND u_and465 (.A(ph1), .B(en_r), .Y(n_and465));
    AND u_and466 (.A(ph2), .B(en_r), .Y(n_and466));
    AND u_and467 (.A(alu_s0), .B(n_and466), .Y(n_and467));
    AND u_and468 (.A(R0_m_q), .B(ph3), .Y(n_and468));
    AND u_and469 (.A(R0_m_qn), .B(ph3), .Y(n_and469));
    AND u_and470 (.A(alu_s1), .B(n_and466), .Y(n_and470));
    AND u_and471 (.A(R1_m_q), .B(ph3), .Y(n_and471));
    AND u_and472 (.A(R1_m_qn), .B(ph3), .Y(n_and472));
    AND u_and473 (.A(alu_s2), .B(n_and466), .Y(n_and473));
    AND u_and474 (.A(R2_m_q), .B(ph3), .Y(n_and474));
    AND u_and475 (.A(R2_m_qn), .B(ph3), .Y(n_and475));
    AND u_and476 (.A(alu_s3), .B(n_and466), .Y(n_and476));
    AND u_and477 (.A(R3_m_q), .B(ph3), .Y(n_and477));
    AND u_and478 (.A(R3_m_qn), .B(ph3), .Y(n_and478));
    AND u_and479 (.A(alu_s4), .B(n_and466), .Y(n_and479));
    AND u_and480 (.A(R4_m_q), .B(ph3), .Y(n_and480));
    AND u_and481 (.A(R4_m_qn), .B(ph3), .Y(n_and481));
    AND u_and482 (.A(alu_s5), .B(n_and466), .Y(n_and482));
    AND u_and483 (.A(R5_m_q), .B(ph3), .Y(n_and483));
    AND u_and484 (.A(R5_m_qn), .B(ph3), .Y(n_and484));
    AND u_and485 (.A(alu_s6), .B(n_and466), .Y(n_and485));
    AND u_and486 (.A(R6_m_q), .B(ph3), .Y(n_and486));
    AND u_and487 (.A(R6_m_qn), .B(ph3), .Y(n_and487));
    AND u_and488 (.A(alu_s7), .B(n_and466), .Y(n_and488));
    AND u_and489 (.A(R7_m_q), .B(ph3), .Y(n_and489));
    AND u_and490 (.A(R7_m_qn), .B(ph3), .Y(n_and490));
    AND u_and491 (.A(alu_s8), .B(n_and466), .Y(n_and491));
    AND u_and492 (.A(R8_m_q), .B(ph3), .Y(n_and492));
    AND u_and493 (.A(R8_m_qn), .B(ph3), .Y(n_and493));
    AND u_and494 (.A(alu_s9), .B(n_and466), .Y(n_and494));
    AND u_and495 (.A(R9_m_q), .B(ph3), .Y(n_and495));
    AND u_and496 (.A(R9_m_qn), .B(ph3), .Y(n_and496));
    AND u_and497 (.A(alu_s10), .B(n_and466), .Y(n_and497));
    AND u_and498 (.A(R10_m_q), .B(ph3), .Y(n_and498));
    AND u_and499 (.A(R10_m_qn), .B(ph3), .Y(n_and499));
    AND u_and500 (.A(alu_s11), .B(n_and466), .Y(n_and500));
    AND u_and501 (.A(R11_m_q), .B(ph3), .Y(n_and501));
    AND u_and502 (.A(R11_m_qn), .B(ph3), .Y(n_and502));
    AND u_and503 (.A(alu_s12), .B(n_and466), .Y(n_and503));
    AND u_and504 (.A(R12_m_q), .B(ph3), .Y(n_and504));
    AND u_and505 (.A(R12_m_qn), .B(ph3), .Y(n_and505));
    AND u_and506 (.A(alu_s13), .B(n_and466), .Y(n_and506));
    AND u_and507 (.A(R13_m_q), .B(ph3), .Y(n_and507));
    AND u_and508 (.A(R13_m_qn), .B(ph3), .Y(n_and508));
    AND u_and509 (.A(alu_s14), .B(n_and466), .Y(n_and509));
    AND u_and510 (.A(R14_m_q), .B(ph3), .Y(n_and510));
    AND u_and511 (.A(R14_m_qn), .B(ph3), .Y(n_and511));
    AND u_and512 (.A(alu_s15), .B(n_and466), .Y(n_and512));
    AND u_and513 (.A(R15_m_q), .B(ph3), .Y(n_and513));
    AND u_and514 (.A(R15_m_qn), .B(ph3), .Y(n_and514));

    // ---- 7b Гашение нулей ----
    OR u_or580 (.A(r_reg8), .B(r_reg9), .Y(n_or580));
    OR u_or581 (.A(r_reg10), .B(r_reg11), .Y(n_or581));
    OR u_or582 (.A(n_or580), .B(n_or581), .Y(n_or582));

endmodule
