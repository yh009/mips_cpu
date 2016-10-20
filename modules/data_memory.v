module data_memory (
    input clk,
    input [31:0] address,         
    input [31:0] write_data,        
    input mem_write,
    input mem_read,
    input printSig,
    input [31:0] a0,        
    output [31:0] read,       
    output reg siggot
);

reg [31:0] physicaldatamem [32'h00410f00 >> 2: 32'h00400000 >> 2];      
reg [31:0] physicalstackmem [32'hffff_f000 >> 2: 32'hffff_ffff >> 2];
reg [8:0] char_reg;
reg [1:0]byteoffseta0;
reg [31:0]wordaddressa0;
wire [31:0] wordaddress;
wire [1:0] byteoffset;
assign wordaddress = {2'b00, address[31:2]};

initial begin
    $readmemh("hello.v", physicaldatamem);
end

always @(posedge printSig)  begin //Process print
    siggot = 1;
    byteoffseta0 = a0[1:0];
    wordaddressa0 = a0[31:2];
    case(byteoffseta0)
        0: char_reg = {physicaldatamem[wordaddressa0][7:0]};
        1: char_reg = {physicaldatamem[wordaddressa0][15:8]};
        2: char_reg = {physicaldatamem[wordaddressa0][23:16]};
        default: char_reg = {physicaldatamem[wordaddressa0][31:24]};
    endcase
    $write("%c",char_reg); //printout the first word
    while (char_reg[7:0] != 8'b0)  begin
        if (byteoffseta0 == 3) begin
            wordaddressa0 = wordaddressa0 + 1;
        end
        byteoffseta0 = byteoffseta0 + 1;
        case(byteoffseta0)
            0: char_reg = {physicaldatamem[wordaddressa0][7:0]};
            1: char_reg = {physicaldatamem[wordaddressa0][15:8]};
            2: char_reg = {physicaldatamem[wordaddressa0][23:16]};
            default: char_reg = {physicaldatamem[wordaddressa0][31:24]};
        endcase
        $write("%c",char_reg); //printout the rest
    end
    siggot = 0;
end

assign read = physicalstackmem[wordaddress]; //read

always @(negedge clk) begin //negedge write
    if (mem_write) begin
            physicalstackmem[wordaddress] <= write_data;           
    end
end


endmodule
