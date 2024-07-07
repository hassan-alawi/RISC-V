//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2024 12:07:38 PM
// Design Name: 
// Module Name: PC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: =
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module PC(
    input logic clk, nrst, en, load_startup_address, PC_src,
    input logic [31:0] startup_address, sign_extended_immediate,
    output logic [31:0] instruction_address
);

logic [31:0] n_instruction_address, incr_instruction_address, PC_relative_address;

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        instruction_address <= '0;
    end
    
    else begin
        instruction_address <= n_instruction_address;
    end
end

always_comb begin: NEXT_INSTRUCTION_ADDRESS_LOGIC

    n_instruction_address = instruction_address;
    incr_instruction_address = instruction_address + 32'd4;
    PC_relative_address = instruction_address + sign_extended_immediate;
    
    if(en) begin
        n_instruction_address  = load_startup_address  ? startup_address : PC_src ?  PC_relative_address : incr_instruction_address;
    end
end

endmodule