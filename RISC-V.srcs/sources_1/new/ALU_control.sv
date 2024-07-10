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
    input logic  en,
    input logic [1:0] ALU_op,
    input logic [6:0] funct7,
    input logic [2:0] funct3,
    output logic [4:0] ALU_control
    );
    
    localparam I_TYPE_OPCODE = 7'b0010011;
    localparam LW_OPCODE     = 7'b0000011;
    localparam SW_OPCODE     = 7'b0100011; 
    
    // ALU_control meaning
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
    
    always_comb begin: ALU_LUT
        ALU_control = '1;
        
        if(en) begin
            case(ALU_op)
            
            2'b00: begin //lw,sw 
               ALU_control = 5'b00010;   
            end
            
            2'b01: begin //beq
                ALU_control = 5'b00110;
            end
            
            2'b10: begin //R-Type
                if(funct3 == '0 && ~funct7[5]) begin //add
                    ALU_control = 5'b00010;
                end
                
                else if(funct3 == '0 && funct7[5]) begin //sub
                    ALU_control = 5'b00110;
                end
                
                else if(funct3 == '1) begin //and
                    ALU_control = 5'b00000;
                end
                
                else if(funct3 == 3'h4) begin //or
                    ALU_control = 5'b00001;
                end
                
                else if(funct3 == 3'h4) begin //xor
                    ALU_control = 5'b00011;
                end
                
                else if(funct3 == 3'h1) begin //sll
                    ALU_control = 5'b00100;
                end
                
                else if(funct3 == 3'h5 && ~funct7[5]) begin //srl
                    ALU_control = 5'b00101;
                end
                
                else if(funct3 == 3'h5 && funct7[5]) begin //sra
                    ALU_control = 5'b00111;
                end
                
            end
            
            2'b11: begin //I_Type
                case(funct3)
                    3'h0: ALU_control = 5'b00010; //addi
                    3'h6: ALU_control = 5'b00001; //ori
                    3'h7: ALU_control = 5'b00000; //andi
                endcase
            end
            
            default: ALU_control = '1;
            
            endcase
        end
        
    end
endmodule
