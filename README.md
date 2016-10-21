Names: Jiayu Huang, Yuxuan Huang, Kenny Rader

Date: 10-20-16

Class: CSCI 320L

Section: 8am

# File Structure
All of our files for this project are contained within the folder modules. Everything
can be done from there. There is not an abundant amount of further documentation
because we took steps to insure that our code is well-organized and well-commented.
Any further documentation, such as our Team Contract and Progress Report, is 
contained in the docs folder.

# Pipelined MIPS CPU
This is a simulation of a pipelined CPU written in Verilog. The system reads from
an instruction file in the inst_memory module, and sends each of the instructions
through the pipeline in sequence. The output of the system is any visible printings
coming from a $display syscall that may occur. Our design contains a variety of
modules that all work together to form the processor.

# Design
Our design is rather complex. The top level module is called cpu.v, and it
instantiates all of the other modules and connects them together. This module is
separated through comments into six distinct parts, one for each of the five
pipeline stages and one for the hazard unit, which is present throughout every
stage. The modules instantiated in each stage are as follows:

* The Fetch Stage instantiates a multiplexor that determines the incoming PC to
fetch from, the IF-stage pipeline state register, the instruction memory module
that does the actual fetching from the input instruction file, and the add4 unit
that handles the PC+4 functionality for normal program flow. The Fetch Stage also
contains the Jump module.

* The Decode Stage instantiates the ID-stage pipeline state register, the control
unit for signals throughout the entire pipeline, the register module containing
the register file, two multiplexors for determining forwarding in the Decode Stage,
and a multipurpose adder that does some sign extending and left-shifting for the
purpose of calculating branch targets. The Decode Stage also has a special Sign
Immediate module for dealing with LUI instructions.

* The Execute Stage instantiates the EX-stage pipeline state register, a multiplexor
passing on the write-register to the next stage, two three-way multiplexors for
the purpose of forwarding, a multiplexor determining the second ALU source operand,
and the all-important ALU itself. There is also another multiplexor for dealing
specifically with LUI instructions.

* The Memory Stage instantiates the MEM-stage pipeline state register and the
data_memory module that contains an implementation of a memory unit.

* The WriteBack Stage instantiates the WB-pipeline state register and two multiplexors
that determine the result to write to a register.

* The Hazard Stage, as you would expect, instantiates the hazard unit, which acts
very similarly to the control unit, but for hazard-specific signals.

We tried to stick as closely as possible to the module diagram provided in the
problem writeup, and all additional modules are based upon it:
![Module Diagram](https://gitlab.bucknell.edu/klr020/CSCI_320_Project_2/raw/fbd90a5965a93114129811c5737044808993cf4a/harris_pipeline_mips_modified.png)

This includes naming all our wires the same as the connecting wires depicted here,
as well as connecting them in the same manner shown in the image. One notable
deviation from this design includes the condensing of the sign extension and
left-shifting for calculating branch targets into one single module (called
id_multipurpose). Another major change involves providing support for syscalls.
We did this by adding wires transferring syscall information to the register, control,
and data_memory modules. In the event of a syscall, the value held in $v0 in the
register module would be sent to the control module to be deciphered. If the control
module determines that the instruction is indeed a syscall, it would use this value
to determine its next steps, reading from data_memory if necessary.

## Design: Jump Handling:
Jump instructions(JR in perticular) need more additional manipulation than branch
instructions. We designed a jump module in the Fetch Stage for handling JR instructions. 
It takes the instructions and decides whether the next PC address should be coming
from RD1 or PC. For JAL instructions, we basically pipelined the JAL control signal
and PCPlus4 all the way to the WriteBack Stage in order to actually write back the 
address that needs to be linked.

## Design: Syscall Handling:
Most of the groups doing this project would likely use the same method to implement
the JAL and JR instructions, but it is interesting to talk about the syscall design here.
The syscall in MIPS looks like this:
```
li v0, 4
syscall
```
There is no nop or things in between li and syscall. However, syscall needs v0's
information in the Decode Stage to execute. Therefore, hazard handling need to be 
done. Our design is pretty straightforward and simple. We send out a syscall signal,
then stall the ID and IF stages for 3 cycle when that signal is received. Then the
v0 register will be updated. Because we know that from EX=>MEM=>WB, there are 3 cycles,
we only need to stall for 3 cycles. Finall, we let the control module decode the syscall. 

### Syscall design: Stdout and print:
Because the information is stored in data_memory, when we need to do a print, it should
be handled there. In order to minimize the CPU's complexity, the print is handled in the
data memory module. When we have syscall puts, there will be a print signal sent to the
data memory. The data memory gets the string address from the a0 register directly.
Even though registers and the control module are in the ID Stage and data_memory is in
the MEM stage, we can use a wire to connect them for non-lagging information. Data memory
would then print the string until the end nop. Finally, there will be a signal back to
the control module signifying that the print is complete. During this time, no instructions
will be allowed to execute. Though the solution is a brutal force approach, because the
data_memory module is fast in printing out, there will be no apparent lag during the 
printing.

## Design: Forwarding:
All the forwardings(EX-EX, MEM-EX, and MEM-MEM) are handled in the hazard unit. 
Their logic is correct and works correctly so as to support the Hello World program.

# Testing
## Unit Testing:
This project consists of lots of submodules and a top-level cpu to connect them together. 
For each of the important modules we wrote unit tests. For example, in the control module, 
we have a commented section that is a test bench. To access the unit test branch, 
The developer/user can uncomment the unit test code and then use `iverilog module_name.v -o test_module_name.o`
to compile the test. They can then run the test with `./test_module_name`. Also, the unit
test acts as a reference for how to use that specific module. Do note however, our team 
doesn't guarentee that all modules have unit tests and all unit tests work right now. 
A lot has changed throughout development, and some tests may have been invalidated.

### Sample Unit Testing:
```
module test;
   reg [31:0] instr;
   wire RegDst;
   wire Jump;
   wire Branch;
   wire MemRead;
   wire MemToReg;
   wire [2:0] ALUop;
   wire       RegWrite;
   wire       ALUSrc;
   wire       MemWrite;

   control myControl(instr,RegDst,Jump,Branch,MemRead,MemToReg,ALUop,RegWrite,ALUSrc,MemWrite);
   
   initial begin
		#10 instr=`ADD;
		#20 instr=`BNE;
		#20 instr=`SUB;
		#20 instr=`JR;
		#20 instr=`AND;
		#20 instr=`OR;
		#20 instr=`SLT;
		#20 instr=`JAL;
		#20 instr=`ADDI;
		#20 instr=`ORI;
		#20 instr=`LW;
		#20 instr=`SW;
		#20 instr=`BEQ;
		#20 instr=`J;
		
		
		//#100 $finish;
	end

	initial begin
		$monitor($time, " RegDst=%b,Jump=%b,Branch=%b,MemRead=%b,MemToReg=%b,ALUop=%b,RegWrite=%b,ALUSrc=%b,MemWrite=%b.",
			 RegDst,Jump,Branch,MemRead,MemToReg,ALUop,RegWrite,ALUSrc,MemWrite);
		#10000 $finish;
	end
   //initial begin
      //clk=0;
   //end

   //always #250 clk=~clk;


endmodule
```

## Systematic Testing:
Another important part of testing is systematic testing. We can not provide a complete 
test bench right now, but the general idea of systematic testing is to use `$monitor` and 
`$display` statements to track signals as they move throughout the system. Since iverilog 
only supports one $monitor at a time, we found that we can get the variable information more
effectively through $display. Because we care the most about the signals at the clock
edge, we can build an always block that triggers with the clock and displays `$time` and
various signal information throughout the program's runtime.

### Sample code:
```
always @(clk) begin
   	$display($time,"WriteRegW = %x, ResultW = %x, RegWriteW = %x ReadDataW = %x ALUOutW = %x MemtoRegW = %x PC = %x", WriteRegW,ResultW,RegWriteW, ReadDataW, ALUOutW, MemtoRegW, PC);
   end
```
Using this approach, we can log as much info as we like. However, there are still some
edge cases that we need to precisely monitor. We will still need $monitor to get the important
signal information in these cases. By combining the `$monitor` and `$display` statements,
we can generate real-time signal logging as the program runs. In this way, we can easily
debug and test systematically.

# Compilation
The program can be compiled with the following command:

make

There is a Makefile for this project, so just running make should suffice in compiling
the program, provided you have ALL of the project files.

# Execution
The program can then be executed with the following command:

./mips_test