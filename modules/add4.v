module add4(input [31:0] inval, output reg [31:0] outval);
   always @(*)
     outval = inval + 4;
endmodule

module idmultipurpose(input [31:0] inval,
		      input [15:0] 	inval2, 
		      output reg [31:0] outval, 
		      output reg [31:0] signextended);
   
   reg[31:0] extended;
   initial begin
     //$monitor("%b,%b,%b,%b",inval,inval2,outval,signextended);
   end
   always @(*)
   begin
   		extended = {{16{inval2[15]}}, inval2[15:0]};
   		signextended = extended;
   		extended = extended << 2;
   		outval = extended + inval;
   end
endmodule
