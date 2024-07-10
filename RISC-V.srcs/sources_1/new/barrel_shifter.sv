`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 08:25:01 PM
// Design Name: 
// Module Name: barrel_shifter
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

//TODO Paramterize it to N bits 
module barrel_shifter(
    input logic [31:0] operand,
    input logic [4:0] num_shifts,
    input logic arrithmetic, dir,
    output logic [31:0] shift_out
    );
    
    logic [31:0] stage1, stage2, stage3, stage4;
    logic sign;
    
    assign sign = operand[31];
    
    always_comb begin
        shift_out = stage4;
        stage1 = operand;
        stage2 = stage1;
        stage3 = stage2;
        stage4 = stage3;
        if(dir) begin //Shifting Left
            stage1      = num_shifts[0] ? {operand[30:0], 1'b0} : operand;
            stage2      = num_shifts[1] ? {stage1[29:0], 2'b0} : stage1;
            stage3      = num_shifts[2] ? {stage2[27:0], 4'b0} : stage2;
            stage4      = num_shifts[3] ? {stage3[23:0], 8'b0} : stage3;
            shift_out   = num_shifts[4] ? {stage4[15:0], 16'b0} : stage4;
        end
        
        else begin
            if(arrithmetic) begin //MSB Extended
                stage1      = num_shifts[0] ? {{2{sign}} ,operand[30:1]} : operand;
                stage2      = num_shifts[1] ? {{4{sign}} , stage1[30:2]} : stage1;
                stage3      = num_shifts[2] ? {{8{sign}}, stage2[30:4]} : stage2;
                stage4      = num_shifts[3] ? {{16{sign}} , stage3[30:8]} : stage3;
                shift_out   = num_shifts[4] ? {{32{sign}} , stage4[30:16]} : stage4;
            end
            
            else begin //0 Pad
                stage1      = num_shifts[0] ? {1'b0,operand[31:1]} : operand;
                stage2      = num_shifts[1] ? {2'b0,stage1[31:2]} : stage1;
                stage3      = num_shifts[2] ? {4'b0,stage2[31:4]} : stage2;
                stage4      = num_shifts[3] ? {8'b0,stage3[31:8]} : stage3;
                shift_out   = num_shifts[4] ? {16'b0,stage4[31:16]} : stage4;
            end
        end
    end
    
endmodule
