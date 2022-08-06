module adder #(
parameter WIDTH=4
)(
input wire ci,
input wire [WIDTH-1:0] A,
input wire [WIDTH-1:0] B,
output wire [WIDTH-1:0] out,
output wire co
);

assign {co,out} = A + B + ci;

endmodule

