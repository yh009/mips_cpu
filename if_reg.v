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



