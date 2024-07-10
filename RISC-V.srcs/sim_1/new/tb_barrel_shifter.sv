`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 09:18:13 PM
// Design Name: 
// Module Name: tb_barrel_shifter
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


module tb_barrel_shifter();
    
localparam CLK_PERIOD = 10;

logic tb_clk;
//INPUTS
logic [31:0] tb_operand;
logic [31:0] tb_num_shifts;
logic tb_arrithmetic, tb_dir;

//OUTPUTS
logic [31:0] tb_shift_out;

//TB Variables
integer testcases_passed, total_testcases;
int tb_expected_out; 


barrel_shifter DUT (
.operand(tb_operand),
.num_shifts(tb_num_shifts[4:0]),
.arrithmetic(tb_arrithmetic),
.dir(tb_dir),
.shift_out(tb_shift_out)
);


task check_outputs(
    input int expected_out,
    input integer test_case, 
    input int operand, num_shifts
);

total_testcases += 1;

if(tb_shift_out != expected_out) begin $error("Incorrect value for shift_out during iteration: %d. Expected %d and got %d. Inputs: Operand: %d, Number of Shifts: %d", test_case, expected_out, tb_shift_out, operand, num_shifts);end 
else begin testcases_passed++; end

endtask


task set_mode(
    input logic [1:0] mode
);

    tb_dir = mode[0];
    tb_arrithmetic = mode[1];

endtask

task init_tb();
{tb_operand, tb_arrithmetic, tb_dir, tb_num_shifts} = 'd0; 
endtask


always begin
tb_clk = 0;
#(CLK_PERIOD / 2);
tb_clk = 1;
#(CLK_PERIOD / 2);
end

initial begin
testcases_passed = 0;
total_testcases = 0;

init_tb();

repeat(2) @(posedge tb_clk);
@(negedge tb_clk);

set_mode(2'd0); //srl

for(integer j = -64; j < 64; j++)begin
    tb_operand = j;
    for(integer i = 0; i < 32; i++) begin
        tb_num_shifts = i;
        tb_expected_out = j >> i;
        #(0.14 * CLK_PERIOD);
        check_outputs(tb_expected_out, 4*(j-32)+i, j, i);
        @(negedge tb_clk);
    end
end

set_mode(2'd2); //sra

for(integer j = -64; j < 64; j++)begin
    tb_operand = j;
    for(integer i = 0; i < 32; i++) begin
        tb_num_shifts = i;
        tb_expected_out = j >>> i;
        #(0.14 * CLK_PERIOD);
        check_outputs(tb_expected_out, 32*((-j)-32)+i, j, i);
        @(negedge tb_clk);
    end
end

set_mode(2'd1); //sll
for(integer j = -64; j < 64; j++)begin
    tb_operand = j;
    for(integer i = 0; i < 32; i++) begin
        tb_num_shifts = i;
        tb_expected_out = j << i;
        #(0.14 * CLK_PERIOD);
        check_outputs(tb_expected_out, 4*(j-32)+i, j, i);
        @(negedge tb_clk);
    end
end



$display("Testcase passed: %d / %d", testcases_passed, total_testcases);
$finish;
end
endmodule