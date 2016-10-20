`include "cpu.v"

module test_cpu;
	reg clk = 0;
	
	cpu cpu(clk);
	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		#250;
		$finish();
	end
	
endmodule
