Names: Jiayu Huang, Yuxuan Huang, Kenny Rader

Date: 10-20-16

Class: CSCI 320L

Section: 8am

# File Structure
All of our files for this project are contained within the folder modules. Everything
can be done from there. There is not an abundant amount of further documentation
because we took steps to insure that our code is well-organized and well-commented,
but if there is any further documentation, it is contained in the docs folder.

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
that handles the PC+4 functionality for normal program flow.

* The Decode Stage instantiates the ID-stage pipeline state register, the control
unit for signals throughout the entire pipeline, the register module containing
the register file, two multiplexors for determining forwarding in the Decode Stage,
and a multipurpose adder that does some sign extending and left-shifting for the
purpose of calculating branch targets.

* The Execute Stage instantiates the EX-stage pipeline state register, a multiplexor
passing on the write-register to the next stage, two three-way multiplexors for
the purpose of forwarding, a multiplexor determining the second ALU source operand,
and the all-important ALU itself.

* The Memory Stage instantiates the MEM-stage pipeline state register and the
data_memory module that contains an implementation of a memory unit.

* The WriteBack Stage instantiates the WB-pipeline state register and a multiplexor
that determines the result to write to a register.

* The Hazard Stage, as you would expect, instantiates the hazard unit, which acts
very similarly to the control unit, but for hazard-specific signals.

We tried to stick as close as possible to the module diagram provided in the
problem writeup:
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

## Design: Syscall Handling:
Most of the groups doing this project would use the same way to implement the JAL and JR, but it is interesting to talk about the syscall design here.
The syscall in mips code is like:
```
li v0, 4
syscall
```
There is no nop or things in between li and syscall. However, syscall needs v0 information in decode stage to get executed. Therefore, a hazard handling need to be done.
Our design is pretty straight forward and simple, we send out a syscall signal then stall the ID and IF stage for 3 cycle when we see syscall. Then the v0 should be updated.
Because we know that from EX=>MEM=>WB, there are 3 cycles, we just stall it like this. Then, we let the control module to decode the syscall. 

### Syscall design: Stdout and print:
Because the information is stored in datamem, when we need to do a print, we won't use other module to handle print. In order to make the cpu complexity a little bit smaller, 
the print is handled in data memory module. When we have syscall puts, there will be a print sig sent to the data memory. data memory gets the string address from a0 register directly.
Though rigisters and control is in ID stage and datamem is in MEM stage, we use a wire to connect them for non-lagging information. data memory would print the string until the end nop. 
Then there will be a signal back to control telling the control module print complete. During this time, there will be no instruction allowed to be executed. i.e. StallD and F. Though the 
solution is brutal force, because the datamem is fast in printing out, there will be no lag during the printing. adding the signal back and forth is just for preventing purpose.


# Testing
## Unit Testing:
This project consists of lots of sub modules and a cpu to connect them together. For each important module we write the unit test.
For example, in control module, we have a commented section that is a test branch. To access the unit test branch, 
The developer/user can uncomment the unit test code and then use `iverilog module_name.v -o test_module_name.o` to compile the test.
Then `./test_module_name` to run the unit test for the specific module. Also, the unit test is a reference for how to use the specific module.
But keep in mind, our team won't guarentee that all modules have unit tests and all unit tests work right now. As we pick the **important** one to do 
the test and we change the inputs/outputs of the modules through the development process. If the unit test not working, pls read the code and modify the test.

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
Another important part of testing is the systematic testing. We can not give out a complete test branch right now. But the general idea of the systematic testing is 
to use `$monitor` and `$display` to keep the variable on track. As the iverilog only supports one $monitor at a time, we find a way to get the variable information effectively through $display.
Because we care the most about the variable at clk edge so we can build an always block that triggers by clk and display `$time` and variable info through the program running.
### Sample code:
```
always @(clk) begin
   	$display($time,"WriteRegW = %x, ResultW = %x, RegWriteW = %x ReadDataW = %x ALUOutW = %x MemtoRegW = %x PC = %x", WriteRegW,ResultW,RegWriteW, ReadDataW, ALUOutW, MemtoRegW, PC);
   end
```
In this way, we can log as many info. as we like. However, there is still some edge case that we need to precise monitoring. We still need $monitor to get the important variable information.
By combining the `$monitor` and `$display`, we can generate the real-time logging as the program runs. In this way, we can easily debug and test systematically.
# Compilation
The program can be compiled with the following command:

make

There is a Makefile for this project, so just running make should suffice in compiling
the program, provided you have ALL of the project files.

# Execution
The program can then be executed with the following command:

./mips_test