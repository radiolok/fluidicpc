// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Сетчатка, дай A: 19 входных ключей, нейроны 0–7
// Элементов: 105 (AND 52, KEY 19, OR 34)
// Портов: входов 25, выходов 27

module d1_retina_a (
    pix_r1c3_n, pix_r2c3, pix_r3c3_n, pix_r3c5, pix_r4c1, pix_r4c4_n,
    tube_r1c5, tube_r2c2, tube_r2c4, tube_r2c5, tube_r3c1, tube_r3c2,
    tube_r3c4, tube_r4c2, tube_r4c3, tube_r4c5, tube_r5c1, tube_r5c2,
    tube_r5c3, tube_r6c2, tube_r6c3, tube_r6c4, tube_r6c5, tube_r7c1,
    tube_r7c4, cls_0, cls_1, cls_2, cls_3, cls_4,
    cls_5, cls_6, cls_7, n_and44, n_or45, pix_r2c5,
    pix_r3c1, pix_r3c1_n, pix_r3c2, pix_r3c4_n, pix_r4c2, pix_r4c3_n,
    pix_r4c5, pix_r4c5_n, pix_r5c1, pix_r5c3, pix_r5c3_n, pix_r6c3,
    pix_r6c4, pix_r6c5, pix_r6c5_n, pix_r7c4_n
);
    input pix_r1c3_n;
    input pix_r2c3;
    input pix_r3c3_n;
    input pix_r3c5;
    input pix_r4c1;
    input pix_r4c4_n;
    input tube_r1c5;
    input tube_r2c2;
    input tube_r2c4;
    input tube_r2c5;
    input tube_r3c1;
    input tube_r3c2;
    input tube_r3c4;
    input tube_r4c2;
    input tube_r4c3;
    input tube_r4c5;
    input tube_r5c1;
    input tube_r5c2;
    input tube_r5c3;
    input tube_r6c2;
    input tube_r6c3;
    input tube_r6c4;
    input tube_r6c5;
    input tube_r7c1;
    input tube_r7c4;
    output cls_0;
    output cls_1;
    output cls_2;
    output cls_3;
    output cls_4;
    output cls_5;
    output cls_6;
    output cls_7;
    output n_and44;
    output n_or45;
    output pix_r2c5;
    output pix_r3c1;
    output pix_r3c1_n;
    output pix_r3c2;
    output pix_r3c4_n;
    output pix_r4c2;
    output pix_r4c3_n;
    output pix_r4c5;
    output pix_r4c5_n;
    output pix_r5c1;
    output pix_r5c3;
    output pix_r5c3_n;
    output pix_r6c3;
    output pix_r6c4;
    output pix_r6c5;
    output pix_r6c5_n;
    output pix_r7c4_n;

    wire n_and1, n_and11, n_and12, n_and14, n_and16, n_and18, n_and19, n_and21;
    wire n_and22, n_and24, n_and26, n_and28, n_and29, n_and3, n_and31, n_and32;
    wire n_and34, n_and36, n_and38, n_and39, n_and41, n_and42, n_and46, n_and48;
    wire n_and49, n_and5, n_and51, n_and52, n_and54, n_and56, n_and58, n_and59;
    wire n_and6, n_and61, n_and62, n_and64, n_and66, n_and68, n_and69, n_and71;
    wire n_and72, n_and74, n_and75, n_and77, n_and79, n_and8, n_and81, n_and82;
    wire n_and84, n_and85, n_and9, n_or10, n_or15, n_or17, n_or2, n_or20;
    wire n_or25, n_or27, n_or30, n_or35, n_or37, n_or4, n_or40, n_or47;
    wire n_or50, n_or55, n_or57, n_or60, n_or65, n_or67, n_or7, n_or70;
    wire n_or73, n_or78, n_or80, n_or83, pix_r1c5, pix_r1c5_n, pix_r2c2, pix_r2c2_n;
    wire pix_r2c4, pix_r2c4_n, pix_r2c5_n, pix_r3c2_n, pix_r3c4, pix_r4c2_n, pix_r4c3, pix_r5c1_n;
    wire pix_r5c2, pix_r5c2_n, pix_r6c2, pix_r6c2_n, pix_r6c3_n, pix_r6c4_n, pix_r7c1, pix_r7c1_n;
    wire pix_r7c4;

    // ---- 1 Входные ключи ----
    KEY u_px_R1C5 (.A(tube_r1c5), .Y(pix_r1c5), .YN(pix_r1c5_n));
    KEY u_px_R2C2 (.A(tube_r2c2), .Y(pix_r2c2), .YN(pix_r2c2_n));
    KEY u_px_R2C4 (.A(tube_r2c4), .Y(pix_r2c4), .YN(pix_r2c4_n));
    KEY u_px_R2C5 (.A(tube_r2c5), .Y(pix_r2c5), .YN(pix_r2c5_n));
    KEY u_px_R3C1 (.A(tube_r3c1), .Y(pix_r3c1), .YN(pix_r3c1_n));
    KEY u_px_R3C2 (.A(tube_r3c2), .Y(pix_r3c2), .YN(pix_r3c2_n));
    KEY u_px_R3C4 (.A(tube_r3c4), .Y(pix_r3c4), .YN(pix_r3c4_n));
    KEY u_px_R4C2 (.A(tube_r4c2), .Y(pix_r4c2), .YN(pix_r4c2_n));
    KEY u_px_R4C3 (.A(tube_r4c3), .Y(pix_r4c3), .YN(pix_r4c3_n));
    KEY u_px_R4C5 (.A(tube_r4c5), .Y(pix_r4c5), .YN(pix_r4c5_n));
    KEY u_px_R5C1 (.A(tube_r5c1), .Y(pix_r5c1), .YN(pix_r5c1_n));
    KEY u_px_R5C2 (.A(tube_r5c2), .Y(pix_r5c2), .YN(pix_r5c2_n));
    KEY u_px_R5C3 (.A(tube_r5c3), .Y(pix_r5c3), .YN(pix_r5c3_n));
    KEY u_px_R6C2 (.A(tube_r6c2), .Y(pix_r6c2), .YN(pix_r6c2_n));
    KEY u_px_R6C3 (.A(tube_r6c3), .Y(pix_r6c3), .YN(pix_r6c3_n));
    KEY u_px_R6C4 (.A(tube_r6c4), .Y(pix_r6c4), .YN(pix_r6c4_n));
    KEY u_px_R6C5 (.A(tube_r6c5), .Y(pix_r6c5), .YN(pix_r6c5_n));
    KEY u_px_R7C1 (.A(tube_r7c1), .Y(pix_r7c1), .YN(pix_r7c1_n));
    KEY u_px_R7C4 (.A(tube_r7c4), .Y(pix_r7c4), .YN(pix_r7c4_n));

    // ---- 2 Распознаватель ----
    AND u_and1 (.A(pix_r3c5), .B(pix_r4c1), .Y(n_and1));
    OR u_or2 (.A(pix_r3c5), .B(pix_r4c1), .Y(n_or2));
    AND u_and3 (.A(n_or2), .B(pix_r4c2_n), .Y(n_and3));
    OR u_or4 (.A(n_and3), .B(n_and1), .Y(n_or4));
    AND u_and5 (.A(n_and1), .B(pix_r4c2_n), .Y(n_and5));
    AND u_and6 (.A(n_or4), .B(pix_r4c5), .Y(n_and6));
    OR u_or7 (.A(n_and6), .B(n_and5), .Y(n_or7));
    AND u_and8 (.A(n_and5), .B(pix_r4c5), .Y(n_and8));
    AND u_and9 (.A(n_or7), .B(pix_r5c2), .Y(n_and9));
    OR u_or10 (.A(n_and9), .B(n_and8), .Y(n_or10));
    AND u_and11 (.A(n_and8), .B(pix_r5c2), .Y(n_and11));
    AND u_and12 (.A(n_or10), .B(pix_r5c3_n), .Y(n_and12));
    OR u_or13 (.A(n_and12), .B(n_and11), .Y(cls_0));
    AND u_and14 (.A(pix_r2c2), .B(pix_r4c4_n), .Y(n_and14));
    OR u_or15 (.A(pix_r2c2), .B(pix_r4c4_n), .Y(n_or15));
    AND u_and16 (.A(n_or15), .B(pix_r6c3), .Y(n_and16));
    OR u_or17 (.A(n_and16), .B(n_and14), .Y(n_or17));
    AND u_and18 (.A(n_and14), .B(pix_r6c3), .Y(n_and18));
    AND u_and19 (.A(n_or17), .B(pix_r6c5_n), .Y(n_and19));
    OR u_or20 (.A(n_and19), .B(n_and18), .Y(n_or20));
    AND u_and21 (.A(n_and18), .B(pix_r6c5_n), .Y(n_and21));
    AND u_and22 (.A(n_or20), .B(pix_r7c4), .Y(n_and22));
    OR u_or23 (.A(n_and22), .B(n_and21), .Y(cls_1));
    AND u_and24 (.A(pix_r4c3_n), .B(pix_r5c1_n), .Y(n_and24));
    OR u_or25 (.A(pix_r4c3_n), .B(pix_r5c1_n), .Y(n_or25));
    AND u_and26 (.A(n_or25), .B(pix_r5c3), .Y(n_and26));
    OR u_or27 (.A(n_and26), .B(n_and24), .Y(n_or27));
    AND u_and28 (.A(n_and24), .B(pix_r5c3), .Y(n_and28));
    AND u_and29 (.A(n_or27), .B(pix_r6c2), .Y(n_and29));
    OR u_or30 (.A(n_and29), .B(n_and28), .Y(n_or30));
    AND u_and31 (.A(n_and28), .B(pix_r6c2), .Y(n_and31));
    AND u_and32 (.A(n_or30), .B(pix_r7c1), .Y(n_and32));
    OR u_or33 (.A(n_and32), .B(n_and31), .Y(cls_2));
    AND u_and34 (.A(pix_r1c5), .B(pix_r2c4), .Y(n_and34));
    OR u_or35 (.A(pix_r1c5), .B(pix_r2c4), .Y(n_or35));
    AND u_and36 (.A(n_or35), .B(pix_r3c1_n), .Y(n_and36));
    OR u_or37 (.A(n_and36), .B(n_and34), .Y(n_or37));
    AND u_and38 (.A(n_and34), .B(pix_r3c1_n), .Y(n_and38));
    AND u_and39 (.A(n_or37), .B(pix_r3c4_n), .Y(n_and39));
    OR u_or40 (.A(n_and39), .B(n_and38), .Y(n_or40));
    AND u_and41 (.A(n_and38), .B(pix_r3c4_n), .Y(n_and41));
    AND u_and42 (.A(n_or40), .B(pix_r6c5), .Y(n_and42));
    OR u_or43 (.A(n_and42), .B(n_and41), .Y(cls_3));
    AND u_and44 (.A(pix_r1c3_n), .B(pix_r2c3), .Y(n_and44));
    OR u_or45 (.A(pix_r1c3_n), .B(pix_r2c3), .Y(n_or45));
    AND u_and46 (.A(n_or45), .B(pix_r2c4), .Y(n_and46));
    OR u_or47 (.A(n_and46), .B(n_and44), .Y(n_or47));
    AND u_and48 (.A(n_and44), .B(pix_r2c4), .Y(n_and48));
    AND u_and49 (.A(n_or47), .B(pix_r3c3_n), .Y(n_and49));
    OR u_or50 (.A(n_and49), .B(n_and48), .Y(n_or50));
    AND u_and51 (.A(n_and48), .B(pix_r3c3_n), .Y(n_and51));
    AND u_and52 (.A(n_or50), .B(pix_r6c4), .Y(n_and52));
    OR u_or53 (.A(n_and52), .B(n_and51), .Y(cls_4));
    AND u_and54 (.A(pix_r1c5), .B(pix_r3c2), .Y(n_and54));
    OR u_or55 (.A(pix_r1c5), .B(pix_r3c2), .Y(n_or55));
    AND u_and56 (.A(n_or55), .B(pix_r4c4_n), .Y(n_and56));
    OR u_or57 (.A(n_and56), .B(n_and54), .Y(n_or57));
    AND u_and58 (.A(n_and54), .B(pix_r4c4_n), .Y(n_and58));
    AND u_and59 (.A(n_or57), .B(pix_r4c5), .Y(n_and59));
    OR u_or60 (.A(n_and59), .B(n_and58), .Y(n_or60));
    AND u_and61 (.A(n_and58), .B(pix_r4c5), .Y(n_and61));
    AND u_and62 (.A(n_or60), .B(pix_r5c2_n), .Y(n_and62));
    OR u_or63 (.A(n_and62), .B(n_and61), .Y(cls_5));
    AND u_and64 (.A(pix_r2c2), .B(pix_r2c5_n), .Y(n_and64));
    OR u_or65 (.A(pix_r2c2), .B(pix_r2c5_n), .Y(n_or65));
    AND u_and66 (.A(n_or65), .B(pix_r3c1), .Y(n_and66));
    OR u_or67 (.A(n_and66), .B(n_and64), .Y(n_or67));
    AND u_and68 (.A(n_and64), .B(pix_r3c1), .Y(n_and68));
    AND u_and69 (.A(n_or67), .B(pix_r4c1), .Y(n_and69));
    OR u_or70 (.A(n_and69), .B(n_and68), .Y(n_or70));
    AND u_and71 (.A(n_and68), .B(pix_r4c1), .Y(n_and71));
    AND u_and72 (.A(n_or70), .B(pix_r4c2), .Y(n_and72));
    OR u_or73 (.A(n_and72), .B(n_and71), .Y(n_or73));
    AND u_and74 (.A(n_and71), .B(pix_r4c2), .Y(n_and74));
    AND u_and75 (.A(n_or73), .B(pix_r4c5_n), .Y(n_and75));
    OR u_or76 (.A(n_and75), .B(n_and74), .Y(cls_6));
    AND u_and77 (.A(pix_r1c5), .B(pix_r3c2_n), .Y(n_and77));
    OR u_or78 (.A(pix_r1c5), .B(pix_r3c2_n), .Y(n_or78));
    AND u_and79 (.A(n_or78), .B(pix_r5c2), .Y(n_and79));
    OR u_or80 (.A(n_and79), .B(n_and77), .Y(n_or80));
    AND u_and81 (.A(n_and77), .B(pix_r5c2), .Y(n_and81));
    AND u_and82 (.A(n_or80), .B(pix_r6c2), .Y(n_and82));
    OR u_or83 (.A(n_and82), .B(n_and81), .Y(n_or83));
    AND u_and84 (.A(n_and81), .B(pix_r6c2), .Y(n_and84));
    AND u_and85 (.A(n_or83), .B(pix_r7c4_n), .Y(n_and85));
    OR u_or86 (.A(n_and85), .B(n_and84), .Y(cls_7));

endmodule
