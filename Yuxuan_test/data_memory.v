/*
 * data memory
 * from Harris & Harris P. 439
 */

module data_memory (
    input clk,
    //input mem_write, byteOp,       // write enable, is byte operation
    input [31:0] a,         // byte address
    input [31:0] write_data,        // data to write the memory
    input mem_write,
    input mem_read,
    input [31:0] a0,        // hack to get string address
    output [31:0] rd,       // data read from memory 
    output [31:0] char,     // hack to read string contents
    input SyscallW
);


// Word addresses, size = 0xff = 256 for both stack and instr/data segments
parameter STACK_END = 32'hffff_ffff >> 2;
parameter STACK_BEGIN = 32'hffff_f000 >> 2;

parameter DATA_BEGIN = 32'h0040_0000 >> 2;
parameter DATA_SEG = 32'h0041_0200 >> 2;
parameter DATA_END = 32'h0041_0f00 >> 2;


reg [31:0] RAM [DATA_END: DATA_BEGIN];      // like 255:0
reg [31:0] Stack [STACK_BEGIN: STACK_END];

parameter MONITOR = 0;
integer i, j, f1, f2, p;
initial begin
    //!if (MONITOR) begin
        //!f1 = $fopen("data.csv", "w");
        //!f2 = $fopen("stack.csv", "w");
    //!end 
    //$monitor($time, "dm monitor: ALUoutM = %x, writeData = %x,readDataM = %x, Bytes = %x wa=%x mem_write = %x mem_read = %x value=%x",a,write_data,rd,char,wa,mem_write,mem_read,Stack[32'h3ffffffe]); 
    $readmemh("hello.v", RAM);
    for (p = DATA_SEG; p < DATA_END; p++)
        RAM[p] <= 32'b0;

    
end


// doesn't matter which syscall
// return the bytes anyways
assign char = char_reg;
reg [8:0] char_reg;
// reg [31:0] word_reg;
reg printSig = 0;
// integer x, z;

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
    // $write("HEX:%x\n", sysbo);
    // char_reg = {24'b0, RAM[syswa]}; 
    // word_reg = RAM[x[31:2]];
    // $write("WORD: %s, %x\n", word_reg, word_reg);
    while (char_reg[7:0] != 8'b0)  begin
    // while (word_reg != 0)  begin
        // for (i=0; i < 4; i++) begin
        //     #2;// $display("x= %x i=%d",x,  i);
        //     if (i == 0)
        //         //if (RAM[x[31:2]][7:0] != 8'b0)
        //             char_reg  = {i, RAM[x[31:2]][7:0]};
        //         //else begin
        //         //    char_reg = NEWLINE;
        //         //end
        //     else
        //         if (i == 1)
        //             //if (RAM[x[31:2]][15:8] != 8'b0)
        //                 char_reg  = {i, RAM[x[31:2]][15:8]};
        //             //else begin
        //              //   char_reg = NEWLINE;
        //             //end
        //         else
        //             if (i == 2)
        //                 //if (RAM[x[31:2]][23:16] != 8'b0)
        //                     char_reg = {i, RAM[x[31:2]][23:16]};
        //                 //else begin
        //                  //   char_reg = NEWLINE;
        //                 //end
        //             else
        //                 if (i == 3)
        //                     //if (RAM[x[31:2]][31:24] != 8'b0)
        //                         char_reg = {i, RAM[x[31:2]][31:24]};
        //                     //else begin
        //                     //    char_reg = NEWLINE;
        //                     //end
        // end
        #5;
        // $write("HEX:%x\n", char_reg);
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
        // x = x + 4; // advance word address
        
        // $write("HEX:%x WORD:%s\n", char_reg, char_reg);
    end
    // $write("HEX:%x HEX:%x\n", RAM[32'h001041b3], RAM[32'h001041b3 + 1]);
    // char_reg = {23'b0, printSig, RAM[syswa][7:0]};
    
end

// get word address to access data or stack
wire [31:0] wa;
assign wa = {2'b00, a[31:2]};
//get word offset to write/load byte
wire [1:0] bo;
assign bo = a[1:0];

reg [31:0] word2Write;

// read something out whether you like it or not :P
// assign rd = RAM[a]; // word aligned
assign rd = Stack[wa];//(wa <= STACK_END && wa >= STACK_BEGIN)? Stack[wa] :
            //(wa <= DATA_END && wa >= DATA_BEGIN)? RAM[wa]: 32'hxxxxxxxx;

always @(negedge clk) begin// TODO why clk
    $display($time,"Write Attempt %x %x %x %x",wa,a,mem_write,write_data);
    // if write, then write to memory
    if (mem_write) begin
        //!if(byteOp)begin
            // if (wa <= STACK_END && wa >= STACK_BEGIN)
            //     Stack[wa] <= write_data;
            // else if (wa <= DATA_END && wa >= DATA_BEGIN)
            //     RAM[wa] <= write_data;
            //!case(bo)
                //!3: word2Write = {write_data[7:0], rd[23:0]};
                //!2: word2Write = {rd[31:24], write_data[7:0], rd[15:0]};
                //!1: word2Write = {rd[31:16], write_data[7:0], rd[7:0]};
                //!0: word2Write = {rd[31:8], write_data[7:0]};
            //!endcase
            // word2Write = {rd[31:8], write_data[7:0]};
        //end
        //!else begin
            // if (wa <= STACK_END && wa >= STACK_BEGIN)
            //     Stack[wa] <= write_data;
            // else if (wa <= DATA_END && wa >= DATA_BEGIN)
            //     RAM[wa] <= write_data;
       // word2Write <= write_data;
        //!end
	$display($time,"Write Attempt %x %x %x %x",wa,STACK_END,STACK_BEGIN,word2Write);
        if (wa <= STACK_END && wa >= STACK_BEGIN)
	begin
            Stack[wa] <= write_data;
	    $display($time,"Write Success %x %x",word2Write,wa);
end
        else 
            if (wa <= DATA_END && wa >= DATA_BEGIN)
                RAM[wa] <= write_data;   
            else 
                if (wa > STACK_END)   begin
                    $display("Stack overflow");
                    //$finish;
                end  else
                    if (wa >DATA_END) begin
                        $display("Data segment overflow");
                        //$finish;
                    end
            
    end
    // $display($time, "\tmem", a, a[31:2]);
    //if (MONITOR) begin
        //$fwrite(f1, $time, "\n");
        //for (i = DATA_SEG; i <= DATA_END; i = i + 1) begin
            //$fwrite(f1, "\t%04x:%08x", 4 * i, RAM[i]);
            //if (i % 8 == 7) begin
                //$fwrite(f1, "\n");
            //end
        //end
        //$fwrite(f1, "\n");

        //$fwrite(f2, $time, "\n");
        //for (j = STACK_BEGIN; j <= STACK_END; j = j + 1) begin
            //$fwrite(f2, "\t%04x:%08x", 4 * j, Stack[j]);
            //if (j % 8 == 7) begin
                //$fwrite(f2, "\n");
            //end
        //end
        //$fwrite(f2, "\n");
    //end
end


endmodule
