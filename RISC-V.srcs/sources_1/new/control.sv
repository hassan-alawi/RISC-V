//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2024 12:07:38 PM
// Design Name: 
// Module Name: control
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

module control(
    input logic [6:0] opcode,
    output logic branch, jump, mem_to_reg, reg_write, mem_write, mem_read, ALU_src,
    output logic [1:0] ALU_op 
);

always_comb begin: CONTOL_LUT

    case(opcode)
    
    7'b0110011: begin //R-Type Instructions
        branch = 0;
        jump = 0;
        mem_to_reg = 0;
        reg_write = 1;
        mem_write = 0;
        mem_read = 0;
        ALU_src = 0;
        ALU_op = 2'b10;
    end
    
    7'b0000011: begin //lw instruction
        branch = 0;
        jump = 0;
        mem_to_reg = 1;
        reg_write = 1;
        mem_write = 0;
        mem_read = 1;
        ALU_src = 1;
        ALU_op = 2'b00;
    end
    
    7'b0100011: begin //sw instruction
        branch = 0;
        jump = 0;
        mem_to_reg = 0;
        reg_write = 0;
        mem_write = 1;
        mem_read = 0;
        ALU_src = 1;
        ALU_op = 2'b00;
    end
    
    7'b1100011: begin //beq instruction
        branch = 1;
        jump = 0;
        mem_to_reg = 0;
        reg_write = 0;
        mem_write = 0;
        mem_read = 0;
        ALU_src = 0;
        ALU_op = 2'b01;
    end
    
    7'b1101111: begin //jal instruction
        branch = 0;
        jump = 1;
        mem_to_reg = 0;
        reg_write = 0;
        mem_write = 0;
        mem_read = 0;
        ALU_src = 0;
        ALU_op = 2'b01;
    end
    
    default: begin 
        branch = 0;
        mem_to_reg = 0;
        reg_write = 0;
        mem_write = 0;
        mem_read = 0;
        ALU_src = 0;
        ALU_op = 2'b00;
    end

endcase

end

endmodule