module ALU(input [31:0] read_data_1,

	   input [31:0]  read_data_2_or_immediate,
	   input [2:0] 	 ALU_control,
	   output reg [31:0] ALU_result);

  reg [31:0] temp;
  //initial //$monitor($time,"ALUMonitor: SrcAE = %x SrcBE = %x ALU_result = %x",read_data_1,read_data_2_or_immediate,ALU_result);
  always @(*)
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
    end
endmodule

// module alu_test();

// 	reg [31:0] data1;
// 	reg [31:0] data2;
// 	reg [2:0] aru_crl;
// 	wire zero;
// 	wire [31:0]result;

// 	ALU ARIS(data1,data2,aru_crl,zero,result);


// 	initial
// 	begin
// 	$monitor("a=%d,b=%d,crl=%d,result=%d,zero=%b",data1,data2,aru_crl,result,zero);
// 		data1 <= 0;
// 		data2 <= 0;
// 		aru_crl <= 0;

// 		#5;

// 		data1 <= 2;
// 		data2 <= 3;
// 		aru_crl <= 0;
// 		//2&3
// 		#5;
// 		data1 <= 2;
// 		data2 <= 3;
// 		aru_crl <= 1;
// 		#5;
// 		data1 <= 2;
// 		data2 <= 3;
// 		aru_crl <= 2;
// 		#5;
// 		data1 <= 3;
// 		data2 <= 2;
// 		aru_crl <= 6;
// 		#5;
// 		data1 <= 2;
// 		data2 <= 3;
// 		aru_crl <= 7;
// 		#5;
// 		data1 <= 3;
// 		data2 <= 3;
// 		aru_crl <= 6;


// 	end
// endmodule
