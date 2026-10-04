// Струйный калькулятор — библиотека элементов для моделирования и синтеза.
// Имена ячеек и пинов совпадают с adder/fluidic.lib (AND, OR, NOR, NOT, XOR: пины A/B/Y),
// добавлены RS (ячейка памяти), KEY (ключ трубочки) и OSC (струйный генератор).
//
// С `define SYNTHESIS элементы — чёрные ящики: yosys сохраняет иерархию даёв и блоков как есть.
// Без него — поведенческие модели с задержкой элемента `FL_DLY (мс при `timescale 1ms/10us).

`timescale 1ms/10us

`ifndef FL_DLY
`define FL_DLY 1.5
`endif

`ifdef SYNTHESIS
(* blackbox *) module AND (A, B, Y); input A, B; output Y; endmodule
(* blackbox *) module OR  (A, B, Y); input A, B; output Y; endmodule
(* blackbox *) module NOR (A, B, Y); input A, B; output Y; endmodule
(* blackbox *) module NOT (A, Y);    input A;    output Y; endmodule
(* blackbox *) module XOR (A, B, Y); input A, B; output Y; endmodule
(* blackbox *) module RS  (S, R, Q, QN); input S, R; output Q, QN; endmodule
(* blackbox *) module KEY (A, Y, YN); input A; output Y, YN; endmodule
(* blackbox *) module OSC (Y); output Y; endmodule
`else
// 2И
module AND (A, B, Y); input A, B; output Y; assign #(`FL_DLY) Y = A & B; endmodule
// 2ИЛИ (выход 6 элемента NOR в KiCad-библиотеке)
module OR  (A, B, Y); input A, B; output Y; assign #(`FL_DLY) Y = A | B; endmodule
// 2ИЛИ-НЕ (выход 7 элемента NOR)
module NOR (A, B, Y); input A, B; output Y; assign #(`FL_DLY) Y = ~(A | B); endmodule
// НЕ — элемент NOR с одним входом
module NOT (A, Y); input A; output Y; assign #(`FL_DLY) Y = ~A; endmodule
// 2 искл. ИЛИ
module XOR (A, B, Y); input A, B; output Y; assign #(`FL_DLY) Y = A ^ B; endmodule

// Ячейка памяти: бистабильный элемент. S — установка, R — сброс, выходы Q и QN.
// Схема никогда не подаёт S и R одновременно; модель сообщает, если это случится.
module RS (S, R, Q, QN);
    input S, R;
    output Q, QN;
    reg q;
    initial q = 1'b0;
    always @(S or R) begin
        if (S && R) $display("%t ОШИБКА: S и R одновременно в %m", $time);
        else if (S) q <= #(`FL_DLY) 1'b1;
        else if (R) q <= #(`FL_DLY) 1'b0;
    end
    assign Q = q;
    assign QN = ~q;
endmodule

// Ключ трубочки матрицы: A = 1, когда трубочка закрыта силуэтом. Прямой и инверсный выходы.
module KEY (A, Y, YN);
    input A;
    output Y, YN;
    assign #(`FL_DLY) Y = A;
    assign #(`FL_DLY) YN = ~A;
endmodule

// Струйный генератор: элемент с обратной связью через ёмкость. Полупериод OSC_HALF, мс.
module OSC (Y);
    output Y;
    parameter OSC_HALF = 100;
    reg y;
    initial y = 1'b0;
    always #(OSC_HALF) y = ~y;
    assign Y = y;
endmodule
`endif
