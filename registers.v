module registers(
		 input clk,
		 input [4:0] read_reg_1, read_reg_2,
		 input [4:0]   write_reg,
		 input [31:0]  write_data,
		 input reg_write,
		 output [31:0] read_data_1, read_data_2, sys_call_reg,std_out_address);

   reg [31:0] register_file [31:0];
   reg [31:0] data1;
   reg [31:0] data2;
   assign read_data_1 = data1;
   assign read_data_2 = data2;
   assign sys_call_reg = register_file[2];
   assign std_out_address = register_file[4];

 //   //This initial only for test
 //   initial begin
 //   			register_file[2] = 32'd4;	/* $v0 */
	// 		register_file[3] = 32'd5;	/* $v1 */
	// 		// 	);
	// end

   always @(posedge clk) begin //This is for negedge read and posedge write, this is built just for the future.
	    if (reg_write) register_file[write_reg] = write_data;
	    end
   always @(negedge clk) begin
   		data1 = register_file[read_reg_1];
	   	data2 = register_file[read_reg_1];
   end
endmodule

// module regitests();

// 	reg clk;
// 	reg [4:0] reg1_addr;
// 	reg [4:0] reg2_addr;
// 	reg [4:0] write_reg;
// 	reg [31:0] write_data;
// 	reg reg_write;
// 	wire [31:0] data1;
// 	wire [31:0] data2;
// 	registers regi(clk,
// 		  reg1_addr, 
// 		  reg2_addr, 
// 		  write_reg, 
// 		  write_data, 
// 		  reg_write,
// 		  data1,
// 		  data2);

// 	always begin
// 		clk <= ~clk;
// 		#5;
// 	end

// 	initial
// 	begin
// 		$monitor("readdata1 = %d readdata2 = %d ", data1,data2);
// 		clk <= 0;
// 		reg1_addr <= 0;
// 		reg2_addr <= 0;
// 		write_reg <= 0;
// 		write_data <= 0;
// 		reg_write <= 0;

// 		@(posedge clk);

// 		write_reg <= 8;
// 		write_data <= 4;
// 		reg_write <= 1;

// 		@(negedge clk);

// 		reg1_addr <= 2;
// 		reg2_addr <= 8;
// 		reg_write <= 0;


	// end

// endmodule
