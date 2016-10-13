module mux(input [31:0] in1,
	   input [31:0]  in2,
	   input select,
	   output reg [31:0] out);
   always @(select)
     out = (select)? in1 : in2;
endmodule // mux

module mux_5(input [4:0] in1,
	   input [4:0]  in2,
	   input select,
	   output reg [4:0] out);
   always @(select)
     out = (select)? in1 : in2;
endmodule // mux

module threemux(input [31:0] in1,
		input [31:0] in2,
		input [31:0] in3,
		input [1:0] select,
		output reg [31:0] out);
   always @(select)
     case (select)
       0: out = in1;
       1: out = in2;
       2: out = in3;
       default: $display("Error in threemux");
     endcase // case (select)
endmodule // threemux


