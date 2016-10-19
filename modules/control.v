`include "mips.h"

module control(
	       input [31:0] 	instr,
	       input [31:0] 	vreg,
	       input [31:0] 	str, 
	       output reg [1:0] RegDst,
	       output reg 	Jump,
	       output reg 	Branch,
	       output reg 	MemRead,
	       output reg 	MemToReg,
	       output reg [2:0] ALUop,
	       output reg 	RegWrite,
	       output reg 	ALUSrc,
	       output reg 	MemWrite,
	       output reg 	JumpLink,
	       output reg 	JumpReg,
	       output reg 	syscall);
   
   reg [5:0] opcode;
   reg [5:0] funct;
   
   initial
     begin
      RegDst = 2'b0;
      Jump = 1'b0;
      Branch = 1'b0;
      MemRead = 1'b0;
      MemToReg = 1'b0;
      ALUop = 3'b000;
      RegWrite = 1'b0;
      ALUSrc = 1'b0;
      MemWrite = 1'b0;
      JumpLink = 0;
      JumpReg = 0;
      syscall = 0;	
     end // initial begin
   
   always @(*)
       begin
      	RegDst = 2'b0;
      	Jump = 1'b0;
      	Branch = 1'b0;
      	MemRead = 1'b0;
      	MemToReg = 1'b0;
      	ALUop = 3'b000;
      	RegWrite = 1'b0;
      	ALUSrc = 1'b0;
      	MemWrite = 1'b0;
      	JumpLink = 0;
      	JumpReg = 0;
	syscall = 0;  
	opcode = instr[31:26];
	funct = instr[5:0];
	  
	$display($time," control module: instruction being decoded: %x", instr);
	  case (opcode)
	    `ADDI: begin
	       $display("%b: ADDI", opcode);
	       ALUop = 3'b010;
               RegWrite = 1;
               ALUSrc = 1;
               Jump = 0;
	    end
	    `ORI: begin
	       $display("%b: ORI", opcode);
	       ALUop = 3'b001;
               RegWrite = 1;
               ALUSrc = 1;
               Jump = 0;
               JumpLink = 0;
	    end
	    `LW: begin
	       $display("%b: LW", opcode);
	       MemRead = 1;
               MemToReg = 1;
	       ALUop = 3'b010;
               RegWrite = 1;
               ALUSrc = 1;
               Jump = 0;
	    end  
	    `SW: begin
	       $display("%b: SW", opcode);
	       ALUop = 3'b010;
               ALUSrc = 1;
               MemWrite = 1;
               Jump = 0;
	    end	  
	    `BEQ: begin
	       $display("%b: BEQ", opcode);
	       Branch = 1;
	       ALUop = 3'b110;
	       Jump = 0;
	    end	  
	    `BNE: begin
	       $display("%b: BNE", opcode);
	       Branch = 1;
	       ALUop = 3'b110;
	       Jump = 0;
	    end  
	    `J: begin
	       $display("%b: J", opcode);
	       Jump = 1;
	    end
	    `JAL: begin
	       $display("%b: JAL", opcode);
	       Jump = 1;
	       JumpLink = 1;
	       RegDst = 2;
	       RegWrite = 1;

	    end
	    `ADDIU: begin
	       $display("%b: ADDIU", opcode);
	       ALUop = 3'b010;
	       RegWrite = 1;
	       ALUSrc = 1;
	       Jump = 0;
	    end
	    `SLTIU: begin
	       $display("%b: SLTIU", opcode);
	       ALUop = 3'b111;
	       RegWrite = 1;
	       ALUSrc = 1;
	       Jump = 0;
	    end
	    `LUI: begin
	       $display("%b: LUI", opcode);
	       ALUop = `ALU_add;
	       RegWrite = 1;
	       ALUSrc = 1;
	       Jump = 0;
	    end
	    `SPECIAL: begin
	       $display("Special instruction detected: %x", instr);
	       $display("%b: SPECIAL", opcode);
	       Jump = 0;
	       case (funct)
		 `ADD: begin
		    $display("funct: %b: ADD", funct);
		    RegDst = 1;
		    ALUop = 3'b010;
		    RegWrite = 1;
		 end
		 6'b100001: begin
		    $display("%b: ADDU", funct);
		    RegDst = 1;
		    ALUop = 3'b010;
		    RegWrite = 1;
		 end
		 `SUB: begin
		    $display("funct: %b: SUB", funct);
		    RegDst = 1;
		    ALUop = 3'b110;
		    RegWrite = 1;
		 end
		 `AND: begin
		    $display("funct: %b: AND", funct);
		    RegDst = 1;
		    ALUop = 3'b000;
		    RegWrite = 1;
		 end
		 `OR: begin
		    $display("funct: %b: OR", funct);
		    RegDst = 1;
		    ALUop = 3'b001;
		    RegWrite = 1;
		 end
		 `SLT: begin
		    $display("funct: %b: SLT", funct);
		    RegDst = 1;
		    ALUop = 3'b111;
		    RegWrite = 1;
		 end
		 `JR: begin
		    $display("funct: %b: JR", funct);
		    JumpReg = 1;
		 end
		 6'b000000: begin
		    $display("funct: %b: NOP", funct);
		 end
		 `SYSCALL: begin
		    $display("Syscall: vreg == %x", vreg);
		    syscall = 1;
		    case (vreg)
		      4: begin
			 $display("areg = %x", str);
		   
			 $display("syscall puts %s", str);
		      end
		      
		      10: begin
		      	$display("syscall exit");
		      	$finish;
		      end
		      default: begin
		      	$display("vreg = %x, Syscall, but not a supported one!", vreg);
		      	Jump = 0;
		      end
		    endcase // case (vreg)
		 end
		 default: begin
		   $display("funct: %b: That's not a supported funct!", funct);
		   Jump = 0;
		   end
	       endcase
	    end
	    default: begin
	      $display("%b: That's not a supported instruction!", opcode);
	      Jump = 0;
	      end
	  endcase // case (opcode)
     end // if (instr != 0 && opcode !== 6'bxxxxxx)

endmodule // control


// module test;
//    reg [31:0] instr;
//    wire RegDst;
//    wire Jump;
//    wire Branch;
//    wire MemRead;
//    wire MemToReg;
//    wire [2:0] ALUop;
//    wire       RegWrite;
//    wire       ALUSrc;
//    wire       MemWrite;

//    control myControl(instr,RegDst,Jump,Branch,MemRead,MemToReg,ALUop,RegWrite,ALUSrc,MemWrite);
   
//    initial begin
// 		#10 instr=`ADD;
// 		#20 instr=`BNE;
// 		#20 instr=`SUB;
// 		#20 instr=`JR;
// 		#20 instr=`AND;
// 		#20 instr=`OR;
// 		#20 instr=`SLT;
// 		#20 instr=`JAL;
// 		#20 instr=`ADDI;
// 		#20 instr=`ORI;
// 		#20 instr=`LW;
// 		#20 instr=`SW;
// 		#20 instr=`BEQ;
// 		#20 instr=`J;
		
		
// 		//#100 $finish;
// 	end

// 	initial begin
// 		$monitor($time, " RegDst=%b,Jump=%b,Branch=%b,MemRead=%b,MemToReg=%b,ALUop=%b,RegWrite=%b,ALUSrc=%b,MemWrite=%b.",
// 			 RegDst,Jump,Branch,MemRead,MemToReg,ALUop,RegWrite,ALUSrc,MemWrite);
// 		#10000 $finish;
// 	end
//    //initial begin
//       //clk=0;
//    //end

//    //always #250 clk=~clk;


// endmodule
