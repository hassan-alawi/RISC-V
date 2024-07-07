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
    input logic [31:0] rs1, rs2,
    input logic [3:0] ALU_control,
    output logic [31:0] result,
    output logic zero
    );
    
    // ALU_control meaning
    // 0010: add
    // 0110: sub
    // 0000: and
    // 0001: or
    
    assign zero = result == '0;
    
    always_comb begin: ALU_LUT
    
        case(ALU_control)
        
        4'b0010: begin
            result = rs1 + rs2;
        end
        
        4'b0110: begin
            result = rs1 - rs2;
        end
        
        4'b0000: begin
            result = rs1 & rs2;
        end
        
        4'b0001: begin
            result = rs1 | rs2;
        end
        
        default: result = '1;
        
        endcase
        
    end
    
endmodule
