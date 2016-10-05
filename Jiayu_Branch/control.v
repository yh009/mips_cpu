`include "mips.h"

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
	 ALUop <= 3'b010;
         RegWrite <= 1;
         ALUSrc <= 1;
       end
       `ORI: begin
	 $display("%b: ORI", opcode);
	 ALUop <= 3'b001;
         RegWrite <= 1;
         ALUSrc <= 1;
       end
       `LW: begin
	 $display("%b: LW", opcode);
	 MemRead <= 1;
         MemToReg <= 1;
	 ALUop <= 3'b010;
         RegWrite <= 1;
         ALUSrc <= 1;
       end  
       `SW: begin
	 $display("%b: SW", opcode);
	 ALUop <= 3'b010;
         ALUSrc <= 1;
         MemWrite <= 1;
       end	  
       `BEQ: begin
	 $display("%b: BEQ", opcode);
	 Branch <= 1;
	 ALUop <= 3'b110;
       end	  
       `BNE: begin
	 $display("%b: BNE", opcode);
	 Branch <= 1;
	 ALUop <= 3'b110;
       end  
       `J: begin
	 $display("%b: J", opcode);
	 Jump <= 1;
       end
       `JAL: begin
	 $display("%b: JAL", opcode);
	 Jump <= 1;
       end
       `ADDIU: begin
	 $display("%b: ADDIU", opcode);
	 ALUop <= 3'b010;
	 RegWrite <= 1;
	 ALUSrc <= 1;
       end
       `SLTIU: begin
	 $display("%b: SLTIU", opcode);
	 ALUop <= 3'b111;
	 RegWrite <= 1;
	 ALUSrc <= 1;
       end
       `SPECIAL: begin
	  $display("%b: SPECIAL", opcode);
	  case (funct)
	    `ADD: begin
	       $display("%b: ADD", funct);
	       RegDst <= 1;
	       ALUop <= 3'b010;
	       RegWrite <= 1;
	    end
	    `SUB: begin
	       $display("%b: SUB", funct);
               RegDst <= 1;
               ALUop <= 3'b110;
               RegWrite <= 1;
	    end
	    `AND: begin
	       $display("%b: AND", funct);
               RegDst <= 1;
               ALUop <= 3'b000;
               RegWrite <= 1;
	    end
	    `OR: begin
	       $display("%b: OR", funct);
               RegDst <= 1;
               ALUop <= 3'b001;
               RegWrite <= 1;
	    end
	    `SLT: begin
	       $display("%b: SLT", funct);
               RegDst <= 1;
               ALUop <= 3'b111;
               RegWrite <= 1;
	    end
	    `JR: begin
	       $display("funct: %b: JR", funct);
	       Jump <= 1;
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