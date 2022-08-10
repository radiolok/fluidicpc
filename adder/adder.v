
module FA(
input wire ci,
input wire A,
input wire B,
output wire out,
output wire co
);

assign {co,out} = A + B + ci;

endmodule

module adder #(
parameter WIDTH=4
)(
input wire ci,
input wire [WIDTH-1:0] A,
input wire [WIDTH-1:0] B,
output wire [WIDTH-1:0] out,
output wire co
);

genvar i;
generate

  for (i=0; i < WIDTH; i=i+1) begin: Add
    wire c_out;
    if (i==0) begin
      FA fa(.A(A[i]), .B(B[i]), .out(out[i]),
            .ci(ci), .co(c_out));
    end
    else begin
      FA fa(.A(A[i]), .B(B[i]), .out(out[i]),
            .ci(Add[i-1].c_out), .co(c_out));
    end
  end

endgenerate

assign co = Add[WIDTH-1].c_out;
endmodule

