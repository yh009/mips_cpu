module registers(input [4:0] read_reg_1,
		 input [4:0]   read_reg_2,
		 input [4:0]   write_reg,
		 input [31:0]  write_data,
		 input reg_write,
		 output reg [31:0] read_data_1,
		 output reg [31:0] read_data_2);
   reg [31:0] 			 register_file [31:0];
   always @(*) 
        begin
           read_data_1 = register_file[read_reg_1];
	   read_data_2 = register_file[read_reg_1];
	   if (reg_write)
	     register_file[write_reg] = write_data;
	end
endmodule