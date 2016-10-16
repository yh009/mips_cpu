module pc (input clk, 
	   input wire [31:0] nextPC, 
	   output reg [31:0]     currPC);
   initial begin
     currPC = 31'h400030;
   end
   always @(posedge clk)
     currPC = nextPC;
endmodule

// module pc_test();
//   reg clk;
//   reg [31:0] next;
//   wire [31:0] curr;

//   initial 
//     begin
//        #0 clk = 0;
//        #20 next = 32'h00000000;
//        #20 next = 32'h00000001;
//        #20 next = 32'h00000002;
//        #20 next = 32'h00000003;
//        #20 next = 32'h00000004;
//        #20 next = 32'h00000005;
//        #20 next = 32'h00000006;
//        #20 next = 32'h00000007;
//        #20 next = 32'h00000008;
//        #20 next = 32'h00000009;
//        #20 next = 32'h0000000a;
//        #20 next = 32'h0000000b;
//        #20 next = 32'h0000000c;
//        #20 next = 32'h0000000d;
//        #20 next = 32'h0000000e;
//        #20 next = 32'h0000000f;
//        #20 next = 32'h00000010;
//        #20 next = 32'h00000014;
//        #20 next = 32'h00000018;
//        #20 next = 32'h0000001c;
//        #20 next = 32'h00000020;
//        #20 next = 32'h00000025;
//        #20 next = 32'h00000030;
//        #20 $finish;
//     end // initial begin

//    pc program_counter(clk, next, curr);
   
//    always #5 clk = ~clk;

//   // initial
//   //   $monitor("%t %b %h %h", $time, clk, next, curr);
   
// endmodule // pc_test

      
   
