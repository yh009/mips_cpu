Names: Jiayu Huang, Yuxuan Huang, Kenny Rader

Date: 10-20-16

Class: CSCI 320L

Section: 8am

# Pipelined MIPS CPU
This is a simulation of a pipelined CPU written in Verilog. The system reads from
an instruction file in the inst_memory module, and sends each of the instructions
through the pipeline in sequence. The output of the system is any visible printings
coming from a $display syscall that may occur. Our design contains a variety of
modules that all work together to form the processor.

# Design
Our design is rather complex. The top level module is called cpu.v, and it
instantiates all of the other modules and connects them together. This module is
separated through comments into six distinct parts. One for each of the five
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