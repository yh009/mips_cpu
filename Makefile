default:
	iverilog -o cpu_test cpu.v add4.v ALU.v control.v data_memory.v ex_reg.v hazard_unit.v id_reg.v if_reg.v inst_memory.v mem_reg.v mux.v pc.v registers.v wb_reg.v

demo:
	vvp cpu_test
