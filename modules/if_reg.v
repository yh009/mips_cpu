module if_reg(input clk,
	      input [31:0] pcadd,
	      input 	   stallf,
	      output reg [31:0] pcfetch);

   reg [31:0] 		    pcreg;

   initial begin
      pcreg = 31'h400030;
   end


   always @(negedge clk) begin
      if(stallf != 1) begin
	     pcreg = pcadd;
      end
   end

   always @(posedge clk) begin
      if(stallf != 1) begin
         pcfetch = pcreg;
      end
   end

   
endmodule



