
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
    wire c_in;
    wire c_out;
    if (i==0) begin
      assign c_in = ci;
    end
    else begin
      assign c_in = Add[i-1].c_out;
    end
    FA fa(.A(A[i]),
          .B(B[i]),
          .out(out[i]),
          .ci(c_in),
          .co(c_out));
  end

endgenerate

endmodule

