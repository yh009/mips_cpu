`include "mips.h"


// Decodes the current instruction
// toss a syscall signal into the pipeline like an exception
// at the writeback stage, when v0 should have been written, 
// use v0 value then to take action
module syscallcontrol (
    input [31:0] Rdv0,
    input [31:0] char,
    //input [5:0] opcode, funct,
    input [31:0] instr,
    input SyscallW,
    //input [63:0] instr_count,
    output SyscallD
);

real clock_cycles;
reg SyscallD_reg;
// assign SyscallD = SyscallD_reg;

reg [5:0] opcode;
reg [5:0] funct;
always @(*)begin
	opcode = instr[31:26];
	funct = instr[5:0];
end

// send signal into pipeline
// always @(opcode, funct)
//     if ((opcode == `SPECIAL) && (funct == `SYSCALL))
// begin
//         SyscallD_reg <= 1'b1;
// 	$display("syscall detected %x",Rdv0);
// end
//     else 
//         // checks for the break instruction
//         // terminates the simulation immediately 
//         if ((opcode == `SPECIAL) && (funct == `BREAK)) begin
//             //$display("divide by zero exception; terminating immediately");
//             // $finish;
//         end
//         else
//             SyscallD_reg <= 1'b0;


always @(SyscallW, char)
    if (SyscallW == 1'b1)
        case (Rdv0)
            32'd10: begin // finish
                //$display("OS: received syscall finish, terminating...");
                clock_cycles = ($time + 50)/100 + 4;
                $display("\n**Program finished**");
                $display("\t CPU stats: ");
                $display("\t\tclock cycles passed:\t%-d", clock_cycles);
                //$display("\t\tinstruction exectuted:\t%-d", instr_count);
                //$display("\t\tinstructions per cycle:\t%-.5f", instr_count/(clock_cycles));
                $finish;
            end
            32'd4: begin  // print
	            // $display("printf %x", char[24:31]);
	            if (char[7:0] != 8'h00) begin
                    $write("%c", char); 
                end
            end
            default:
                $display("unknown syscall");
        endcase




endmodule
