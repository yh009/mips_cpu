
module test_cpu;
	reg clk = 0;
	
	cpu cpu(clk);
	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		//$display("clk = %d",clk);
		//$monitor($time,"clk: %d",clk);
	end
	
endmodule
