`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2024 09:35:21 PM
// Design Name: 
// Module Name: tb_instruction_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_instruction_memory();

localparam CLK_PERIOD = 10;
localparam WIDTH = 8;
localparam DEPTH = 16384;
localparam FILE = "C:/users/hassa/RISC-V/RISC-V.srcs/sources_1/new/instruction.mem";


//INPUTS
logic tb_clk;
logic [31:0] tb_instruction_address;

//OUTPUTS
logic [31:0] tb_instruction;

//TB Signal
logic done_writing;
int fd;

instruction_memory #(.WIDTH(WIDTH), .DEPTH(DEPTH), .FILE(FILE))DUT (
.instruction_address(tb_instruction_address),
.instruction(tb_instruction));


task init_tb();
{tb_instruction_address} = 'd0;
endtask


always begin
tb_clk = 0;
#(CLK_PERIOD / 2);
tb_clk = 1;
#(CLK_PERIOD / 2);
end

initial begin
    fd = $fopen(FILE, "w");
    done_writing = 0;
    if(fd) begin
        $display("Opened %s file succesfully", FILE);
        for(integer j = 0; j < DEPTH; j++)begin
            $fdisplay(fd, "%X", j);
        end
        
        $fclose(fd);
        done_writing = 1;
    end
    
    else begin
        $display("Failed to open %s file", FILE);
        $fclose(fd);
        done_writing = 1;
    end
    
    
    
end

initial begin
integer testcases_passed = 4096;
integer total_testcases = testcases_passed;

while(~done_writing);

init_tb();

repeat(2) @(posedge tb_clk);
@(negedge tb_clk);

for(integer i = 0; i < DEPTH; i++)begin 
    tb_instruction_address = i;
    @(negedge tb_clk);
    if(tb_instruction != i) begin $error("Incorrect instruction at address %x. Expected: %x, got %x", i,i,tb_instruction_address); testcases_passed--;end;
end

$display("Testcase passed: %d / %d", testcases_passed, total_testcases);
$finish;
end
endmodule