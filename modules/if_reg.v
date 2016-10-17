module if_reg(
input clk,
input[31:0] pcadd,
input stallf,
output[31:0] pcfetch
);

reg [31:0] pcreg;

initial begin
     pcreg = 31'h400030;
     // $monitor("%x,%x",pcadd,pcfetch);
end

assign pcfetch = pcreg;

always @(posedge clk) begin
	if(stallf != 1) begin
		pcreg = pcadd;
	end
end
endmodule



