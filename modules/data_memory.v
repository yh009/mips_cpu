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
    output [31:0] char,   
    input SyscallW
);



parameter DATA_BEGIN = 32'h0040_0000 >> 2;
parameter DATA_SEG = 32'h0041_0200 >> 2;
parameter DATA_END = 32'h0041_0f00 >> 2;


reg [31:0] RAM [DATA_END: DATA_BEGIN];      // like 255:0
reg [31:0] Stack [32'hffff_f000 >> 2: 32'hffff_ffff >> 2];

parameter MONITOR = 0;
integer i, j, f1, f2, p;
initial begin

    $monitor($time, "dm monitor: ALUoutM = %x, writeData = %x,readDataM = %x, Bytes = %x wa=%x mem_write = %x mem_read = %x value=%c",a,write_data,rd,char,wa,mem_write,mem_read,RAM[32'h00400090 >> 2]); 
    $readmemh("hello.v", RAM);
    for (p = DATA_SEG; p < DATA_END; p++)
        RAM[p] <= 32'b0;

    
end


assign char = char_reg;
reg [8:0] char_reg;
reg printSig = 0;

reg [1:0]sysbo;
reg [31:0]syswa;

parameter NEWLINE = 8'd10;
always @(posedge SyscallW)  begin
    sysbo = a0[1:0];
    syswa = a0[31:2];
    case(sysbo)
        3: char_reg = {23'b0, printSig, RAM[syswa][31:24]};
        2: char_reg = {23'b0, printSig, RAM[syswa][23:16]};
        1: char_reg = {23'b0, printSig, RAM[syswa][15:8]};
        0: char_reg = {23'b0, printSig, RAM[syswa][7:0]};
    endcase

    while (char_reg[7:0] != 8'b0)  begin

        #5;
        if (sysbo == 3) begin
            syswa = syswa + 1;
        end
        sysbo = sysbo + 1;
        printSig = !printSig;
        case(sysbo)
            3: char_reg = {23'b0, printSig, RAM[syswa][31:24]};
            2: char_reg = {23'b0, printSig, RAM[syswa][23:16]};
            1: char_reg = {23'b0, printSig, RAM[syswa][15:8]};
            0: char_reg = {23'b0, printSig, RAM[syswa][7:0]};
        endcase

    end

    
end

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
            if (wa <= DATA_END && wa >= DATA_BEGIN)
                RAM[wa] <= write_data;   
            else 
                if (wa > 32'hffff_ffff >> 2)   begin
                    $display("Stack overflow");
                end  else
                    if (wa >DATA_END) begin
                        $display("Data segment overflow");
                    end
            
    end

end


endmodule
