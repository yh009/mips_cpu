module add4(input [31:0] inval, output reg [31:0] outval);
   always @(*)
     outval = inval + 4;
endmodule

module idmultipurpose(input [15:0] inst_low_16,
		      input [31:0] PCPlus4D, 
		      output reg [31:0] SignImmD, 
		      output reg [31:0] PCBranchD);
   reg [31:0] 				extended;
   reg [31:0] 				left_shift;
   always @(*)
      begin
	 extended = {{16{inst_low_16[15]}}, inst_low_16[15:0]};
   	 left_shift = extended << 2;
   	 SignImmD = extended;
	 PCBranchD = left_shift + PCPlus4D;
      end
endmodule
