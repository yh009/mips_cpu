module mux(input [31:0] in1,
	   input [31:0]  in2,
	   input select,
	   output reg [31:0] out);
   always @(*)
     out = (!select)? in1 : in2;
endmodule // mux


// module muxtest();
//   reg [31:0]a;
//   reg [31:0]b;
//   reg select;
//   wire [31:0] out;
//   mux mux(a,b,select,out);
//   initial
//   begin
//     $monitor(a,b,select,out);
//     a = 4;
//     b = 3;
//     select = 0;
//   end
// endmodule

module mux_ini(input [31:0] in1,
	       input [31:0] 	 in2,
	       input 		 select,
	       output reg [31:0] out);
   initial begin
   		out <= 31'h400030;
   		//$monitor("PC: %x,%x,%x,%x",in1,in2,select,out,$time);
   end
   always @(*)
     out = (!select)? in1 : in2;
endmodule

module mux_5(input [4:0] in1,
	     input [4:0]      in2,
	     input 	      select,
	     output reg [4:0] out);
   always @(*)
     out = (!select)? in1 : in2;
endmodule // mux

module threemux5(input [4:0] in1,
    input [4:0] in2,
    input [4:0] in3,
    input [1:0] select,
    output reg [4:0] out);
   always @(*)
     case (select)
       0: out = in1;
       1: out = in2;
       2: out = in3;
     endcase // case (select)
endmodule // threemux

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
     endcase // case (select)
endmodule // threemux


