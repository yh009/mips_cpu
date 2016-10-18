module wb_reg(
input clk,
input[31:0] rdm,aluoutm,
input regwritem,memtoregm,
input [4:0] writeregm,
input [31:0] pcplus4m,
input jumplinkm,
output regwritew,memtoregw,
output [31:0] rdw, aluoutw,
output [4:0] writeregw,
output [31:0] pcplus4w,
output jumplinkw
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
assign regwritew = regwrite;
assign memtoregw = memtoreg;
assign aluoutw = aluout;
assign rdw = rd;
assign writeregw = writereg;
assign pcplus4w = pcplus4;
assign jumplinkw = jumplink;

always @(posedge clk) begin
		 regwrite = regwritem;
		 memtoreg = memtoregm;
		 aluout = aluoutm;
		 rd = rdm;
		 writereg = writeregm;
		 pcplus4 = pcplus4m;
		 jumplink = jumplinkm;
	
end
endmodule