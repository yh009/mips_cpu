module wb_reg(
input clk,
input[31:0] rdm,aluoutm,
input regwritee,memtorege,
input [4:0] writeregm,
output regwritew,memtoregw,
output [31:0] rdw, aluoutw,
output [4:0] writeregw
);
reg [31:0] aluout, writedata;
reg regwrite,memtoreg;
reg [4:0]writereg;

//Assign:
assign regwritew = regwrite;
assign memtoregw = memtoreg;
assign aluoutw = aluout;
assign writedataw = writedata;
assign writeregw = writereg;

always @(posedge clk) begin
		 regwrite = regwritem;
		 memtoreg = memtoregm;
		 aluout = aluoutm;
		 writedata = writedatam;
		 writereg = writeregm;
	
end
endmodule