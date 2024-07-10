`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2024 11:01:58 AM
// Design Name: 
// Module Name: register_file
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


module ALU(
    input logic en,
    input logic [31:0] rs1, rs2,
    input logic [4:0] ALU_control,
    output logic [31:0] result,
    output logic zero
    );
    
    // ALU_control[3:0] meaning
    // 0010: add
    // 0110: sub
    // 0000: and
    // 0001: or
    // 0011: xor
    // 0100: sll
    // 0101: srl
    // 0111: sra
    // 1000: slt
    // 1001: sltu
    
    
    //Barrel Shifter signals
    logic dir;                  //To choose between shifting right or left
    logic arrithmetic;          //To choose between arithmetic and logical shifting
    logic [31:0] shift_out;    
    
    //ALU_control[4] = negate
    assign zero = ALU_control[4] ? ~(result == '0) : result == '0;
    
    barrel_shifter bar_shift(.operand(rs1), .num_shifts(rs2[4:0]), .arrithmetic(arrithmetic), .dir(dir), .shift_out(shift_out));
    
    always_comb begin: ALU_LUT
        result = '1;
        dir = 0;
        arrithmetic = 0;
        
        if(en) begin
            case(ALU_control[3:0])
            
            4'b0010: begin
                result = rs1 + rs2;
            end
            
            4'b0110: begin
                result = rs1 - rs2;
            end
            
            4'b0011: begin
                result = rs1 ^ rs2;
            end
            
            4'b0000: begin
                result = rs1 & rs2;
            end
            
            4'b0001: begin
                result = rs1 | rs2;
            end
            
            4'b0100: begin
                dir = 1;
                arrithmetic = 0;
                result = shift_out;
            end
            
            4'b0101: begin
                dir = 0;
                arrithmetic = 0;
                result = shift_out;
            end
            
            4'b0111: begin
                dir = 0;
                arrithmetic = 1;
                result = shift_out;
            end
            
            default: result = '1;
            
            endcase
        end
        
    end
    
endmodule
