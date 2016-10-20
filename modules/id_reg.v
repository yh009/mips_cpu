module id_reg(
input clk,
input[31:0] pcp4f,rd,
input stalld,clr,
output reg [31:0] instr, pcp4
);

// assign instrD = instr;
// assign pcp4D = pcp4;
initial begin
	// $monitor("%x,%x,%x,%x",rd,instrD,pcp4D,stalld,clr);
	instr <= 0;
	pcp4 <= 0;
end

always @(posedge clk) begin
	//$display($time," id posedgewrite ");
	if(!stalld & !clr) begin
		instr <= rd;
		pcp4 <= pcp4f;
	end
	else begin
		if(stalld) begin
			instr <= instr;
			pcp4 <= pcp4;
		end
	end
	if(clr == 1)begin
		instr <= 0;
		pcp4 <= 0;
	end
end

endmodule