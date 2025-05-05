/*
Control Unit
    - Decodes opcode
    - Generates control signals for datapath

R_TYPE      = 7'b0110011;
I_TYPE      = 7'b0010011;
S_TYPE      = 7'b0100011;
U_TYPE1     = 7'b0110111;
U_TYPE2     = 7'b0010111;
J_TYPE      = 7'b1101111;

*/
import all_pkgs::*;

module control_unit (
    input logic [6:0] opcode,

    output logic        reg_wr_en,
    output logic        alu_src,        // 0 = reg (R-type), 1 = imm (I-type)
    output logic        mem_wr_en,
    output logic        mem_rd_en,
    output logic        mem_to_reg      // 0 = ALU result, 1 = MEM data
);

// TODO: Implement control logic based on opcode
always_comb begin 
    // Default values
    reg_wr_en   = 0;
    alu_src     = 0;
    mem_wr_en   = 0;
    mem_rd_en   = 0;
    mem_to_reg  = 0;
    case (opcode)
        R_TYPE : begin
            reg_wr_en   = 1;
            alu_src     = 0;        
        end 
        I_TYPE: begin
            reg_wr_en   = 1;    
            alu_src     = 1;    
        end 
        I_LOAD : begin
            reg_wr_en   = 1;
            alu_src     = 1;
            mem_rd_en   = 1;
            mem_to_reg  = 1; 
        end
        S_TYPE: begin
            mem_wr_en   = 1;
            alu_src     = 1;  
        end
        I_LOAD: begin
            alu_src     = 1;
            reg_wr_en   = 1;
            mem_rd_en   = 1;
            mem_to_reg  = 1;
        end
    endcase 
end
    
endmodule