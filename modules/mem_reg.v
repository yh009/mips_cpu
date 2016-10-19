module mem_reg(
input clk,
input[31:0] aluoute,writedatae,
input regwritee,memtorege,memwritee,
input [4:0] writerege,
input [31:0] pcplus4e,
input jumplinke,
output reg regwritem,memtoregm,memwritem,
output reg [31:0] aluoutm, writedatam,
output reg [4:0] writeregm,
output reg [31:0] pcplus4m,
output reg jumplinkm
);
reg [31:0] aluout, writedata;
reg regwrite,memtoreg,memwrite,jumplink;
reg [4:0]writereg;
reg [31:0] pcplus4;


initial begin
	aluout = 0;
	writereg = 0;
	regwrite = 0;
	memtoreg = 0;
	memwrite = 0;
	writereg = 0;
	pcplus4 = 0;
	jumplink = 0;
end

//Assign:
// assign regwritem = regwrite;
// assign memtoregm = memtoreg;
// assign memwritem = memwrite;
// assign aluoutm = aluout;
// assign writedatam = writedata;
// assign writeregm = writereg;
// assign pcplus4m = pcplus4;
// assign jumplinkm = jumplink;

always @(negedge clk) begin
		 regwrite = regwritee;
		 memtoreg = memtorege;
		 memwrite = memwritee;
		 aluout = aluoute;
		 writedata = writedatae;
		 writereg = writerege;
		pcplus4 = pcplus4e;
		jumplink = jumplinke;
end

always @(posedge clk) begin
		 regwritem = regwrite;
		 memtoregm = memtoreg;
		 memwritem = memwrite;
		 aluoutm = aluout;
		 writedatam = writedata;
		 writeregm = writereg;
		pcplus4m = pcplus4;
		jumplinkm = jumplink;
end
endmodule