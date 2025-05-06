/*
Control Unit
    - Decodes opcode
    - Generates control signals for datapath
*/
import all_pkgs::*;

module control_unit (
    input logic [6:0] opcode,
    input logic [2:0] funct3,

    output logic        reg_wr_en,
    output logic        alu_src,        // 0 = reg (R-type), 1 = imm (I-type)
    output logic        mem_wr_en,
    output logic        mem_rd_en,
    output logic        mem_to_reg,     // 0 = ALU result, 1 = MEM data
    output logic        branch,
    output logic [2:0]  branch_op
);

// TODO: Implement control logic based on opcode
always_comb begin 
    // Default values
    reg_wr_en   = 0;
    alu_src     = 0;
    mem_wr_en   = 0;
    mem_rd_en   = 0;
    mem_to_reg  = 0;
    branch      = 0;
    branch_op   = 0;
    case (opcode)
        R_TYPE : begin
            reg_wr_en   = 1;     
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
        B_TYPE: begin
            branch = 1;
            case (funct3)
                3'b010 : branch_op = BR_EQ;
                3'b001 : branch_op = BR_NE; 
                default : branch_op = BR_NONE;
            endcase
        end
        J_TYPE: begin
            reg_wr_en   = 1;
        end
        JALR_TYPE: begin
            reg_wr_en   = 1;    // write return address to rd
            alu_src     = 1;    // use immediate (offset)
        end
    endcase 
end

// always_comb begin
//     $display("funct3 = %3b", funct3);
// end
    
endmodule