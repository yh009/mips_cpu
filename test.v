module test;
   reg clk;
   wire [31:0] curr_addr = 31'h00400020;
   wire [31:0] pc_plus4 = 31'h00400024;
   wire [31:0] next_addr = 31'h00400024;
   wire [31:0] instruction;
   wire        regdst = 0;
   wire        jump = 0;
   wire        brnch = 0;
   wire        memread = 0;
   wire        memtoreg = 0;
   wire [2:0]  aluop = 0;
   wire        regwrite = 0;
   wire        alusrc = 0;
   wire        memwrite = 0;
   wire [31:0] alu_out = 0;
   wire [31:0] reg_out_1 = 0;
   wire [31:0] reg_out_2 = 0;
   wire [31:0] data_out = 0;
   wire [31:0] alu_out_2 = 0;
   wire        discard = 0;
   wire        zero = 0;        
   
   pc thePC(clk,
	    next_addr,
	    curr_addr);
   add4 theADDR(curr_addr, 
		pc_plus4);
   inst_memory theMEM(curr_addr[31:2], 
		      instruction);
   control cm(instruction,
	      regdst,
	      jump,
	      brnch,
	      memread,
	      memtoreg,
	      aluop,
	      regwrite,
	      alusrc,
	      memwrite);
   mux jump_mux({pc_plus4[31:28], instruction[25:0], 2'b00}, 
	      (brnch && zero) ? alu_out_2 : pc_plus4,
	      jump,
	      next_addr);
   data_memory dm(alu_out, 
		  reg_out_2, 
		  memwrite, 
		  memread, 
		  data_out);
   registers regis(instruction[25:21], 
		   instruction[20:16], 
		   (regdst) ? instruction[15:11] : instruction[20:16], 
		   (memtoreg) ? data_out : aluout,
		   regwrite, 
		   reg_out_1, 
		   reg_out_2);
   ALU alu(reg_out_1, 
	   (alusrc) ? {{16{instruction[15]}}, instruction[15:0]} : reg_out_2, 
	   aluop, 
	   zero, 
	   alu_out);
   ALU alu_2(pc_plus4, 
	   {{16{instruction[15]}}, instruction[15:0]} << 2,
	   3'b010, 
	   discard, 
	   alu_out_2);
	  
   initial begin
	clk = 0;
   end 
   initial begin
      $monitor($time, " in %m, currPC = %08x, nextPC = %08x, inst = %08x.", 
			curr_addr, next_addr, instruction);
      
      #20000 $finish; 
   end
   always
     #250 clk = ~clk;
endmodule