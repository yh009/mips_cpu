module registers(input clk,
		 input [4:0] read_reg_1, 
		 input [4:0] read_reg_2,
		 input [4:0]   write_reg,
		 input [31:0]  write_data,
		 input JumpReg,
		 input reg_write,
		 output [31:0] read_data_1, 
		 output [31:0] read_data_2, 
		 output [31:0] sys_call_reg, 
		 output [31:0] std_out_address);

   reg [31:0] register_file [31:0];
   reg [31:0] data1;
   reg [31:0] data2;
   reg [31:0] v0;
   reg [31:0] a0;
   
   assign read_data_1 = data1;
   assign read_data_2 = data2;
   assign sys_call_reg = v0;
   assign std_out_address = a0;
   
   always @(posedge JumpReg) begin
      data1 = register_file[read_reg_1];
   end

	initial begin
		$monitor($time,"read_data_1 = %x, read_data_2 = %x write_data = %x",read_data_1, read_data_2,write_data);
		//$monitor("registerfile: 31 = %x write_data = %x write_reg = %x reg_write = %x",register_file[31], write_data,write_reg,reg_write,$time);
		register_file[0] = 0;
      	register_file[1] = 0;
      	register_file[2] = 0;
      	register_file[3] = 0;
      	register_file[4] = 0;
      	register_file[5] = 0;
      	register_file[6] = 0;
      	register_file[7] = 0;
      	register_file[8] = 0;
      	register_file[9] = 0;
      	register_file[10] = 0;
      	register_file[11] = 0;
      	register_file[12] = 0;
      	register_file[13] = 0;
      	register_file[14] = 0;
      	register_file[15] = 0;
      register_file[16] = 0;
      register_file[17] = 0;
      register_file[18] = 0;
      register_file[19] = 0;
      register_file[20] = 0;
      register_file[21] = 0;
      register_file[22] = 0;
      register_file[23] = 0;
      register_file[24] = 0;
      register_file[25] = 0;
      register_file[26] = 0;
      register_file[27] = 0;
      register_file[28] = 0;
      register_file[29] = 0;
      register_file[30] = 0;
      register_file[31] = 0;
      data1 = 0;
      data2 = 0;
      v0 = 0;
      a0 = 0;
		data1 = 0;
		data2 = 0;
	end

	always @(clk) begin
		$display($time,"$at : %x, $v0: %x, $ra: %x $sp :%x $s8: %x $zero : %x",register_file[1], register_file[2], register_file[31], register_file[29], register_file[30], register_file[0]);
	end



   always @(posedge clk) begin 
//This is for negedge read and posedge write, this is built just for the future.
      if (reg_write) 
	register_file[write_reg] = write_data;
   end

   always @(*) 
     begin
     	if(write_reg == read_reg_1) begin
     		data1 <= write_data;
     		data2 <= register_file[read_reg_2];
     	end
     	else begin
     	if(write_reg == read_reg_2) begin
     		data1 <= register_file[read_reg_1];
     		data2 <= write_data;
     	end
     	else begin
			data1 <= register_file[read_reg_1];
			data2 <= register_file[read_reg_2];
		end
		end
		v0 = register_file[2];
		a0 = register_file[4];
     end
   

endmodule
