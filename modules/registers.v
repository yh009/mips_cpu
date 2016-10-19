module registers(
		 input clk,
		 input [4:0] read_reg_1, read_reg_2,
		 input [4:0]   write_reg,
		 input [31:0]  write_data,
		 input JumpReg,
		 input reg_write,

		 output [31:0] read_data_1, read_data_2, 
		 output [31:0] sys_call_reg, std_out_address);
	

   reg [31:0] register_file [31:0];
   reg [31:0] data1;
   reg [31:0] data2;
   assign read_data_1 = data1;
   assign read_data_2 = data2;
   assign sys_call_reg = register_file[2];
   assign std_out_address = register_file[4];
   always @(posedge JumpReg) begin

   		data1 = register_file[read_reg_1];
   		//$display($time,"JumpRegUp, data1 = %x readreg1 = %x", data1,read_reg_1);
   end
	initial begin
		$monitor("registerfile: 31 = %x write_data = %x write_reg = %x reg_write = %x",register_file[31], write_data,write_reg,reg_write,$time);
		register_file[0] = 0;
		data1 = 0;
		data2 = 0;
	end

	always @(clk) begin
		$display($time,"$at : %x, $v0: %x, $ra: %x $sp :%x $s8: %x $zero : %x",register_file[1], register_file[2], register_file[31], register_file[29], register_file[30], register_file[0]);
	end


   always @(posedge clk) begin //This is for negedge read and posedge write, this is built just for the future.
   		$display($time,"posedge write: write_data = %x write_reg = %x reg_write = %x", write_data,write_reg,reg_write);
	    if (reg_write) 
	    register_file[write_reg] = write_data;
   end

   always @(*) 
     begin
		data1 <= register_file[read_reg_1];
		data2 <= register_file[read_reg_2];
     end

endmodule
