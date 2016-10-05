module ALU(input [31:0] read_data_1,
	   input [31:0]  read_data_2_or_immediate,
	   input [2:0] 	 ALU_control,
	   output reg	 zero,
	   output reg [31:0] ALU_result);
  reg [31:0] temp;
  initial
    begin
       case (ALU_control)
	 0: ALU_result = read_data_1 & read_data_2_or_immediate;
	 1: ALU_result = read_data_1 | read_data_2_or_immediate;
	 2: ALU_result = read_data_1 + read_data_2_or_immediate;
	 6: ALU_result = read_data_1 - read_data_2_or_immediate;
	 7: begin 
	    if (read_data_1 < read_data_2_or_immediate)
	      ALU_result = read_data_1;
	    else
	      ALU_result = read_data_2_or_immediate;
         end
	 default: $display("That's not a supported ALUop!");
       endcase
       if (ALU_result == 0)
	 zero = 1;
       else
	 zero = 0;
    end
endmodule