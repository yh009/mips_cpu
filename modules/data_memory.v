/*
 * data memory
 * from Harris & Harris P. 439
 */

module data_memory (
    input clk,
    input [31:0] a,         
    input [31:0] write_data,        
    input mem_write,
    input mem_read,
    input [31:0] a0,        
    output [31:0] rd,       
    output reg [31:0] char [31:0],   
    input SyscallW
);

reg [31:0] RAM [32'h0041_0f00 >> 2: 32'h0040_0000 >> 2];      
reg [31:0] Stack [32'hffff_f000 >> 2: 32'hffff_ffff >> 2];

integer i, j, f1, f2, p;
initial begin
    $monitor($time, "dm monitor:char %c char %c ",char,RAM[32'h100026]); 
    $readmemh("hello.v", RAM);
end


reg [31:0] char_reg;
reg printSig = 0;

reg [31:0]phywordaddress;

always @(negedge clk) begin
    reg [0]
    while(char_reg != 0) begin
        char
    end
end

// always @(negedge clk)  begin
//     sysbo = a0[1:0];
//     syswa = a0[31:2];
//     case(sysbo)
//         3: char_reg = {23'b0, printSig, RAM[syswa][31:24]};
//         2: char_reg = {23'b0, printSig, RAM[syswa][23:16]};
//         1: char_reg = {23'b0, printSig, RAM[syswa][15:8]};
//         0: char_reg = {23'b0, printSig, RAM[syswa][7:0]};
//     endcase

//     while (char_reg[7:0] != 8'b0)  begin

//         #5;
//         if (sysbo == 3) begin
//             syswa = syswa + 1;
//         end
//         sysbo = sysbo + 1;
//         printSig = !printSig;
//         case(sysbo)
//             3: char_reg = {23'b0, printSig, RAM[syswa][31:24]};
//             2: char_reg = {23'b0, printSig, RAM[syswa][23:16]};
//             1: char_reg = {23'b0, printSig, RAM[syswa][15:8]};
//             0: char_reg = {23'b0, printSig, RAM[syswa][7:0]};
//         endcase
//     end
// end


wire [31:0] wa;
assign wa = {2'b00, a[31:2]};

wire [1:0] bo;
assign bo = a[1:0];

reg [31:0] word2Write;


assign rd = Stack[wa];

always @(negedge clk) begin// TODO why clk
    $display($time,"Write Attempt %x %x %x %x",wa,a,mem_write,write_data);
    if (mem_write) begin

	$display($time,"Write Attempt %x %x %x %x",wa,32'hffff_ffff >> 2,32'hffff_f000 >> 2,word2Write);
        if (wa <= 32'hffff_ffff >> 2 && wa >= 32'hffff_f000 >> 2)
	begin
            Stack[wa] <= write_data;
	    $display($time,"Write Success %x %x",word2Write,wa);
end
        else 
            if (wa <= 32'h0041_0f00 >> 2 && wa >= 32'h0040_0000 >> 2)
                RAM[wa] <= write_data;   
            else 
                if (wa > 32'hffff_ffff >> 2)   begin
                    $display("Stack overflow");
                end  else
                    if (wa >32'h0041_0f00 >> 2) begin
                        $display("Data segment overflow");
                    end
            
    end

end


endmodule
