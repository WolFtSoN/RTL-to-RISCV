/*
Purpose:
    The control unit generates all necessary control signals based on the instruction's `opcode` and optionally `funct3`
    - `reg_wr_en`   — write to register file
    - `alu_src`     — select between immediate and register operand
    - `mem_wr_en`   — store enable
    - `mem_rd_en`   — load enable
    - `mem_to_reg`  — choose ALU result or memory data for writeback
    - `wb_sel`      — to select between ALU, MEM, or PC+4
*/

import all_pkgs::*;

module control_unit (
    input logic [6:0] opcode,
    input logic [2:0] funct3,

    output logic reg_wr_en,
    output logic alu_src,
    output logic mem_wr_en,
    output logic mem_rd_en,
    output logic mem_to_reg,
    output logic [2:0]  branch_op,
    output logic [1:0] wb_sel
);
    
// TODO: Generate control signals based on opcode and funct3
always_comb begin
    reg_wr_en   = 0;   
    alu_src     = 0;   
    mem_wr_en   = 0;   
    mem_rd_en   = 0;   
    mem_to_reg  = 0;    
    branch_op   = 0;
    wb_sel      = 0;            // ALU by default
    case (opcode)
    R_TYPE : begin
        reg_wr_en   = 1;
    end
    I_TYPE : begin
        reg_wr_en   = 1;
        alu_src     = 1; 
    end
    I_LOAD : begin
        reg_wr_en   = 1;
        alu_src     = 1;
        mem_rd_en   = 1;
        mem_to_reg  = 1;
        wb_sel      = 2'b01;        // Memory
    end
    S_TYPE : begin
        mem_wr_en   = 1;
        alu_src     = 1;
    end
    B_TYPE : begin
        case (funct3)
            3'b010 : branch_op = BR_EQ;
            3'b001 : branch_op = BR_NE;
            3'b101 : branch_op = BR_GE;
            default : branch_op = BR_NONE;
        endcase
    end
    J_TYPE : begin
        reg_wr_en   = 1;
        wb_sel      = 2'b10;        // PC + 4
    end
    JALR_TYPE : begin
        reg_wr_en   = 1;
        alu_src     = 1;
        wb_sel      = 2'b10;        // PC + 4
    end
    endcase
end

endmodule