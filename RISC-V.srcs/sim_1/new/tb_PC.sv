`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2024 08:39:49 PM
// Design Name: 
// Module Name: tb_PC
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


module tb_PC();

localparam CLK_PERIOD = 10;


//INPUTS
logic tb_clk, tb_nrst, tb_load_startup_address, tb_PC_src;
logic [31:0] tb_startup_address, tb_sign_extended_immediate;

//OUTPUTS
logic [31:0] tb_instruction_address;

PC DUT (
.clk(tb_clk), 
.nrst(tb_nrst), 
.load_startup_address(tb_load_startup_address),
.PC_src(tb_PC_src),
.startup_address(tb_startup_address),
.sign_extended_immediate(tb_sign_extended_immediate),
.instruction_address(tb_instruction_address));

task reset();
@(negedge tb_clk);
tb_nrst = 1'b0;
repeat (2) @(negedge tb_clk);
tb_nrst = 1'b1;
endtask


task initiate_startup(
    input logic [31:0] startup_address
);

tb_load_startup_address = 1;
tb_startup_address = startup_address;
@(negedge tb_clk);
tb_load_startup_address = 0;
tb_startup_address = '0;

endtask


task set_PC_src(
    input logic PC_src
);
tb_PC_src = PC_src;

endtask


task set_immediate(
    input logic [31:0] immediate
);

tb_sign_extended_immediate = immediate;

endtask


task init_tb();
{tb_load_startup_address, tb_PC_src, tb_startup_address, tb_sign_extended_immediate,tb_nrst} = 'd1; //Sets everything except nrst to inactive low
endtask


always begin
tb_clk = 0;
#(CLK_PERIOD / 2);
tb_clk = 1;
#(CLK_PERIOD / 2);
end

initial begin
integer testcases_passed = 4;
integer total_testcases = testcases_passed;

init_tb();
reset();

repeat(2) @(posedge tb_clk);
@(negedge tb_clk);

initiate_startup(32'hDEADBEEF);

if(tb_instruction_address != 32'hDEADBEEF) begin $error("Incorrect instruction address after load startup instruction sequence"); testcases_passed--;end;

@(negedge tb_clk);

if(tb_instruction_address != (32'hDEADBEEF + 32'd4)) begin $error("Incorrect instruction address after increment of startup instruction"); testcases_passed--;end;

set_immediate(~(32'd4) + 32'd1);
set_PC_src(1);

@(negedge tb_clk);
if(tb_instruction_address != 32'hDEADBEEF) begin $error("Incorrect instruction address after pc relative addressing sequence"); testcases_passed--;end;

initiate_startup(32'hABABABAB);
if(tb_instruction_address != 32'hABABABAB) begin $error("Incorrect instruction address while testing load priority"); testcases_passed--;end;

$display("Testcase passed: %d / %d", testcases_passed, total_testcases);
$finish;
end
endmodule
