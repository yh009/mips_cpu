module inst_memory(input [29:0] read_addr, output reg [31:0] memout);
   reg [31:0] mymem [32'h00100000 : 32'h00100100];
   initial
     $readmemh("add_test.v", mymem);
   always @(*) 
     begin
	memout = mymem[read_addr];
	if (memout == 0)
	  begin
	     $strobe("Found null op at addr %08x.", read_addr);
	     $finish();
	  end
     end
endmodule