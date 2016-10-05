module pc (input clk, input [31:0] nextPC, output reg [31:0] currPC);
   always @(posedge clk)
     currPC = nextPC;
endmodule
