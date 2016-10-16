module inst_memory(
	input clk,
	input [29:0] read_addr, 
	output[31:0] memout);

   reg [31:0] mymem [32'h400000 : 32'h400400];
   reg [31:0] regout;

   assign memout = regout;

   initial begin
   	$readmemh("hello.s", mymem);
   	$display("mem: %x",mymem[32'h400000]);
   end
   always @(*) 
    begin
		regout = mymem[read_addr];
		if (regout == 0)
	  	begin
	     	$strobe("Found null op at addr %08x.", read_addr);
	     	$finish();
	  	end
    end
endmodule

// module imtest();
// 	reg clk;
// 	reg [29:0] read_addr;
// 	wire [31:0] memout;
// 	always begin
// 		clk <= ~clk;
// 		#5;
// 	end
// 	inst_memory inst(clk,read_addr,memout);


// 	initial begin
// 		$monitor("read_addr = %h, memout = %h",read_addr,memout);
// 		read_addr <= 0;
// 		clk <= 0;

// 		@(posedge clk);
// 		read_addr <= 8;
// 		@(posedge clk);
// 		read_addr <= 9;
// 		@(posedge clk);
// 		read_addr <= 10;
// 		@(posedge clk);
// 		read_addr <= 12;
// 		@(posedge clk);
// 		read_addr <= 13;
// 		@(posedge clk);
// 		read_addr <= 14;
// 		@(posedge clk);
// 		read_addr <= 15;
// 		@(posedge clk);
// 		read_addr <= 16;
// 		@(posedge clk);
// 		read_addr <= 17;
// 		@(posedge clk);
// 		read_addr <= 18;
// 		@(posedge clk);
// 		read_addr <= 19;
// 		@(posedge clk);
// 		read_addr <= 20;

// 	end
// 	endmodule
