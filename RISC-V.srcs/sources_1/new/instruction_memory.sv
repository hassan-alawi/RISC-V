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


module instruction_memory #(parameter DEPTH = 4069, WIDTH = 32,FILE="")(
    input logic [WIDTH-1:0] instruction_address,
    output logic [WIDTH-1:0] instruction     
    );
    
    logic [WIDTH-1:0] ROM [DEPTH-1:0];
    initial $readmemh(FILE, ROM, 0, DEPTH-1);
    
    assign instruction = ROM[instruction_address];
    
endmodule
