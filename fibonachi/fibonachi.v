module fibonachi #(
parameter WIDTH=4
)(
input wire [WIDTH-1:0] A,
input wire [WIDTH-1:0] B,
output wire [WIDTH-1:0] out
);

assign out = A + B;

endmodule

