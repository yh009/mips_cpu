module wb_reg(
input clk,
input[31:0] rdm,aluoutm,
input regwritem,memtoregm,
input [4:0] writeregm,
input [31:0] pcplus4m,
input jumplinkm,
output reg regwritew,memtoregw,
output reg [31:0] rdw, aluoutw,
output reg [4:0] writeregw,
output reg [31:0] pcplus4w,
output reg jumplinkw
);
reg [31:0] aluout, rd;
reg regwrite,memtoreg;
reg [4:0]writereg;
reg [31:0] pcplus4;
reg jumplink;

initial begin
	aluout = 0;
	rd = 0;
	regwrite = 0;
	memtoreg = 0;
	writereg = 0;
	pcplus4 = 0;
	jumplink = 0;
end

//Assign:
// assign regwritew = regwrite;
// assign memtoregw = memtoreg;
// assign aluoutw = aluout;
// assign rdw = rd;
// assign writeregw = writereg;
// assign pcplus4w = pcplus4;
// assign jumplinkw = jumplink;

always @(posedge clk) begin
		 regwrite = regwritem;
		 memtoreg = memtoregm;
		 aluout = aluoutm;
		 rd = rdm;
		 writereg = writeregm;
		 pcplus4 = pcplus4m;
		 jumplink = jumplinkm;
	
end

always @(negedge clk) begin
		 regwritew = regwrite;
		 memtoregw= memtoreg;
		 aluoutw = aluout;
		 rdw = rd;
		 writeregw = writereg;
		 pcplus4w = pcplus4;
		 jumplinkw = jumplink;
	
end
endmodule