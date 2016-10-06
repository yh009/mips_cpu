//Name:
//Class

module harzard (
input BranchD,
input MemtoRegE,
input RegWriteE,
input MemtoRegM,
input RegWriteM,
input RegWriteW,
input [4:0] RsD,
input [4:0] RtD,
input [4:0] RsE,
input [4:0] RtE,
input [4:0] WriteRegE,
input [4:0] WriteRegM,
input [4:0] WriteRegW,
output reg StallF,
output reg StallD,
output reg ForwardAD,
output reg ForwardBD,
output reg FlushE,
output reg ForwardAE,
output reg ForwardBE
);


initial begin
	StallF=0;
	StallD=0;
	ForwardAD=0;
	ForwardBD=0;
	ForwardAE=0;
	FOrwaedBE=0;
	FlushE=0;
end

always @(*)
	if ((RtE==RsD || RtE==RtD) && MemtoRegE) begin
		StallF=1;
		StallD=1;
	end

	







		
