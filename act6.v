//Name: Kenny Rader
//Date: 9-15-16
//Class: CSCI 320L
//Section: 8am

//Code modified from "mya3.v" found in the demo folder

`timescale 1ns/1ns
`include "mips.h"

///////////////////////////////////////////////////////////////////////////////////////
//PC MODULE////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module pc (input clk, input [31:0] nextPC, output [31:0] currPC);
   reg [31:0] temp;
   initial
   	temp = 31'h00400020;
   //Modeling delay 
   assign #5 currPC = temp;
   //Modeling logic
   always @(posedge clk) 
     begin
	temp = nextPC;
     end
   
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//PC+4 MODULE//////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module add4(input [31:0] inval, output [31:0] outval);
   assign #100 outval = inval + 4;
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//INSTRUCTION MEMORY MODULE////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module inst_memory(input [29:0] read_addr, output [31:0] memout);
   reg [31:0] temp;
   reg [31:0] mymem [32'h00100000 : 32'h00100100];
   //Modeling delay
   assign #250 memout = temp;
   initial
     begin
	$readmemh("add_test.v", mymem);
     end
   always @(*) 
     begin
	temp = mymem[read_addr];
	if (memout == 0)
	  begin
	     $strobe("Found null op at addr %08x.", read_addr);
	     $finish();
	  end
     end
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//ALU CONTROL MODULE///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module control(input [31:0] instruction,
	       output reg RegDst,
	       output reg Jump,
	       output reg Branch,
	       output reg MemRead,
	       output reg MemToReg,
	       output reg [2:0] ALUop,
	       output reg RegWrite,
	       output reg ALUSrc,
	       output reg MemWrite);
   wire [5:0] opcode = instruction [31:26];
   wire [5:0] funct = instruction [5:0];
   initial 
     begin
      RegDst = 1'b0;
      Jump = 1'b0;
      Branch = 1'b0;
      MemRead = 1'b0;
      MemToReg = 1'b0;
      ALUop = 3'b000;
      RegWrite = 1'b0;
      ALUSrc = 1'b0;
      MemWrite = 1'b0;
     end
   always @(instruction)
     case (opcode)
       `ADDI: begin
	 $display("%b: ADDI", opcode);
	 #50 ALUop <= 3'b010;
         #50 RegWrite <= 1;
         #50 ALUSrc <= 1;
       end
       `ORI: begin
	 $display("%b: ORI", opcode);
	 #50 ALUop <= 3'b001;
         #50 RegWrite <= 1;
         #50 ALUSrc <= 1;
       end
       `LW: begin
	 $display("%b: LW", opcode);
	 #50 MemRead <= 1;
         #50 MemToReg <= 1;
	 #50 ALUop <= 3'b010;
         #50 RegWrite <= 1;
         #50 ALUSrc <= 1;
       end  
       `SW: begin
	 $display("%b: SW", opcode);
	 #50 ALUop <= 3'b010;
         #50 ALUSrc <= 1;
         #50 MemWrite <= 1;
       end	  
       `BEQ: begin
	 $display("%b: BEQ", opcode);
	 #50 Branch <= 1;
	 #50 ALUop <= 3'b110;
       end	  
       `BNE: begin
	 $display("%b: BNE", opcode);
	 #50 Branch <= 1;
	 #50 ALUop <= 3'b110;
       end  
       `J: begin
	 $display("%b: J", opcode);
	 #50 Jump <= 1;
       end
       `JAL: begin
	 $display("%b: JAL", opcode);
	 #50 Jump <= 1;
       end
       `ADDIU: begin
	 $display("%b: ADDIU", opcode);
	 #50 ALUop <= 3'b010;
	 #50 RegWrite <= 1;
	 #50 ALUSrc <= 1;
       end
       `SLTIU: begin
	 $display("%b: SLTIU", opcode);
	 #50 ALUop <= 3'b111;
	 #50 RegWrite <= 1;
	 #50 ALUSrc <= 1;
       end
       `SPECIAL: begin
	  $display("%b: SPECIAL", opcode);
	  case (funct)
	    `ADD: begin
	       $display("%b: ADD", funct);
	       #50 RegDst <= 1;
	       #50 ALUop <= 3'b010;
	       #50 RegWrite <= 1;
	    end
	    `SUB: begin
	       $display("%b: SUB", funct);
               #50 RegDst <= 1;
               #50 ALUop <= 3'b110;
               #50 RegWrite <= 1;
	    end
	    `AND: begin
	       $display("%b: AND", funct);
               #50 RegDst <= 1;
               #50 ALUop <= 3'b000;
               #50 RegWrite <= 1;
	    end
	    `OR: begin
	       $display("%b: OR", funct);
               #50 RegDst <= 1;
               #50 ALUop <= 3'b001;
               #50 RegWrite <= 1;
	    end
	    `SLT: begin
	       $display("%b: SLT", funct);
               #50 RegDst <= 1;
               #50 ALUop <= 3'b111;
               #50 RegWrite <= 1;
	    end
	    `JR: begin
	       $display("funct: %b: JR", funct);
	       #50 Jump <= 1;
	    end
	    `SYSCALL:
	       $display("funct: %b: SYSCALL", funct);
	    default:
	       $display("funct: %b: That's not a supported funct!", funct);
	  endcase
       end
       default:
	 $display("%b: That's not a supported instruction!", opcode);
     endcase
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//REGISTER MODULE//////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module registers(input [4:0] read_reg_1,
		 input [4:0]   read_reg_2,
		 input [4:0]   write_reg,
		 input [31:0]  write_data,
		 input reg_write,
		 output [31:0] read_data_1,
		 output [31:0] read_data_2);
   reg [31:0] 			 register_file [31:0];
   //Modeling delay
   assign #200 read_data_1 = register_file[read_reg_1];
   assign #200 read_data_2 = register_file[read_reg_1];
   assign #200 write_data = register_file[write_reg];
   always @(*) 
	begin
	   if (reg_write)
	     register_file[write_reg] = write_data;
	end
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//ALU MODULE///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module ALU(input [31:0] read_data_1,
	   input [31:0]  read_data_2_or_immediate,
	   input [2:0] 	 ALU_control,
	   output reg	 zero,
	   output [31:0] ALU_result);
  reg [31:0] temp;
  assign #120 ALU_result = temp;
  initial
    begin
       case (ALU_control)
	 0: temp = read_data_1 & read_data_2_or_immediate;
	 1: temp = read_data_1 | read_data_2_or_immediate;
	 2: temp = read_data_1 + read_data_2_or_immediate;
	 6: temp = read_data_1 - read_data_2_or_immediate;
	 7: begin 
	    if (read_data_1 < read_data_2_or_immediate)
	      temp = read_data_1;
	    else
	      temp = read_data_2_or_immediate;
         end
	 default: $display("That's not a supported ALUop!");
       endcase
       if (ALU_result == 0)
	 zero = 1;
       else
	 zero = 0;
    end
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//DATA MEMORY MODULE///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module data_memory(input [31:0] address, 
		   input [31:0]  write_data,
		   input 	 mem_write,
		   input 	 mem_read,
		   output [31:0] read_data);
   reg [31:0] 			 temp;
   reg [31:0] mymem [32'h00100000 : 32'h00100100];
   assign #350 read_data = temp;
   initial
     begin
	$readmemh("add_test.v", mymem);
     end
   always @(*) 
	begin
	   if (mem_read)
	     temp = mymem[address];
	   if (mem_write)
	     mymem[address] = write_data;
	   if (read_data == 0)
	     begin
		$strobe("Found null op at addr %08x.", address);
		$finish();
	     end
	end
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//MULTIPLEXOR MODULE///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

module mux(input [31:0] in1,
	   input [31:0]  in2,
	   input select,
	   output [31:0] out);
   assign #30 out = (select)? in1 : in2;
endmodule

///////////////////////////////////////////////////////////////////////////////////////
//TEST MODULE///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

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
	   (ALUSrc) ? {{16{instruction[15]}}, instruction[15:0]} : reg_out_2, 
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

