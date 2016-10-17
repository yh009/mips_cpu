module id_reg(
input clk,
input[31:0] pcp4f,rd,
input stalld,clr,
output [31:0] instrD, pcp4D
);

reg [31:0] instr;
reg [31:0] pcp4;
assign instrD = instr;
assign pcp4D = pcp4;
initial begin
	//$monitor("%x,%x,%x,%x",rd,instrD,pcp4D,stalld,clr);
	instr = 0;
	pcp4 = 0;
end

always @(posedge clk) begin
	if(!stalld & !clr) begin
		instr <= rd;
		pcp4 <= pcp4f;
	end
	if(clr == 1)begin
		instr <= 0;
		pcp4 <= 0;
	end
end
endmodule