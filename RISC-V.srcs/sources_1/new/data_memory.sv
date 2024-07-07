//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2024 12:07:38 PM
// Design Name: 
// Module Name: data_memory
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

module data_memory #(DEPTH = 4096, WIDTH = 8)(
    input logic clk, nrst, en, mem_read, mem_write,
    input logic [31:0] address, write_data,
    output logic [31:0] mem_read_data
);

    logic [WIDTH-1:0] RAM [DEPTH-1:0];
    logic [WIDTH-1:0] n_RAM [DEPTH-1:0];
    
     always_ff @(posedge clk, negedge nrst) begin
        if(~nrst) begin
            for(int i = 0; i < DEPTH; i++) begin RAM[i] <= '0;end
        end
        
        else begin
            RAM <= n_RAM;
        end
    end
    
    always_comb begin: NEXT_MEMORY_LOGIC
        mem_read_data = mem_read & en ? RAM[address] : '0;
        n_RAM = RAM;
        
        if(mem_write & en) begin n_RAM[address] = write_data; end
    end
    
    
endmodule