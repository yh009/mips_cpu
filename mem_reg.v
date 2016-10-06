module mem_reg(
input clk,
input[31:0] aluoute,writedatae,
input regwritee,memtorege,memwritee,
input [4:0] writerege,
output regwritem,memtoregm,memwritem,
output [31:0] aluoutm, writedatam,
output [4:0] writeregm
);
reg [31:0] aluout, writedata;
reg regwrite,memtoreg,memwrite;
reg [4:0]writereg;

//Assign:
assign regwritem = regwrite;
assign memtoregm = memtoreg;
assign memwritem = memwrite;
assign aluoutm = aluout;
assign writedatam = writedata;
assign writeregm = writereg;

always @(posedge clk) begin
		 regwrite = regwritee;
		 memtoreg = memtorege;
		 memwrite = memwritee;
		 aluout = aluoute;
		 writedata = writedatae;
		 writereg = writerege;
	
end
endmodule