`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2024 08:22:48 PM
// Design Name: 
// Module Name: imeddiate_generator
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


module immediate_generator(
    input logic en,
    input logic [31:0] instruction,
    output logic [31:0] sign_extended_immediate
    );
    
    logic [6:0] opcode;
    assign opcode = instruction[6:0];
    
    always_comb begin: IMMEDIATE_LUT
        sign_extended_immediate = 32'd0;
        
        if(en) begin
            case(opcode)
            
            7'b0110011: begin //R-Type Instructions
                sign_extended_immediate = 32'd0;
            end
            
            7'b0010011: begin //I-Type instruction
                sign_extended_immediate = instruction[31] ? {21'hFFFFFF,instruction[30:20]} : {21'h000000,instruction[30:20]};
            end
            
            7'b0000011: begin //lw instruction
                sign_extended_immediate = instruction[31] ? {21'hFFFFFF,instruction[30:20]} : {21'h000000,instruction[30:20]};
            end
            
            7'b0100011: begin //sw instruction
                sign_extended_immediate = instruction[31] ? {21'hFFFFFF,instruction[30:25], instruction[11:7]} : {21'h000000,instruction[30:25], instruction[11:7]};
            end
            
            7'b1100011: begin //beq and SB-Type instruction 
                sign_extended_immediate = instruction[31] ? {20'hFFFFF, instruction[7], instruction[30:25], instruction[11:8], 1'b0} : {20'h00000, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            
            7'b1101111: begin //jal and UJ-Type instruction
                sign_extended_immediate = instruction[31] ? {12'hFFF, instruction[19:12], instruction[20], instruction[30:21], 1'b0} : {12'h000, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            
            7'b0101111: begin //lui and U-Type instruction
                sign_extended_immediate = {instruction[31:12], 12'b0};
            end
            
            default: begin 
                sign_extended_immediate = 32'd0;
            end
            
            endcase
        end
        
    end
endmodule
