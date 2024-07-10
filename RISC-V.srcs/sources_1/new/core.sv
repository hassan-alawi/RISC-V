`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 02:38:36 PM
// Design Name: 
// Module Name: core
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


module core #(parameter 
INSTR_MEM_FILE = "C:/users/hassa/RISC-V/instruction_8.hex", 
INSTR_MEM_WIDTH = 8, 
INSTR_MEM_DEPTH = 16384,
DATA_MEM_MAP_ADR = 0,
DATA_MEM_WIDTH = 32,
DATA_MEM_DEPTH = 4096,
REG_FILE_WIDTH = 32,
REG_FILE_DEPTH = 32)
(
    input logic clk, nrst, load_startup_address, en,
    input logic [31:0] startup_address,
//    input logic [31:0] instruction,
    output logic [31:0] memory_mapped_reg
    );
    
    //PC Signals
    logic PC_src;
    logic [31:0] instruction_address, incr_instruction_address;
    
    assign PC_src = jump | (branch & zero);
    
    //Immediate Generator Signals
    logic [31:0] sign_extended_immediate;
    
    //Instruction Memory Signals
    logic [31:0] instruction;
    
    //Control Signals
    logic [6:0] opcode;
    logic branch, jump, mem_to_reg, reg_write, reg_read, mem_write, mem_read, ALU_src;
    logic [1:0] ALU_op;
    
    assign opcode = instruction[6:0];
    
    //Register File Signals
    logic [$clog2(REG_FILE_DEPTH)-1:0] read_register_1, read_register_2, write_register;
    logic [REG_FILE_WIDTH-1:0] reg_write_data, read_data_1, read_data_2;
    
    assign read_register_1 = instruction[19:15];
    assign read_register_2 = instruction[24:20];
    assign write_register = instruction[11:7];
    
    assign reg_write_data = jump ? incr_instruction_address : mem_to_reg ? mem_read_data : result;
    
    //ALU Control Signals
    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [4:0] ALU_control;
    
    assign funct7 = instruction[31:25];
    assign funct3 = instruction[14:12];
    
    //ALU Signals
    logic [31:0] rs1, rs2, result;
    logic zero;
    
    assign rs1 = read_data_1;
    assign rs2 = ALU_src ? sign_extended_immediate : read_data_2;
    
    //Data Memory Signals
    logic [31:0] data_address, mem_write_data, mem_read_data;
    
    assign data_address = result;
    assign mem_write_data = read_data_2;
    
    PC pc(
    .clk(clk), 
    .nrst(nrst), 
    .en(en), 
    .load_startup_address(load_startup_address), 
    .PC_src(PC_src),
    .startup_address(startup_address),
    .sign_extended_immediate(sign_extended_immediate),
    .instruction_address(instruction_address),
    .incr_instruction_address(incr_instruction_address)
    );
    
    
    instruction_memory #(
    .DEPTH(INSTR_MEM_DEPTH), 
    .WIDTH(INSTR_MEM_WIDTH), 
    .FILE(INSTR_MEM_FILE)) 
    ROM (
    .en(en),
    .instruction_address(instruction_address),
    .instruction(instruction)
    );
    
    
    control ctrl(
    .en(en),
    .opcode(opcode),
    .branch(branch),
    .jump(jump),
    .mem_to_reg(mem_to_reg),
    .reg_write(reg_write),
    .reg_read(reg_read),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .ALU_src(ALU_src),
    .ALU_op(ALU_op)
    );
    
    
    register_file #(
    .DEPTH(REG_FILE_DEPTH), 
    .WIDTH(REG_FILE_WIDTH))
    reg_file (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .reg_write(reg_write),
    .reg_read(reg_read),
    .read_register_1(read_register_1),
    .read_register_2(read_register_2),
    .write_register(write_register),
    .write_data(reg_write_data),
    .read_data_1(read_data_1),
    .read_data_2(read_data_2)
    );
    
    
    immediate_generator imm_gen(
    .en(en),
    .instruction(instruction),
    .sign_extended_immediate(sign_extended_immediate)
    );
    
    
    
    ALU_control alu_ctrl(
    .en(en),
    .funct7(funct7),
    .ALU_op(ALU_op),
    .funct3(funct3),
    .ALU_control(ALU_control)
    );
    
    ALU alu(
    .en(en),
    .rs1(rs1),
    .rs2(rs2),
    .ALU_control(ALU_control),
    .result(result),
    .zero(zero)
    );
    
    
    data_memory #(
    .DEPTH(DATA_MEM_DEPTH), 
    .WIDTH(DATA_MEM_WIDTH),
    .MEM_MAP_ADR(DATA_MEM_MAP_ADR))
    RAM (
    .clk(clk),
    .nrst(nrst),
    .en(en),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .address(data_address),
    .write_data(mem_write_data),
    .mem_read_data(mem_read_data),
    .mem_mapped_reg(memory_mapped_reg)
    );
    
    
endmodule
