`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 07:35:24 PM
// Design Name: 
// Module Name: tb_core
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
module tb_core();
`include "line_count.vh"

//Core Configuration Parameters
localparam INSTR_MEM_FILE = "C:/users/hassa/RISC-V/instruction_8.hex"; 
localparam INSTR_MEM_WIDTH = 8;
localparam INSTR_MEM_DEPTH = 16384;
localparam DATA_MEM_MAP_ADR = 10;
localparam DATA_MEM_WIDTH = 32;
localparam DATA_MEM_DEPTH = 4096;
localparam REG_FILE_WIDTH = 32;
localparam REG_FILE_DEPTH = 32;

//Test-bench Parameters
localparam CLK_PERIOD = 10;
localparam INSTR_COUNT_PATH = "C:/users/hassa/RISC-V/line_count.txt"; 
localparam NUM_LOOPS = 1;

//OPCODES
localparam R_TYPE_OPCODE = 7'b0110011;
localparam I_TYPE_OPCODE = 7'b0010011;
localparam LW_OPCODE     = 7'b0000011; //To be used with I-Type generator task
localparam SW_OPCODE     = 7'b0100011; //To be used with S-Type generator task
localparam BEQ_OPCODE    = 7'b1100011; //To be used with SB-Type generator task
localparam JAL_OPCODE    = 7'b1101111; //To be used with UJ-Type generator task

//FUNCT3
localparam ADD_FUNCT3 = 3'h0;
localparam SUB_FUNCT3 = 3'h0;
localparam OR_FUNCT3  = 3'h6;
localparam AND_FUNCT3 = 3'h7;
localparam LW_FUNCT3  = 3'h2;
localparam SW_FUNCT3  = 3'h2;
localparam BEQ_FUNCT3 = 3'h0;

//FUNCT7
localparam ADD_FUNCT7 = 7'h00;
localparam SUB_FUNCT7 = 7'h20;
localparam OR_FUNCT7  = 7'h00;
localparam AND_FUNCT7 = 7'h00;

//INPUTS
logic tb_clk, tb_nrst, tb_load_startup_address, tb_en;
logic [31:0] tb_instruction, tb_startup_address;

//OUTPUTS
logic [31:0] tb_memory_mapped_reg;

//TB Variables
integer testcases_passed, total_testcases, done_writing;
int fd;

logic [31:0] tb_expected_out;


core #(
.INSTR_MEM_FILE(INSTR_MEM_FILE), 
.INSTR_MEM_WIDTH(INSTR_MEM_WIDTH), 
.INSTR_MEM_DEPTH(INSTR_MEM_DEPTH),
.DATA_MEM_MAP_ADR(DATA_MEM_MAP_ADR),
.DATA_MEM_WIDTH(DATA_MEM_WIDTH),
.DATA_MEM_DEPTH(DATA_MEM_DEPTH),
.REG_FILE_WIDTH(REG_FILE_WIDTH),
.REG_FILE_DEPTH(REG_FILE_DEPTH)
) backend_cpu (
.clk(tb_clk),
.nrst(tb_nrst),
.en(tb_en),
.load_startup_address(tb_load_startup_address),
.startup_address(tb_startup_address),
//.instruction(tb_instruction),
.memory_mapped_reg(tb_memory_mapped_reg)
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

if(tb_memory_mapped_reg != expected_out) begin $error("Incorrect value for mem_mapped_reg during iteration: %d. Expected %d and got %d", test_case, expected_out, tb_memory_mapped_reg);end 
else begin
$info("Correct value for mem_mapped_reg during iteration: %d. Expected %d and got %d", test_case, expected_out, tb_memory_mapped_reg); 
testcases_passed++; 
end

endtask

task toggle_en();
    tb_en = ~tb_en;
endtask


task init_tb();
{tb_load_startup_address, tb_en, tb_instruction, tb_startup_address, tb_nrst} = 'd1; //Sets everything except nrst to inactive low
endtask


task generate_R_type(
    input logic [6:0] opcode,
    input logic [4:0] rs1, rs2, rd,
    input logic [2:0] funct3,
    input logic [6:0] funct7
);

    #(0.05 * CLK_PERIOD);
    
    tb_instruction = {funct7, rs2, rs1, funct3, rd, opcode};
    @(posedge tb_clk);
endtask


task generate_I_type(
    input logic [6:0] opcode,
    input logic [4:0] rs1, rd,
    input logic [2:0] funct3,
    input logic [11:0] imm
);

    #(0.05 * CLK_PERIOD);
    
    tb_instruction = {imm, rs1, funct3, rd, opcode};
    @(posedge tb_clk);
endtask


task generate_S_type(
    input logic [6:0] opcode,
    input logic [4:0] rs1, rs2,
    input logic [2:0] funct3,
    input logic [11:0] imm
);

    #(0.05 * CLK_PERIOD);
    
    tb_instruction = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode};
    @(posedge tb_clk);
endtask


task generate_SB_type(
    input logic [6:0] opcode,
    input logic [4:0] rs1, rs2,
    input logic [2:0] funct3,
    input logic [12:0] imm
);

    #(0.05 * CLK_PERIOD);
    
    tb_instruction = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode};
    @(posedge tb_clk);
endtask


task generate_U_type(
    input logic [6:0] opcode,
    input logic [4:0] rd,
    input logic [31:0] imm
);

    #(0.05 * CLK_PERIOD);
    
    tb_instruction = {imm[31:12], rd, opcode};
    @(posedge tb_clk);
endtask


task generate_UJ_type(
    input logic [6:0] opcode,
    input logic [4:0] rd,
    input logic [20:0] imm
);

    #(0.05 * CLK_PERIOD);
    
    tb_instruction = {imm[20],imm[10:1], imm[11], imm[19:12], rd, opcode};
    @(posedge tb_clk);
endtask

task generate_NULL();

    #(0.05 * CLK_PERIOD);
    
    tb_instruction = '0;
    @(posedge tb_clk);
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
tb_expected_out = '0;

init_tb();
reset();

@(posedge tb_clk);
#(0.05 * CLK_PERIOD);
toggle_en();
repeat(NUM_LOOPS * NUM_INSTRUCTIONS) @(posedge tb_clk);
#(0.05 * CLK_PERIOD);

tb_expected_out = 'd1000;
check_outputs(tb_expected_out,1);

$finish;
end
endmodule