module mux(input [31:0] in1,
	   input [31:0]  in2,
	   input select,
	   output reg [31:0] out);
   always @(select)
     out = (select)? in1 : in2;
endmodule