`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2024 08:23:23 PM
// Design Name: 
// Module Name: ALU_control
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


module ALU_control(
    input logic  en, funct7_5,
    input logic [1:0] ALU_op,
    input logic [2:0] funct3,
    output logic [3:0] ALU_control
    );
    
    localparam I_TYPE_OPCODE = 7'b0010011;
    localparam LW_OPCODE     = 7'b0000011;
    localparam SW_OPCODE     = 7'b0100011; 
    
    // ALU_control meaning
    // 0010: add
    // 0110: sub
    // 0000: and
    // 0001: or
    
    always_comb begin: ALU_LUT
        ALU_control = '1;
        
        if(en) begin
            case(ALU_op)
            
            2'b00: begin //lw,sw 
               ALU_control = 4'b0010;   
            end
            
            2'b01: begin //beq
                ALU_control = 4'b0110;
            end
            
            2'b10: begin //R-Type
                if(funct3 == '0 && ~funct7_5) begin //add
                    ALU_control = 4'b0010;
                end
                
                else if(funct3 == '0 && funct7_5) begin //sub
                    ALU_control = 4'b0110;
                end
                
                else if(funct3 == '1) begin //and
                    ALU_control = 4'b0000;
                end
                
                else if(funct3 == 3'b110) begin //or
                    ALU_control = 4'b0001;
                end
                
            end
            
            2'b11: begin //I_Type
                case(funct3)
                    3'h0: ALU_control = 4'b0010; //addi
                    3'h6: ALU_control = 4'b0001; //ori
                    3'h7: ALU_control = 4'b0000; //andi
                endcase
            end
            
            default: ALU_control = '1;
            
            endcase
        end
        
    end
endmodule
