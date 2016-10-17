module data_memory(
		   input clk,
		   input wire [31:0] address, 
		   input wire [31:0]  write_data,
		   input wire mem_write,
		   input wire mem_read,
		   input wire [31:0] std_out_address,
		   output [31:0] read_data,
		   output [31:0] std_out);
   
   reg [31:0] mymem [32'h400000 : 32'h400400];
   initial
   begin
   $readmemh("hello.s", mymem);
   //$display("%h", mymem[5]);
   end

   always @(posedge clk) 
	begin
	   if (mem_write)
	     mymem[address] <= write_data;
	   //Write before read or read before write
	end

	assign read_data = mem_write ? write_data : mymem[address];
	assign std_out = mymem[std_out_address];

endmodule

// module mem_test();

// 	reg clk;
// 	reg [31:0] add;
// 	reg [31:0] writedata;
// 	reg memwrite;
// 	reg memread;
// 	wire [31:0]read_data;

// 	data_memory dm(clk,add, 
// 		  writedata, 
// 		  memwrite, 
// 		  memread, 
// 		  read_data);

// 	always begin
// 		clk <= ~clk;
// 		#5;
// 	end

// 	initial
// 	begin
// 	$monitor("%x",read_data);
// 		clk <= 0;
// 		add <= 0;
// 		writedata <= 0;
// 		memwrite <= 0;
// 		memread <= 1;

// 		@(posedge clk);

// 		writedata <= 0;
// 		add <= 32'h00000008;
// 		memread <= 1'b1;
// 		memwrite <= 1'b0;

// 		@(posedge clk);

// 		writedata <= 0;
// 		add <= 32'h0000000F;
// 		memread <= 1'b1;
// 		memwrite <= 1'b0;

// 		@(posedge clk);

// 		writedata <= 1;
// 		add <= 32'h00000008;
// 		memread <= 1'b0;
// 		memwrite <= 1'b1;
// 	end

	

// endmodule