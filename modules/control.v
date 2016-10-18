`include "mips.h"

module control(
	       input [31:0] 	instr,
	       input [31:0] 	vreg,
	       input [31:0] 	str, 
	       output reg 	RegDst,
	       output reg 	Jump,
	       output reg 	Branch,
	       output reg 	MemRead,
	       output reg 	MemToReg,
	       output reg [2:0] ALUop,
	       output reg 	RegWrite,
	       output reg 	ALUSrc,
	       output reg 	MemWrite);
   wire [5:0] opcode = instr [31:26];
   wire [5:0] funct = instr [5:0];
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
   always @(*)
     if (instr != 0 && opcode !== 6'bxxxxxx) 
       begin
	  $display("control module: instruction being decoded: %x", instr);
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
	    `LUI: begin
	       $display("%b: LUI", opcode);
	       ALUop <= `ALU_add;
	       RegWrite <= 1;
	       ALUSrc <= 1;
	    end
	    `SPECIAL: begin
	       $display("Special instruction detected: %x", instr);
	       $display("%b: SPECIAL", opcode);
	       case (funct)
		 `ADD: begin
		    $display("funct: %b: ADD", funct);
		    RegDst <= 1;
		    ALUop <= 3'b010;
		    RegWrite <= 1;
		 end
		 `SUB: begin
		    $display("funct: %b: SUB", funct);
		    RegDst <= 1;
		    ALUop <= 3'b110;
		    RegWrite <= 1;
		 end
		 `AND: begin
		    $display("funct: %b: AND", funct);
		    RegDst <= 1;
		    ALUop <= 3'b000;
		    RegWrite <= 1;
		 end
		 `OR: begin
		    $display("funct: %b: OR", funct);
		    RegDst <= 1;
		    ALUop <= 3'b001;
		    RegWrite <= 1;
		 end
		 `SLT: begin
		    $display("funct: %b: SLT", funct);
		    RegDst <= 1;
		    ALUop <= 3'b111;
		    RegWrite <= 1;
		 end
		 `JR: begin
		    $display("funct: %b: JR", funct);
		    Jump <= 1;
		 end
		 `SYSCALL: begin
		    case (vreg)
		      4: $display("%s", str);
		      10: begin
		      	$display("syscall exit");
		      	$finish;
		      end
		      default: $display("vreg = %x, Syscall, but not a supported one!", vreg);
		    endcase // case (vreg)
		 end
		 default:
		   $display("funct: %b: That's not a supported funct!", funct);
	       endcase
	    end
	    default:
	      $display("%b: That's not a supported instruction!", opcode);
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
