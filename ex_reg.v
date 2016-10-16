module ex_reg(
input clk,
input[31:0] rd1d,rd2d,signimmd,
input flushe,regwrited,memtoregd,memwrited,alusrcd,regdstd,branchd,
input [2:0] alucontrold,
input [4:0] rsd,rtd,rdd,
output regwritee,memtorege,memwritee,alusrce,regdste,
output [2:0] alucontrole,
output [31:0] rd1e, rd2e, signimme,
output [4:0] rse, rte, rde
);
reg [31:0] rd1, rd2, signimm;
reg regwrite,memtoreg,memwrite,alusrc,regdst;
reg [2:0] alucontrol;
reg [4:0] rs, rt, rd;

initial begin
	rd1 = 0;
	rd2 = 0;
	signimm = 0;
	regwrite = 0;
	memtoreg = 0;
	memwrite = 0;
	alusrc = 0;
	regdst = 0;
	alucontrol = 0;
	rs = 0;
	rt = 0;
	rd = 0;
end
//Assign:
assign regwritee = regwrite;
assign memtorege = memtoreg;
assign memwritee = memwrite;
assign alusrce = alusrc;
assign regdste = regdst;
assign alucontrole = alucontrol;
assign rd1e = rd1;
assign rd2e = rd2;
assign signimme = signimm;
assign rse = rs;
assign rte = rt;
assign rde = rd;

always @(posedge clk) begin
	if(!flushe) begin
		 regwrite = regwrited;
		 memtoreg = memtoregd;
		 memwrite = memwrited;
		 alusrc = alusrcd;
		 regdst = regdstd;
		 alucontrol = alucontrold;
		 rd1 = rd1d;
		 rd2 = rd2d;
		 signimm = signimmd;
		 rs = rsd;
		 rt = rtd;
		 rd = rdd;
	end
	else begin
		regwrite = 0;
		memtoreg = 0;
		memwrite = 0;
		alusrc = 0;
		regdst = 0;
		alucontrol = 0;
		rd1 = 0;
		rd2 = 0;
		signimm = 0;
		rs = 0;
		rt = 0;
		rd = 0;

	end
end
endmodule