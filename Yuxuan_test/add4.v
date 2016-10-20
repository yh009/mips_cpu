module add4(input [31:0] inval, output reg [31:0] outval);
   always @(*)
     outval = inval + 4;
endmodule

module SignImmD(input [31:0] instr,output reg [31:0] SignImmD, output reg [31:0]SignUpperImmD);
  wire [15:0] temp = instr[15:0];
  always @(*) begin
    SignImmD <= {{16{instr[15]}}, temp[15:0]};
    SignUpperImmD <= {temp[15:0],{16{1'b0}}};
  end
endmodule

module idmultipurpose(input [15:0] inst_low_16,
		      input [31:0] PCPlus4D, 
		      output reg [31:0] PCBranchD);
   reg [31:0] temp;
   reg [31:0] 				left_shift;
   always @(*)
      begin
	     temp <= {{16{inst_low_16[15]}}, inst_low_16[15:0]};
   	   left_shift <= temp << 2;
	     PCBranchD <= left_shift + PCPlus4D;
      end
endmodule


