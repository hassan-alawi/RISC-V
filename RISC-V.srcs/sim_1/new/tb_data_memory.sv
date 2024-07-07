`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 02:18:28 PM
// Design Name: 
// Module Name: tb_data_memory
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


module tb_data_memory( );
    
localparam CLK_PERIOD = 10;
localparam WIDTH = 32;
localparam DEPTH = 4096;


//INPUTS
logic tb_clk, tb_nrst, tb_mem_read, tb_mem_write;
logic [31:0] tb_write_data, tb_address;

//OUTPUTS
logic [31:0] tb_mem_read_data;

//TB Variables
integer testcases_passed, total_testcases;


data_memory #(.DEPTH(DEPTH),.WIDTH(WIDTH)) DUT (
.clk(tb_clk),
.nrst(tb_nrst),
.mem_write(tb_mem_write),
.mem_read(tb_mem_read),
.write_data(tb_write_data),
.address(tb_address),
.mem_read_data(tb_mem_read_data)
);

task reset();
@(negedge tb_clk);
tb_nrst = 1'b0;
repeat (2) @(negedge tb_clk);
tb_nrst = 1'b1;
endtask

task check_outputs(
    input logic [31:0] expected_out,
    input integer test_case
);

total_testcases += 1;

if(tb_mem_read_data != expected_out) begin $error("Incorrect value for mem_read_data during iteration: %d. Expected %d and got %d", test_case, expected_out, tb_mem_read_data);end 
else begin testcases_passed++; end

endtask


task mem_write(
    input logic [31:0] write_data,
    input logic [31:0] address
);

tb_mem_write = 1;
tb_write_data = write_data;
tb_address = address;
@(negedge tb_clk);
tb_mem_write = 0;
tb_write_data = '0;
tb_address = '0;

endtask


task mem_read(
    input logic [31:0] address, expected_out,
    integer iteration
);

tb_mem_read = 1;
tb_address = address;
@(negedge tb_clk);
check_outputs(expected_out, iteration);
@(negedge tb_clk);
tb_mem_read = 0;
tb_address = '0;

endtask


task init_tb();
{tb_mem_write, tb_mem_read, tb_address, tb_write_data,tb_nrst} = 'd1; //Sets everything except nrst to inactive low
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
    mem_write(i,i);
    @(negedge tb_clk);
end

for(int j = 0; j < DEPTH-1; j++) begin
    mem_read(j, j, j);
    @(negedge tb_clk);
end


$display("Testcase passed: %d / %d", testcases_passed, total_testcases);
$finish;
end
endmodule