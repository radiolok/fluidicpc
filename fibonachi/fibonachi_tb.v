module fibonachi_tb();

parameter WIDTH=4;
parameter TEST_NUM=WIDTH*WIDTH;
wire [WIDTH-1:0] out;
reg clk;
reg rst;

reg [$clog2(TEST_NUM):0] test;

fibonachi #(.WIDTH(WIDTH)) Fibonachi(.clk(clk),.rst(rst),.out(out));

initial begin 
  $dumpfile("fibonachi.vcd");
  $dumpvars(0, fibonachi_tb);
  clk = 1;
  rst = 1;
  test = 0;
  #1 rst = 0;
  forever #1 clk = ~clk;
end

always @(posedge clk) begin
  test <= test + 1;
  if (test >= TEST_NUM) begin
    $finish();
  end
  $display("%d: %d", test, out);
end

endmodule


