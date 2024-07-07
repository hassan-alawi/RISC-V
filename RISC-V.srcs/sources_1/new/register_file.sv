`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2024 11:01:58 AM
// Design Name: 
// Module Name: ALU
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


module register_file #(DEPTH = 32, WIDTH = 32)(
    input logic clk, nrst, reg_write,
    input logic [$clog2(DEPTH)-1:0] read_register_1, read_register_2, write_register,
    input logic [WIDTH-1:0] write_data,
    output logic [WIDTH-1:0] read_data_1, read_data_2
    );
    
    logic [DEPTH-1:0][WIDTH-1:0] registers, n_registers;
    
    always_ff @(posedge clk, negedge nrst) begin
        if(~nrst) begin
            registers[DEPTH-1:0] <= '0;
        end
        
        else begin
            registers <= n_registers;
        end
    end    
    
    assign read_data_1 = registers[read_register_1];
    assign read_data_2 = registers[read_register_2];
    
    always_comb begin: NEXT_REGISTER_FILE_LOGIC
    
        n_registers = registers;
        
        if(reg_write) begin
            n_registers[write_register] = write_data;
        end
        
        else begin
            n_registers = registers;
        end
    
    end
endmodule
