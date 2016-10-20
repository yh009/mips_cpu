module wb_reg(
input clk,
input[31:0] rdm,aluoutm,
input regwritem,memtoregm,
input [4:0] writeregm,
input [31:0] pcplus4m,
input jumplinkm,
output reg regwrite,memtoreg,
output reg [31:0] rd, aluout,
output reg [4:0] writereg,
output reg [31:0] pcplus4,
output reg jumplink
);

initial begin
    //$monitor($time,"wb_reg monitor: aluoutM <= %x aluoutw <= %x", aluoutm,aluout);

	aluout <= 0;
	rd <= 0;
	regwrite <= 0;
	memtoreg <= 0;
	writereg <= 0;
	pcplus4 <= 0;
	jumplink <= 0;
end

//Assign:
// assign regwritew <= regwrite;
// assign memtoregw <= memtoreg;
// assign aluoutw <= aluout;
// assign rdw <= rd;
// assign writeregw <= writereg;
// assign pcplus4w <= pcplus4;
// assign jumplinkw <= jumplink;

always @(posedge clk) begin
		//$display($time,"posedgewrite wbreg aluoutm <= %x aluout <= %x",aluoutm,aluout);
		 regwrite <= regwritem;
		 memtoreg <= memtoregm;
		 aluout <= aluoutm;
		 rd <= rdm;
		 writereg <= writeregm;
		 pcplus4 <= pcplus4m;
		 jumplink <= jumplinkm;
	
end

endmodule
