module test();
   reg clk = 0;
   always #1 clk = ~clk;
   cpu cpu(clk);
   initial 
     begin
	#100 $finish;
     end
endmodule // test
