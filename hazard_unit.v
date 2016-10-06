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
output reg [1:0] ForwardAE,
output reg [1:0] ForwardBE
);

   reg 		 lwstall = 0;
   reg 		 branchstall = 0;
   reg 		 branchstall_1 = 0;
   reg 		 branchstall_2 = 0;
   
initial begin
	StallF = 0;
	StallD = 0;
	ForwardAD = 0;
	ForwardBD = 0;
	ForwardAE = 2'b00;
	ForwardBE = 2'b00;
	FlushE = 0;
end

always @(*)
  begin
  //Logic for stalls and flushes
  lwstall = (RtE==RsD || RtE==RtD) && MemtoRegE;
  branchstall_1 = (BranchD && RegWriteE && (WriteRegE == RsD || WriteRegE == RtD));
  branchstall_2 = (BranchD && MemtoRegM && (WriteRegM == RsD || WriteRegM == RtD));
  branchstall = branchstall_1 || branchstall_2; 
  if (lwstall || branchstall)
    begin
       StallF = 1;
       StallD = 1;
       FlushE = 1;
    end
   //Logic for ForwardAD and ForwardBD
   ForwardAD = (RsD != 0) && (RsD == WriteRegM) && RegWriteM;
   ForwardBD = (RtD != 0) && (RtD == WriteRegM) && RegWriteM;
   //Logic for Forward AE
   if ((RsE != 0) && (RsE == WriteRegM) && RegWriteM)
     ForwardAE = 2'b10;
   else if ((RsE != 0) && (RsE == WriteRegW) && RegWriteW)
     ForwardAE = 2'b01;
   else
     ForwardAE = 2'b00;
   //Logic for Forward BE
   if ((RtE != 0) && (RtE == WriteRegM) && RegWriteM)
     ForwardBE = 2'b10;
   else if ((RtE != 0) && (RtE == WriteRegW) && RegWriteW)
     ForwardBE = 2'b01;
   else
     ForwardBE = 2'b00;
  end // always @ (*)
endmodule // harzard
