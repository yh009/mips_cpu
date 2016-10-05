module add4(input [31:0] inval, output reg [31:0] outval);
   always @(inval)
     outval = inval + 4;
endmodule