// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Сетчатка, дай B: 7 ключей, нейроны 8, 9, + − × = C, шифратор
// Элементов: 115 (AND 57, KEY 7, OR 51)
// Портов: входов 34, выходов 16

module d2_retina_b (
    cls_0, cls_1, cls_2, cls_3, cls_4, cls_5,
    cls_6, cls_7, n_and44, n_or45, pix_r2c5, pix_r3c1,
    pix_r3c1_n, pix_r3c2, pix_r3c4_n, pix_r4c2, pix_r4c3_n, pix_r4c5,
    pix_r4c5_n, pix_r5c1, pix_r5c3, pix_r5c3_n, pix_r6c3, pix_r6c4,
    pix_r6c5, pix_r6c5_n, pix_r7c4_n, tube_r1c3, tube_r1c4, tube_r2c3,
    tube_r3c3, tube_r3c5, tube_r4c1, tube_r4c4, cls_clr, cls_eq,
    cls_minus, cls_mul, is_digit, is_op, key_bcd0, key_bcd1,
    key_bcd2, key_bcd3, pix_r1c3_n, pix_r2c3, pix_r3c3_n, pix_r3c5,
    pix_r4c1, pix_r4c4_n
);
    input cls_0;
    input cls_1;
    input cls_2;
    input cls_3;
    input cls_4;
    input cls_5;
    input cls_6;
    input cls_7;
    input n_and44;
    input n_or45;
    input pix_r2c5;
    input pix_r3c1;
    input pix_r3c1_n;
    input pix_r3c2;
    input pix_r3c4_n;
    input pix_r4c2;
    input pix_r4c3_n;
    input pix_r4c5;
    input pix_r4c5_n;
    input pix_r5c1;
    input pix_r5c3;
    input pix_r5c3_n;
    input pix_r6c3;
    input pix_r6c4;
    input pix_r6c5;
    input pix_r6c5_n;
    input pix_r7c4_n;
    input tube_r1c3;
    input tube_r1c4;
    input tube_r2c3;
    input tube_r3c3;
    input tube_r3c5;
    input tube_r4c1;
    input tube_r4c4;
    output cls_clr;
    output cls_eq;
    output cls_minus;
    output cls_mul;
    output is_digit;
    output is_op;
    output key_bcd0;
    output key_bcd1;
    output key_bcd2;
    output key_bcd3;
    output pix_r1c3_n;
    output pix_r2c3;
    output pix_r3c3_n;
    output pix_r3c5;
    output pix_r4c1;
    output pix_r4c4_n;

    wire cls_8, cls_9, cls_plus, n_and100, n_and101, n_and103, n_and105, n_and107;
    wire n_and108, n_and110, n_and111, n_and113, n_and114, n_and118, n_and120, n_and121;
    wire n_and123, n_and124, n_and126, n_and127, n_and129, n_and131, n_and133, n_and134;
    wire n_and136, n_and137, n_and139, n_and140, n_and142, n_and143, n_and145, n_and146;
    wire n_and148, n_and150, n_and152, n_and153, n_and155, n_and156, n_and158, n_and160;
    wire n_and162, n_and163, n_and165, n_and166, n_and168, n_and170, n_and172, n_and173;
    wire n_and175, n_and176, n_and178, n_and179, n_and87, n_and89, n_and91, n_and92;
    wire n_and94, n_and95, n_and97, n_and98, n_or104, n_or106, n_or109, n_or112;
    wire n_or119, n_or122, n_or125, n_or130, n_or132, n_or135, n_or138, n_or141;
    wire n_or144, n_or149, n_or151, n_or154, n_or159, n_or161, n_or164, n_or169;
    wire n_or171, n_or174, n_or177, n_or181, n_or182, n_or183, n_or185, n_or186;
    wire n_or188, n_or192, n_or193, n_or194, n_or196, n_or88, n_or90, n_or93;
    wire n_or96, n_or99, pix_r1c3, pix_r1c4, pix_r1c4_n, pix_r2c3_n, pix_r3c3, pix_r3c5_n;
    wire pix_r4c1_n, pix_r4c4;

    // ---- 1 Входные ключи ----
    KEY u_px_R1C3 (.A(tube_r1c3), .Y(pix_r1c3), .YN(pix_r1c3_n));
    KEY u_px_R1C4 (.A(tube_r1c4), .Y(pix_r1c4), .YN(pix_r1c4_n));
    KEY u_px_R2C3 (.A(tube_r2c3), .Y(pix_r2c3), .YN(pix_r2c3_n));
    KEY u_px_R3C3 (.A(tube_r3c3), .Y(pix_r3c3), .YN(pix_r3c3_n));
    KEY u_px_R3C5 (.A(tube_r3c5), .Y(pix_r3c5), .YN(pix_r3c5_n));
    KEY u_px_R4C1 (.A(tube_r4c1), .Y(pix_r4c1), .YN(pix_r4c1_n));
    KEY u_px_R4C4 (.A(tube_r4c4), .Y(pix_r4c4), .YN(pix_r4c4_n));

    // ---- 2 Распознаватель ----
    AND u_and87 (.A(pix_r2c5), .B(pix_r3c5), .Y(n_and87));
    OR u_or88 (.A(pix_r2c5), .B(pix_r3c5), .Y(n_or88));
    AND u_and89 (.A(n_or88), .B(pix_r4c1_n), .Y(n_and89));
    OR u_or90 (.A(n_and89), .B(n_and87), .Y(n_or90));
    AND u_and91 (.A(n_and87), .B(pix_r4c1_n), .Y(n_and91));
    AND u_and92 (.A(n_or90), .B(pix_r4c2), .Y(n_and92));
    OR u_or93 (.A(n_and92), .B(n_and91), .Y(n_or93));
    AND u_and94 (.A(n_and91), .B(pix_r4c2), .Y(n_and94));
    AND u_and95 (.A(n_or93), .B(pix_r4c5_n), .Y(n_and95));
    OR u_or96 (.A(n_and95), .B(n_and94), .Y(n_or96));
    AND u_and97 (.A(n_and94), .B(pix_r4c5_n), .Y(n_and97));
    AND u_and98 (.A(n_or96), .B(pix_r5c1), .Y(n_and98));
    OR u_or99 (.A(n_and98), .B(n_and97), .Y(n_or99));
    AND u_and100 (.A(n_and97), .B(pix_r5c1), .Y(n_and100));
    AND u_and101 (.A(n_or99), .B(pix_r6c5), .Y(n_and101));
    OR u_or102 (.A(n_and101), .B(n_and100), .Y(cls_8));
    AND u_and103 (.A(pix_r1c3), .B(pix_r3c1), .Y(n_and103));
    OR u_or104 (.A(pix_r1c3), .B(pix_r3c1), .Y(n_or104));
    AND u_and105 (.A(n_or104), .B(pix_r4c4), .Y(n_and105));
    OR u_or106 (.A(n_and105), .B(n_and103), .Y(n_or106));
    AND u_and107 (.A(n_and103), .B(pix_r4c4), .Y(n_and107));
    AND u_and108 (.A(n_or106), .B(pix_r6c4), .Y(n_and108));
    OR u_or109 (.A(n_and108), .B(n_and107), .Y(n_or109));
    AND u_and110 (.A(n_and107), .B(pix_r6c4), .Y(n_and110));
    AND u_and111 (.A(n_or109), .B(pix_r6c5_n), .Y(n_and111));
    OR u_or112 (.A(n_and111), .B(n_and110), .Y(n_or112));
    AND u_and113 (.A(n_and110), .B(pix_r6c5_n), .Y(n_and113));
    AND u_and114 (.A(n_or112), .B(pix_r7c4_n), .Y(n_and114));
    OR u_or115 (.A(n_and114), .B(n_and113), .Y(cls_9));
    AND u_and118 (.A(n_or45), .B(pix_r4c2), .Y(n_and118));
    OR u_or119 (.A(n_and118), .B(n_and44), .Y(n_or119));
    AND u_and120 (.A(n_and44), .B(pix_r4c2), .Y(n_and120));
    AND u_and121 (.A(n_or119), .B(pix_r5c3), .Y(n_and121));
    OR u_or122 (.A(n_and121), .B(n_and120), .Y(n_or122));
    AND u_and123 (.A(n_and120), .B(pix_r5c3), .Y(n_and123));
    AND u_and124 (.A(n_or122), .B(pix_r6c3), .Y(n_and124));
    OR u_or125 (.A(n_and124), .B(n_and123), .Y(n_or125));
    AND u_and126 (.A(n_and123), .B(pix_r6c3), .Y(n_and126));
    AND u_and127 (.A(n_or125), .B(pix_r7c4_n), .Y(n_and127));
    OR u_or128 (.A(n_and127), .B(n_and126), .Y(cls_plus));
    AND u_and129 (.A(pix_r1c4_n), .B(pix_r2c3_n), .Y(n_and129));
    OR u_or130 (.A(pix_r1c4_n), .B(pix_r2c3_n), .Y(n_or130));
    AND u_and131 (.A(n_or130), .B(pix_r3c1_n), .Y(n_and131));
    OR u_or132 (.A(n_and131), .B(n_and129), .Y(n_or132));
    AND u_and133 (.A(n_and129), .B(pix_r3c1_n), .Y(n_and133));
    AND u_and134 (.A(n_or132), .B(pix_r3c3_n), .Y(n_and134));
    OR u_or135 (.A(n_and134), .B(n_and133), .Y(n_or135));
    AND u_and136 (.A(n_and133), .B(pix_r3c3_n), .Y(n_and136));
    AND u_and137 (.A(n_or135), .B(pix_r3c4_n), .Y(n_and137));
    OR u_or138 (.A(n_and137), .B(n_and136), .Y(n_or138));
    AND u_and139 (.A(n_and136), .B(pix_r3c4_n), .Y(n_and139));
    AND u_and140 (.A(n_or138), .B(pix_r4c1), .Y(n_and140));
    OR u_or141 (.A(n_and140), .B(n_and139), .Y(n_or141));
    AND u_and142 (.A(n_and139), .B(pix_r4c1), .Y(n_and142));
    AND u_and143 (.A(n_or141), .B(pix_r4c5), .Y(n_and143));
    OR u_or144 (.A(n_and143), .B(n_and142), .Y(n_or144));
    AND u_and145 (.A(n_and142), .B(pix_r4c5), .Y(n_and145));
    AND u_and146 (.A(n_or144), .B(pix_r5c3_n), .Y(n_and146));
    OR u_or147 (.A(n_and146), .B(n_and145), .Y(cls_minus));
    AND u_and148 (.A(pix_r1c4_n), .B(pix_r2c5), .Y(n_and148));
    OR u_or149 (.A(pix_r1c4_n), .B(pix_r2c5), .Y(n_or149));
    AND u_and150 (.A(n_or149), .B(pix_r3c1_n), .Y(n_and150));
    OR u_or151 (.A(n_and150), .B(n_and148), .Y(n_or151));
    AND u_and152 (.A(n_and148), .B(pix_r3c1_n), .Y(n_and152));
    AND u_and153 (.A(n_or151), .B(pix_r3c2), .Y(n_and153));
    OR u_or154 (.A(n_and153), .B(n_and152), .Y(n_or154));
    AND u_and155 (.A(n_and152), .B(pix_r3c2), .Y(n_and155));
    AND u_and156 (.A(n_or154), .B(pix_r6c5), .Y(n_and156));
    OR u_or157 (.A(n_and156), .B(n_and155), .Y(cls_mul));
    AND u_and158 (.A(pix_r1c4_n), .B(pix_r3c3), .Y(n_and158));
    OR u_or159 (.A(pix_r1c4_n), .B(pix_r3c3), .Y(n_or159));
    AND u_and160 (.A(n_or159), .B(pix_r3c5), .Y(n_and160));
    OR u_or161 (.A(n_and160), .B(n_and158), .Y(n_or161));
    AND u_and162 (.A(n_and158), .B(pix_r3c5), .Y(n_and162));
    AND u_and163 (.A(n_or161), .B(pix_r4c3_n), .Y(n_and163));
    OR u_or164 (.A(n_and163), .B(n_and162), .Y(n_or164));
    AND u_and165 (.A(n_and162), .B(pix_r4c3_n), .Y(n_and165));
    AND u_and166 (.A(n_or164), .B(pix_r5c1), .Y(n_and166));
    OR u_or167 (.A(n_and166), .B(n_and165), .Y(cls_eq));
    AND u_and168 (.A(pix_r2c5), .B(pix_r3c4_n), .Y(n_and168));
    OR u_or169 (.A(pix_r2c5), .B(pix_r3c4_n), .Y(n_or169));
    AND u_and170 (.A(n_or169), .B(pix_r3c5_n), .Y(n_and170));
    OR u_or171 (.A(n_and170), .B(n_and168), .Y(n_or171));
    AND u_and172 (.A(n_and168), .B(pix_r3c5_n), .Y(n_and172));
    AND u_and173 (.A(n_or171), .B(pix_r4c3_n), .Y(n_and173));
    OR u_or174 (.A(n_and173), .B(n_and172), .Y(n_or174));
    AND u_and175 (.A(n_and172), .B(pix_r4c3_n), .Y(n_and175));
    AND u_and176 (.A(n_or174), .B(pix_r4c4_n), .Y(n_and176));
    OR u_or177 (.A(n_and176), .B(n_and175), .Y(n_or177));
    AND u_and178 (.A(n_and175), .B(pix_r4c4_n), .Y(n_and178));
    AND u_and179 (.A(n_or177), .B(pix_r5c1), .Y(n_and179));
    OR u_or180 (.A(n_and179), .B(n_and178), .Y(cls_clr));

    // ---- 3 Шифратор ----
    OR u_or181 (.A(cls_1), .B(cls_3), .Y(n_or181));
    OR u_or182 (.A(cls_5), .B(cls_7), .Y(n_or182));
    OR u_or183 (.A(n_or181), .B(n_or182), .Y(n_or183));
    OR u_or184 (.A(n_or183), .B(cls_9), .Y(key_bcd0));
    OR u_or185 (.A(cls_2), .B(cls_3), .Y(n_or185));
    OR u_or186 (.A(cls_6), .B(cls_7), .Y(n_or186));
    OR u_or187 (.A(n_or185), .B(n_or186), .Y(key_bcd1));
    OR u_or188 (.A(cls_4), .B(cls_5), .Y(n_or188));
    OR u_or190 (.A(n_or188), .B(n_or186), .Y(key_bcd2));
    OR u_or191 (.A(cls_8), .B(cls_9), .Y(key_bcd3));
    OR u_or192 (.A(key_bcd0), .B(key_bcd1), .Y(n_or192));
    OR u_or193 (.A(key_bcd2), .B(key_bcd3), .Y(n_or193));
    OR u_or194 (.A(n_or192), .B(n_or193), .Y(n_or194));
    OR u_or195 (.A(n_or194), .B(cls_0), .Y(is_digit));
    OR u_or196 (.A(cls_plus), .B(cls_minus), .Y(n_or196));
    OR u_or197 (.A(n_or196), .B(cls_mul), .Y(is_op));

endmodule
