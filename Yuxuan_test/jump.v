module jump(
	input [31:0]instr,
	input [31:0]PCPlus4,
	input [31:0]PCCon,
	input jump,
	output [31:0] PC
	);
	reg [3:0] PCHigh;
	reg [27:0] PCLow;
	reg [31:0] PCNew;
	mux mux(PCCon,PCNew,jump,PC);
	always @(*) begin
		//$monitor("%x,%x,%x",PCHigh, PCLow, PCNew);
		PCHigh = PCPlus4[31:28];
		PCLow = instr[25:0];
		PCLow = PCLow << 2;
		PCNew = {PCHigh,PCLow};
	end
endmodule

module jumptest();
	reg [31:0] instr = 31'h0c100008;
	reg [31:0] PCPlus4 = 31'h040006c;
	reg [31:0] PCCon = 31'h040006c;
	wire [31:0] PC;
	reg jump = 1;
	jump j(instr,PCPlus4,PCCon,jump,PC);
	initial begin
		//$monitor(PC);
	end
endmodule