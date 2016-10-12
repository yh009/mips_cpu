module cpu;
   reg clk;
   always begin
      clk <= ~clk;
      #5;
   end
   wire[31:0] PCF;
   wire [31:0] instrF;
   wire [31:0] PC;
   wire        StallF;
   wire [31:0] PCPlus4F;
   wire [31:0]  PCBranchD;
   wire        BranchD;
   wire        EqualD1,EqualD2;
   wire        StallD;
   wire [31:0] instrD;
   wire [31:0] PCPlus4D;
   wire        MemtoRegE,RegWriteE,MemtoRegM,RegWriteM,RegWriteW,MemWriteM,MemtoRegW;
   wire [4:0]  RsD,RtD,RdD,RdE,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,WriteRegM;
   wire        ForwardAD,ForwardBD,FlushE;
   wire [1:0]  ForwardAE,ForwardBE;
   wire        RegDstD,Jump,MemRead,MemtoRegD,RegWriteD,ALUSrcD,MemWriteD,MemWriteE,ALUSrcE,RegDstE;
   wire [2:0]  ALUControlD,ALUControlE;
   wire [31:0] ALUOutE.ResultW,RD1_D,RD2_D,SignImmD,RD1_E,RD2_E,SignImmE,SrcAE,SrcBE,WriteDataE,WriteDataM,ReadDataM,ReadDataW,ALUOutW;
   
   assign RsD=instrD[25:21];
   assign RtD=instrD[20:16];
   assign RdD=instrD[15:11];
   
   
   inst_memory im(clk,PCF[31:2],instrF);//ADDR??
   if_reg if_reg(clk,PC,StallF,PCF);
   mux mux_if(PCPlus4F,PCBranchD,BranchD && (EqualD1==EqualD2),PC);
   add4 add4(PCF,PCPlus4F);
   id_reg id_reg(clk,PCPlus4F,instrF,StallD,BranchD && (EqualD1==EqualD2),instrD,PCPlus4D);
   hazard hazard(BranchD,MemtoRegE,RegWriteE,MemtoRegM,RegWriteM,RegWriteW,RsD,RtD,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,StallF,StallD,ForwardAD,ForwardBD,FlushE,ForwardAE,ForwardBE);
   control control(instrD,RegDstD,Jump,BranchD,MemRead,MemtoRegD,ALUControlD,RegWriteD,ALUSrcD,MemWriteD);
   registers registers(clk,instrD[25:21],instrD[20:16],WriteRegW,ResultW,RegWriteW,RD1_D,RD2_D);
   mux mux_id1(RD1_D,ALUOutM,ForwardAD,EqualD1);
   mux mux_id2(RD2_D,ALUOutM,ForwardBD,EqualD2);
   idmultipurpose adder(PCPlus4D,instrD[15:0],PCBranchD,SignImmD);
   ex_reg ex_reg(clk,RD1_D,RD2_D,SignImmD,FlushE,RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD,BranchD,ALUControlD,RsD,RtD,RdD,RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE,ALUControlE,RD1_E,RD2_E,SignImmE,RsE,RtE,RdE);
   mux mux_ex1(RtE,RdE,RegDstE,WriteRegE);
   ALU alu(SrcAE, SrcBE, ALUControlE, ALUOutE);
   threemux mux_ex2(RD1_E, ResultW, ALUOutM,ForwardAE,SrcAE);
   threemux mux_ex3(RD2_E, ResultW, ALUOutM,ForwardBE,WriteDataE);
   mux mux_ex4(WriteDataE,SignImmE,ALUSrcE,SrcBE);
   mem_reg mem_reg(clk, ALUOutE,WriteDataE,RegWriteE,MemtoRegE,MemWriteE,WriteRegE,RegWriteM,MemtoRegM,MemWriteM,ALUOutM,WriteDataM,WriteRegM);
   data_memory dm(clk, ALUOutM, WriteDataM, MemWriteM, MemRead, ReadDataM);
   wb_reg wb(clk, ReadDataM, ALUOutM, RegWriteM, MemtoRegM, WriteRegM, RegWriteW, MemtoRegW, ReadDataW, ALUOutW, WriteRegW);
   mux mux_wb(ReadDataW,ALUOutW,MemtoRegW,ResultW);

endmodule



   
   
   

   
	      
   
		  
	     
