`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 11:23:01 AM
// Design Name: 
// Module Name: tb_register_file
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


module tb_register_file();
    
localparam CLK_PERIOD = 10;
localparam WIDTH = 32;
localparam DEPTH = 32;


//INPUTS
logic tb_clk, tb_nrst, tb_reg_write;
logic [4:0] tb_read_register_1, tb_read_register_2, tb_write_register;
logic [31:0] tb_write_data;

//OUTPUTS
logic [31:0] tb_read_data_1, tb_read_data_2;

//TB Variables
integer testcases_passed, total_testcases;


register_file #(.DEPTH(DEPTH),.WIDTH(WIDTH)) DUT (
.clk(tb_clk),
.nrst(tb_nrst),
.reg_write(tb_reg_write),
.read_register_1(tb_read_register_1),
.read_register_2(tb_read_register_2),
.write_register(tb_write_register),
.write_data(tb_write_data),
.read_data_1(tb_read_data_1),
.read_data_2(tb_read_data_2)
);

task reset();
@(negedge tb_clk);
tb_nrst = 1'b0;
repeat (2) @(negedge tb_clk);
tb_nrst = 1'b1;
endtask

task check_outputs(
    input logic [31:0] expected_out_1, expected_out_2,
    input integer test_case
);

total_testcases += 2;

if(tb_read_data_1 != expected_out_1) begin $error("Incorrect value for read_data_1 during iteration: %d. Expected %d and got %d", test_case, expected_out_1, tb_read_data_1);end 
else begin testcases_passed++; end

if(tb_read_data_2 != expected_out_2) begin $error("Incorrect value for read_data_2 during iteration: %d. Expected %d and got %d", test_case, expected_out_2, tb_read_data_2);end 
else begin testcases_passed++; end

endtask


task reg_write(
    input logic [31:0] write_data,
    input logic [4:0] write_reg
);

tb_reg_write = 1;
tb_write_data = write_data;
tb_write_register = write_reg;
@(negedge tb_clk);
tb_reg_write = 0;
tb_write_data = '0;
tb_write_register = '0;

endtask


task set_read_selects(
    input logic [4:0] rs1, rs2
);
tb_read_register_1 = rs1;
tb_read_register_2 = rs2;

endtask


task init_tb();
{tb_reg_write,tb_read_register_1, tb_read_register_2, tb_write_register, tb_write_data,tb_nrst} = 'd1; //Sets everything except nrst to inactive low
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
reset();

repeat(2) @(posedge tb_clk);
@(negedge tb_clk);

for(int i = 0; i < DEPTH; i++) begin
    reg_write(i,i);
    @(negedge tb_clk);
end

for(int j = 0; j < DEPTH-1; j++) begin
    set_read_selects(j, j+1);
    @(negedge tb_clk);
    check_outputs(j, j+1, j);
    @(negedge tb_clk);
end


$display("Testcase passed: %d / %d", testcases_passed, total_testcases);
$finish;
end
endmodule
