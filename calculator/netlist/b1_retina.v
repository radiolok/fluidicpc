// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// Блок B1 «Сетчатка»: два зеркальных дая и общий соединительный пакет.
// Порты на нижней кромке: входов 26, выходов 10. Переходов между даями: 33.

module b1_retina (
    tube_r1c3, tube_r1c4, tube_r1c5, tube_r2c2, tube_r2c3, tube_r2c4,
    tube_r2c5, tube_r3c1, tube_r3c2, tube_r3c3, tube_r3c4, tube_r3c5,
    tube_r4c1, tube_r4c2, tube_r4c3, tube_r4c4, tube_r4c5, tube_r5c1,
    tube_r5c2, tube_r5c3, tube_r6c2, tube_r6c3, tube_r6c4, tube_r6c5,
    tube_r7c1, tube_r7c4, cls_clr, cls_eq, cls_minus, cls_mul,
    is_digit, is_op, key_bcd0, key_bcd1, key_bcd2, key_bcd3
);
    input tube_r1c3;
    input tube_r1c4;
    input tube_r1c5;
    input tube_r2c2;
    input tube_r2c3;
    input tube_r2c4;
    input tube_r2c5;
    input tube_r3c1;
    input tube_r3c2;
    input tube_r3c3;
    input tube_r3c4;
    input tube_r3c5;
    input tube_r4c1;
    input tube_r4c2;
    input tube_r4c3;
    input tube_r4c4;
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

    wire cls_0, cls_1, cls_2, cls_3, cls_4, cls_5, cls_6, cls_7;
    wire n_and44, n_or45, pix_r1c3_n, pix_r2c3, pix_r2c5, pix_r3c1, pix_r3c1_n, pix_r3c2;
    wire pix_r3c3_n, pix_r3c4_n, pix_r3c5, pix_r4c1, pix_r4c2, pix_r4c3_n, pix_r4c4_n, pix_r4c5;
    wire pix_r4c5_n, pix_r5c1, pix_r5c3, pix_r5c3_n, pix_r6c3, pix_r6c4, pix_r6c5, pix_r6c5_n;
    wire pix_r7c4_n;

    d1_retina_a u_die_a (
        .pix_r1c3_n(pix_r1c3_n),
        .pix_r2c3(pix_r2c3),
        .pix_r3c3_n(pix_r3c3_n),
        .pix_r3c5(pix_r3c5),
        .pix_r4c1(pix_r4c1),
        .pix_r4c4_n(pix_r4c4_n),
        .tube_r1c5(tube_r1c5),
        .tube_r2c2(tube_r2c2),
        .tube_r2c4(tube_r2c4),
        .tube_r2c5(tube_r2c5),
        .tube_r3c1(tube_r3c1),
        .tube_r3c2(tube_r3c2),
        .tube_r3c4(tube_r3c4),
        .tube_r4c2(tube_r4c2),
        .tube_r4c3(tube_r4c3),
        .tube_r4c5(tube_r4c5),
        .tube_r5c1(tube_r5c1),
        .tube_r5c2(tube_r5c2),
        .tube_r5c3(tube_r5c3),
        .tube_r6c2(tube_r6c2),
        .tube_r6c3(tube_r6c3),
        .tube_r6c4(tube_r6c4),
        .tube_r6c5(tube_r6c5),
        .tube_r7c1(tube_r7c1),
        .tube_r7c4(tube_r7c4),
        .cls_0(cls_0),
        .cls_1(cls_1),
        .cls_2(cls_2),
        .cls_3(cls_3),
        .cls_4(cls_4),
        .cls_5(cls_5),
        .cls_6(cls_6),
        .cls_7(cls_7),
        .n_and44(n_and44),
        .n_or45(n_or45),
        .pix_r2c5(pix_r2c5),
        .pix_r3c1(pix_r3c1),
        .pix_r3c1_n(pix_r3c1_n),
        .pix_r3c2(pix_r3c2),
        .pix_r3c4_n(pix_r3c4_n),
        .pix_r4c2(pix_r4c2),
        .pix_r4c3_n(pix_r4c3_n),
        .pix_r4c5(pix_r4c5),
        .pix_r4c5_n(pix_r4c5_n),
        .pix_r5c1(pix_r5c1),
        .pix_r5c3(pix_r5c3),
        .pix_r5c3_n(pix_r5c3_n),
        .pix_r6c3(pix_r6c3),
        .pix_r6c4(pix_r6c4),
        .pix_r6c5(pix_r6c5),
        .pix_r6c5_n(pix_r6c5_n),
        .pix_r7c4_n(pix_r7c4_n)
    );

    d2_retina_b u_die_b (
        .cls_0(cls_0),
        .cls_1(cls_1),
        .cls_2(cls_2),
        .cls_3(cls_3),
        .cls_4(cls_4),
        .cls_5(cls_5),
        .cls_6(cls_6),
        .cls_7(cls_7),
        .n_and44(n_and44),
        .n_or45(n_or45),
        .pix_r2c5(pix_r2c5),
        .pix_r3c1(pix_r3c1),
        .pix_r3c1_n(pix_r3c1_n),
        .pix_r3c2(pix_r3c2),
        .pix_r3c4_n(pix_r3c4_n),
        .pix_r4c2(pix_r4c2),
        .pix_r4c3_n(pix_r4c3_n),
        .pix_r4c5(pix_r4c5),
        .pix_r4c5_n(pix_r4c5_n),
        .pix_r5c1(pix_r5c1),
        .pix_r5c3(pix_r5c3),
        .pix_r5c3_n(pix_r5c3_n),
        .pix_r6c3(pix_r6c3),
        .pix_r6c4(pix_r6c4),
        .pix_r6c5(pix_r6c5),
        .pix_r6c5_n(pix_r6c5_n),
        .pix_r7c4_n(pix_r7c4_n),
        .tube_r1c3(tube_r1c3),
        .tube_r1c4(tube_r1c4),
        .tube_r2c3(tube_r2c3),
        .tube_r3c3(tube_r3c3),
        .tube_r3c5(tube_r3c5),
        .tube_r4c1(tube_r4c1),
        .tube_r4c4(tube_r4c4),
        .cls_clr(cls_clr),
        .cls_eq(cls_eq),
        .cls_minus(cls_minus),
        .cls_mul(cls_mul),
        .is_digit(is_digit),
        .is_op(is_op),
        .key_bcd0(key_bcd0),
        .key_bcd1(key_bcd1),
        .key_bcd2(key_bcd2),
        .key_bcd3(key_bcd3),
        .pix_r1c3_n(pix_r1c3_n),
        .pix_r2c3(pix_r2c3),
        .pix_r3c3_n(pix_r3c3_n),
        .pix_r3c5(pix_r3c5),
        .pix_r4c1(pix_r4c1),
        .pix_r4c4_n(pix_r4c4_n)
    );

endmodule
