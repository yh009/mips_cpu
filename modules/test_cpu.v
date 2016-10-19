`include "cpu.v"

module test_cpu;
	reg clk = 0;
	
	cpu cpu(clk);
	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
<<<<<<< HEAD
		#500;
=======
		#250;
>>>>>>> bcebb79d06d4dff33c6d78feca6a5a5bfc8e8120
		$finish();
	end
	
endmodule
