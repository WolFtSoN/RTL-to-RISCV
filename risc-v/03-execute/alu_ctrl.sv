/*
ALU Control Unit
    - Determines which operation the ALU performs
    - Inputs: funct3, funct7, and opcode
    - Outputs: alu_ctrl signal to ALU
*/
import all_pkgs::*;

module alu_ctrl (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,

    output logic [ALU_OP-1:0] alu_ctrl
);

// TODO: Implement logic that maps funct3, funct7, and opcode to alu_ctrl

always_comb begin
    alu_ctrl = 4'b0000; // default (AND)
    
    case (opcode)
        R_TYPE : begin
            case ({funct7,funct3})
                10'b0000000111  : alu_ctrl = ALU_AND;         // AND
                10'b0000000110  : alu_ctrl = ALU_OR;          // OR
                10'b0000000000  : alu_ctrl = ALU_ADD;         // ADD
                10'b0100000000  : alu_ctrl = ALU_SUB;         // SUB
                10'b0000000010  : alu_ctrl = ALU_SLT;         // SLT
                10'b0000001100  : alu_ctrl = ALU_NOR;         // NOR
                
                10'b0000001000  : alu_ctrl = ALU_MUL;         // MUL - lower 32 bits | signed × signed
                10'b0000001001  : alu_ctrl = ALU_MULH;        // MUL - upper 32 bits | signed × signed
                10'b0000001010  : alu_ctrl = ALU_MULHSU;      // MUL - upper 32 bits | unsigned × unsigned
                10'b0000001011  : alu_ctrl = ALU_MULHU;       // MUL - upper 32 bits | signed × unsigned

                10'b0000001110  : alu_ctrl = ALU_REM;         // REM - signed % signed
                10'b0000001111  : alu_ctrl = ALU_REMU;        // REM - unsigned % unsigned
                default : alu_ctrl = {ALU_OP{1'b0}};
            endcase
        end
        I_TYPE : begin
            case (funct3)
                3'b111  : alu_ctrl = ALU_AND;         // ANDI
                3'b110  : alu_ctrl = ALU_OR;          // ORI
                3'b000  : alu_ctrl = ALU_ADD;         // ADDI
                3'b010  : alu_ctrl = ALU_SUB;         // SUBI
                3'b011  : alu_ctrl = ALU_SLT;         // SLTI
                3'b001  : alu_ctrl = ALU_NOR;         // NORI
                default : alu_ctrl = {ALU_OP{1'b0}};
            endcase
        end
        S_TYPE : begin
            case (funct3)
                3'b000  : alu_ctrl = ALU_ADD;        // ADD  
                default : alu_ctrl = {ALU_OP{1'b0}};
            endcase
        end
        I_LOAD  : begin
            case (funct3)
                3'b000  : alu_ctrl = ALU_ADD;        // ADD  
                default : alu_ctrl = {ALU_OP{1'b0}}; 
            endcase
        end
        B_TYPE  : begin // branch instructions always needs to do subtraction
                alu_ctrl = ALU_SUB;                 // SUB  
        end
    endcase
end
    
endmodule