module adder_tb();

parameter WIDTH=4;
parameter TEST_NUM=WIDTH*WIDTH;
wire [WIDTH:0] out;
reg clk;
reg [WIDTH-1:0] A;
reg [WIDTH-1:0] B;

reg [$clog2(TEST_NUM):0] test;
reg [$clog2(TEST_NUM):0] correct;

adder #(.WIDTH(WIDTH)) Adder(.A(A), .B(B), .out(out));

initial begin 
  $dumpfile("adder.vcd");
  $dumpvars(0, adder_tb);
  clk = 0;
  test = 0;
  correct = 0;
  A = $urandom();
  B = $urandom();
  forever #1 clk = ~clk;
end


wire[WIDTH:0] RC = A + B;

always @(clk) begin
  if (clk) begin
    test <= test + 1;
    if (test >= TEST_NUM) begin
      $display("TESTS: %d/%d", correct, test);
      $finish();
    end
    if (out == RC) begin
      correct <= correct + 1;
    end
    else begin
      $display("%d: %d + %d: Got: %d, exp: %d", test, A, B, out, RC);
    end
  end
  else begin
      A <= $urandom();
      B <= $urandom();

  end
end

endmodule

