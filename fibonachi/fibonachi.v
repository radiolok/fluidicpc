module fibonachi #(
parameter WIDTH=4
)(
input wire clk,
input wire rst,
output wire [WIDTH-1:0] out
);


reg [WIDTH-1:0] prev;
reg [WIDTH:0] next;

//rst logic on external signal or overflow
wire rst_add = rst | next[WIDTH];
assign out = next[WIDTH-1:0];

always @(posedge clk, posedge rst_add) begin
  if (rst_add) begin
    prev <= 0;
    next <= 1; 
 end
 else begin
   next <= next + prev;
   prev <= next;
 end

end



endmodule

