module if_reg(
input clk,
input[31:0] pcadd,
input stallf,
output[31:0] pcfetch
);

reg [31:0] pcreg;

assign pcfetch = pcreg;

always @(posedge clk) begin
	if(stallf != 1) begin
		pcreg = pcadd;
	end
end
endmodule

module id_reg(
input clk,
input[31:0] pcp4,rd,
input stalld,clr,
output [31:0] instrD, pcp4D
);

reg [31:0] instr;
reg [31:0] pcp4;
assign instrD = instr;
assign pcp4D = pcp4;

always @(posedge clk) begin
	if(stalld != 1) begin
		instr <= rd;
		pcp4 <= pcp4;
	end
	if(clr == 1)begin
		instr <= 0;
		pcp4 <= 0;
	end
end
endmodule
