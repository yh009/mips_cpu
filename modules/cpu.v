`timescale 1ns/1ns
module cpu(input clk);
   //Wire/Reg Declarations
   ///////////////
   //Fetch Stage//
   ///////////////
   wire [31:0] instrF;
   wire [31:0] 	PCF;
   wire [31:0] 	PC;
   wire [31:0] PCPlus4F;
   wire        StallF;
   ////////////////
   //Decode Stage//
   ////////////////
   wire [31:0] EqualD1;
   wire [31:0] EqualD2;
   wire [31:0] instrD;
   wire [31:0] PCBranchD;
   wire [31:0] PCPlus4D;
   wire [31:0] RD1_D;
   wire [31:0] RD2_D;
   wire [31:0] SignImmD;
   wire [31:0] Std_Out;
   wire [31:0] Std_Out_Address;
   wire [31:0] Syscall_Info;
   wire [4:0]  RdD = instrD[15:11];
   wire [4:0]  RsD = instrD[25:21];
   wire [4:0]  RtD = instrD[20:16];
   wire [2:0]  ALUControlD;
   wire        ALUSrcD;
   wire        BranchD;
   wire        ForwardAD;
   wire        ForwardBD;
   wire        Jump;
   wire        MemRead;
   wire        MemtoRegD;
   wire        MemWriteD;
   wire        StallD;
   wire        RegDstD;
   wire        RegWriteD;
   /////////////////
   //Execute Stage//
   /////////////////
   wire [31:0] ALUOutE;
   wire [31:0] RD1_E;
   wire [31:0] RD2_E;
   wire [31:0] SignImmE;
   wire [31:0] SrcAE;
   wire [31:0] SrcBE;
   wire [31:0] WriteDataE;
   wire [4:0]  RdE;
   wire [4:0]  RsE;
   wire [4:0]  RtE;
   wire [4:0]  WriteRegE;
   wire [2:0]  ALUControlE;
   wire [1:0]  ForwardAE;
   wire [1:0]  ForwardBE;
   wire        ALUSrcE;
   wire        FlushE;
   wire        MemtoRegE;
   wire        MemWriteE;
   wire        RegDstE;
   wire        RegWriteE;
   ////////////////
   //Memory Stage//
   ////////////////
   wire [31:0] ALUOutM;
   wire [31:0] ReadDataM;
   wire [31:0] WriteDataM;
   wire [4:0]  WriteRegM;
   wire        MemtoRegM;
   wire        MemWriteM;
   wire        RegWriteM;
   ///////////////////
   //WriteBack Stage//
   ///////////////////
   wire [31:0] ALUOutW;
   wire [31:0] ReadDataW;
   wire [31:0] ResultW;
   wire [4:0]  WriteRegW;
   wire MemtoRegW;

  

   initial begin
   	$monitor($time,"instrD= %x, instrF = %x, RD1_D = %x, RD2_D = %x",instrD,instrF,RD1_D,RD2_D);
   	// $monitor("%x,resultw = %x,%x",
		  //      WriteRegW,
		  //      ResultW,
		  //      RegWriteW,
    //          );
   end

   //Module Instantiations
   ///////////////
   //Fetch Stage//
   ///////////////
   mux_ini mux_if(PCPlus4F,
	      PCBranchD,
	      BranchD && (EqualD1==EqualD2),
	      PC);
   if_reg if_reg(clk,
		 PC,
		 StallF,
		 PCF);
   inst_memory im(
		  PCF[31:2],
		  instrF);
   add4 add4(PCF,
	     PCPlus4F);
   ////////////////
   //Decode Stage//
   ////////////////
   id_reg id_reg(clk,
		 PCPlus4F,
		 instrF,
		 StallD,
		 BranchD && (EqualD1==EqualD2),
		 instrD,
		 PCPlus4D);
   control control(instrD,
		   Syscall_Info,
		   Std_Out,
		   RegDstD,
		   Jump,
		   BranchD,
		   MemRead,
		   MemtoRegD,
		   ALUControlD,
		   RegWriteD,
		   ALUSrcD,
		   MemWriteD);
   registers registers(clk,
		       instrD[25:21],
		       instrD[20:16],
		       WriteRegW,
		       ResultW,
		       RegWriteW,
		       RD1_D,
		       RD2_D,
		       Syscall_Info,
		       Std_Out_Address);
   mux mux_id1(RD1_D,
	       ALUOutM,
	       ForwardAD,
	       EqualD1);
   mux mux_id2(RD2_D,
	       ALUOutM,
	       ForwardBD,
	       EqualD2);
   idmultipurpose multi(instrD[15:0],
			PCPlus4D,
			SignImmD,
			PCBranchD);
   /////////////////
   //Execute Stage//
   /////////////////
   ex_reg ex_reg(clk,
		 RD1_D,
		 RD2_D,
		 SignImmD,
		 FlushE,
		 RegWriteD,
		 MemtoRegD,
		 MemWriteD,
		 ALUSrcD,
		 RegDstD,
		 BranchD,
		 ALUControlD,
		 RsD,
		 RtD,
		 RdD,
		 RegWriteE,
		 MemtoRegE,
		 MemWriteE,
		 ALUSrcE,
		 RegDstE,
		 ALUControlE,
		 RD1_E,
		 RD2_E,
		 SignImmE,
		 RsE,
		 RtE,
		 RdE);
   mux_5 mux_ex1(RtE,
	       RdE,
	       RegDstE,
	       WriteRegE);
   threemux mux_ex2(RD1_E,
		    ResultW,
		    ALUOutM,
		    ForwardAE,
		    SrcAE);
   threemux mux_ex3(RD2_E,
		    ResultW,
		    ALUOutM,
		    ForwardBE,
		    WriteDataE);
   mux mux_ex4(WriteDataE,
	       SignImmE,
	       ALUSrcE,
	       SrcBE);
   ALU alu(SrcAE,
	   SrcBE,
	   ALUControlE,
	   ALUOutE);
   ////////////////
   //Memory Stage//
   ////////////////
   mem_reg mem_reg(clk,
		   ALUOutE,
		   WriteDataE,
		   RegWriteE,
		   MemtoRegE,
		   MemWriteE,
		   WriteRegE,
		   RegWriteM,
		   MemtoRegM,
		   MemWriteM,
		   ALUOutM,
		   WriteDataM,
		   WriteRegM);

   data_memory dm(clk,
		  ALUOutM,
		  WriteDataM,
		  MemWriteM,
        MemRead,
        Std_Out_Address,
		  ReadDataM,
        Std_Out);
   ///////////////////
   //WriteBack Stage//
   ///////////////////
   wb_reg wb(clk,
	     ReadDataM,
	     ALUOutM,
	     RegWriteM,
	     MemtoRegM,
	     WriteRegM,
	     RegWriteW,
	     MemtoRegW,
	     ReadDataW,
	     ALUOutW,
	     WriteRegW);
   mux mux_wb(ReadDataW,
	      ALUOutW,
	      MemtoRegW,
	      ResultW);
   //////////
   //Hazard//
   //////////
   hazard hazard(BranchD,
		 MemtoRegE,
		 RegWriteE,
		 MemtoRegM,
		 RegWriteM,
		 RegWriteW,
		 RsD,
		 RtD,
		 RsE,
		 RtE,
		 WriteRegE,
		 WriteRegM,
		 WriteRegW,
		 StallF,
		 StallD,
		 ForwardAD,
		 ForwardBD,
		 FlushE,
		 ForwardAE,
		 ForwardBE);
endmodule



   
   
   

   
	      
   
		  
	     
