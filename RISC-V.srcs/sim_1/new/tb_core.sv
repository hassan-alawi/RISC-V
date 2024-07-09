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


//Core Configuration Parameters
localparam INSTR_MEM_FILE = "C:/users/hassa/RISC-V/instruction_8.hex"; 
localparam INSTR_MEM_WIDTH = 8;
localparam INSTR_MEM_DEPTH = 16384;
localparam DATA_MEM_MAP_ADR = 1;
localparam DATA_MEM_WIDTH = 32;
localparam DATA_MEM_DEPTH = 4096;
localparam REG_FILE_WIDTH = 32;
localparam REG_FILE_DEPTH = 32;

//Test-bench Parameters
localparam CLK_PERIOD = 10;
localparam INSTR_COUNT_PATH = "C:/users/hassa/RISC-V/line_count.txt"; 

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
integer testcases_passed, total_testcases, done_writing, num_instructions;
int fd;


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
    fd = $fopen(INSTR_COUNT_PATH, "r");
    num_instructions = 0;
    done_writing = 0;
    if(fd) begin
        $display("Opened %s file succesfully", INSTR_COUNT_PATH);
        $fgets(num_instructions, fd);
        $fclose(fd);
        done_writing = 1;
    end
    
    else begin
        $display("Failed to open %s file", INSTR_COUNT_PATH);
        $fclose(fd);
        done_writing = 1;
    end
    
    
    
end

initial begin
testcases_passed = 0;
total_testcases = 0;
while(done_writing == 0);
num_instructions -= 48;

init_tb();
reset();

@(posedge tb_clk);
#(0.05 * CLK_PERIOD);
toggle_en();
repeat(num_instructions) @(posedge tb_clk);
#(0.05 * CLK_PERIOD);
//toggle_en();
//@(negedge tb_clk);
//toggle_en();
//@(posedge tb_clk);

////Test Case: ADDI -> ADDI -> ADD -> SW
//generate_I_type(I_TYPE_OPCODE,5'd0,5'd1,ADD_FUNCT3,12'h010); //addi x1, x0, 16
//generate_I_type(I_TYPE_OPCODE,5'd0,5'd2,ADD_FUNCT3,12'h004); //addi x2, x0, 4
//generate_R_type(R_TYPE_OPCODE,5'd2,5'd1,5'd3, ADD_FUNCT3, ADD_FUNCT7); //add x3, x2, x1
//generate_S_type(SW_OPCODE,5'd0,5'd3, SW_FUNCT3,12'h001); //sw x3 1(x0)

//generate_NULL();
//check_outputs(32'd20,1);

////Test Case: ADDI -> ORI -> SUB -> SW -> LW -> ANDI -> SW
//reset();

//repeat(2) @(posedge tb_clk);
//@(posedge tb_clk);

//generate_I_type(I_TYPE_OPCODE,5'd0,5'd1,ADD_FUNCT3,12'h010); //addi x1, x0, 16
//generate_I_type(I_TYPE_OPCODE,5'd1,5'd2,OR_FUNCT3,12'h008); //ori x2, x1, 008
//generate_R_type(R_TYPE_OPCODE,5'd2,5'd1,5'd3, SUB_FUNCT3, SUB_FUNCT7); //sub x3, x2, x1
//generate_S_type(SW_OPCODE,5'd0,5'd3, SW_FUNCT3,12'h000); //sw x3 0(x0)
//generate_I_type(LW_OPCODE,5'd0,5'd4,LW_FUNCT3,12'h000); //lw x4 0(x0)
//generate_I_type(I_TYPE_OPCODE,5'd4,5'd5,AND_FUNCT3,12'hFFF); //andi x5, x4, FFF
//generate_S_type(SW_OPCODE,5'd0,5'd5, SW_FUNCT3,12'h001); //sw x5 1(x0)

//generate_NULL();
//check_outputs(32'd8, 1);
//toggle_en();

////Test Case: Jal 
//reset();

//repeat(2) @(posedge tb_clk);
//toggle_en();

//generate_UJ_type(JAL_OPCODE, 5'd1, 21'h000008); //jal x1, 8
//generate_UJ_type(JAL_OPCODE, 5'd1, 21'hFFFFF8); //jal x1, -8

//generate_NULL();

//toggle_en();

////Test Case: ADDI -> ADDI -> ADDI -> AND -> OR -> BEQ
//reset();

//repeat(2) @(posedge tb_clk);
//toggle_en();

//generate_I_type(I_TYPE_OPCODE,5'd0,5'd1,ADD_FUNCT3,12'hFFF); //addi x1, x0, -1
//generate_I_type(I_TYPE_OPCODE,5'd0,5'd2,ADD_FUNCT3,12'h555); //addi x2, x0, 0x555
//generate_R_type(R_TYPE_OPCODE,5'd2,5'd1,5'd3, AND_FUNCT3, AND_FUNCT7); //and x3, x2, x1
//generate_R_type(R_TYPE_OPCODE,5'd2,5'd1,5'd4, OR_FUNCT3, OR_FUNCT7); //or x4, x2, x1
//generate_SB_type(BEQ_OPCODE,5'd4,5'd1, BEQ_FUNCT3, 13'hFFF0); //beq x4, x1, -16

//generate_NULL();



//$display("Testcase passed: %d / %d", testcases_passed, total_testcases);
$finish;
end
endmodule