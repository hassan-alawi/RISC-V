`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2024 02:01:43 PM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory #(parameter DEPTH = 16384, WIDTH = 32,FILE="")(
    input logic en,
    input logic [31:0] instruction_address,
    output logic [31:0] instruction     
    );
    
    logic [WIDTH-1:0] ROM [DEPTH-1:0];
    initial $readmemh(FILE, ROM);
    
    assign instruction = en ? {ROM[instruction_address],ROM[instruction_address+'d1], ROM[instruction_address+'d2], ROM[instruction_address+'d3]} : '0;
    
endmodule
