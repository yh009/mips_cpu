module mux(input [31:0] in1,
	   input [31:0]  in2,
	   input select,
	   output reg [31:0] out);
   always @(*)
     out = (!select)? in1 : in2;
endmodule // mux

module mux_ini(input [31:0] in1,
	       input [31:0] 	 in2,
	       input 		 select,
	       output reg [31:0] out);
   initial begin
      out <= 32'h10008;
   end
   always @(*)
     out = (!select)? in1 : in2;
endmodule

module mux_5(input [4:0] in1,
	     input [4:0]      in2,
	     input 	      select,
	     output reg [4:0] out);
   always @(*)
     out = (select)? in1 : in2;
endmodule

module threemux(input [31:0] in1,
		input [31:0] in2,
		input [31:0] in3,
		input [1:0] select,
		output reg [31:0] out);
   always @(*)
     case (select)
       0: out = in1;
       1: out = in2;
       2: out = in3;
       default: $display("Error in threemux");
     endcase // case (select)
endmodule // threemux


