//Name:
//Class

module hazard (
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
  else
	begin
	   StallF = 0;
       StallD = 0;
       FlushE = 0;
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



// module test();
// //inputs
// reg BranchD;
// reg MemtoRegE;
// reg RegWriteE;
// reg MemtoRegM;
// reg RegWriteM;
// reg RegWriteW;
// reg [4:0] RsD;
// reg [4:0] RtD;
// reg [4:0] RsE;
// reg [4:0] RtE;
// reg [4:0] WriteRegE;
// reg [4:0] WriteRegM;
// reg [4:0] WriteRegW;

// //outputs
// wire StallF;
// wire StallD;
// wire ForwardAD;
// wire ForwardBD;
// wire FlushE;
// wire [1:0] ForwardAE;
// wire [1:0] ForwardBE;

// hazard my_hazard(
// BranchD,
// MemtoRegE,
// RegWriteE,
// MemtoRegM,
// RegWriteM,
// RegWriteW,
// RsD,
// RtD,
// RsE,
// RtE,
// WriteRegE,
// WriteRegM,
// WriteRegW,
// StallF,
// StallD,
// ForwardAD,
// ForwardBD,
// FlushE,
// ForwardAE,
// ForwardBE
// );

// initial begin
// 	//Stalls and Flush
// 	#10 RtE=5'b00100;RsD=5'b00100;MemtoRegE=1;
// 	#10 RtE=0;RsD=0;MemtoRegE=0;
// 	#10 BranchD=1;WriteRegE=5'b10000;RsD=5'b10000;RegWriteE=1;
// 	#10 BranchD=0;WriteRegE=0;RsD=0;RegWriteE=0;
// 	#10 BranchD=1;WriteRegM=5'b10000;RtD=5'b10000;MemtoRegM=1;
// 	#10 BranchD=0;WriteRegM=0;RtD=0;MemtoRegM=0;
// 	//ForwardAD & BD
// 	#10 RsD=5'b1;WriteRegM=5'b1;RegWriteM=1;
// 	#10 RsD=0;WriteRegM=0;RegWriteM=0;
// 	#10 RtD=5'b00010;WriteRegM=5'b00010;RegWriteM=1;
// 	#10 RtD=0;WriteRegM=0;RegWriteM=0;
// 	//ForwardAE
// 	#10 RsE=5'b00101;
// 	#10 WriteRegM=5'b00101;
// 	#10 RegWriteM=1;
// 	#10 RegWriteM=0;
// 	#10 RegWriteW=1;WriteRegW=5'b00101;
// 	#10 RegWriteW=0;WriteRegM=0;RsE=0;WriteRegW=0;
// 	//ForwardBE
// 	#10 RtE=5'b00100;
// 	#10 WriteRegM=5'b00100;
// 	#10 RegWriteM=1;
// 	#10 RegWriteM=0;
// 	#10 RegWriteW=1;WriteRegW=5'b00100;
// 	#10 RtE=0;WriteRegM=0;RegWriteW=0;WriteRegW=0;


// end


// initial begin
// 	$monitor($time, " StallF=%b, StallD=%b, ForwardAD=%b,ForwardBD=%b,FlushE=%b,ForwardAE=%b,ForwardBE=%b",StallF,StallD,ForwardAD,ForwardBD,FlushE,ForwardAE,ForwardBE);
// 	#5000 $finish; 
// end

// endmodule


