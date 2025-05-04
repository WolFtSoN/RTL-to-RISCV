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
// Hint: You can focus on R-type and I-type ALU ops for now
localparam OPCODE_R_TYPE = 7'b0110011;  // opcode from RISC-V spec
localparam OPCODE_I_TYPE = 7'b0010011;  // opcode from RISC-V spec

always_comb begin
    alu_ctrl = 4'b0000; // default (AND)
    
    case (opcode)
        OPCODE_R_TYPE : begin
            case ({funct7,funct3})
                10'b0000000111  : alu_ctrl = 4'b0000;         // AND
                10'b0000000110  : alu_ctrl = 4'b0001;         // OR
                10'b0000000000  : alu_ctrl = 4'b0010;         // ADD
                10'b0100000000  : alu_ctrl = 4'b0011;         // SUB
                10'b0000000010  : alu_ctrl = 4'b0100;         // SLT
                10'b0000001100  : alu_ctrl = 4'b0101;         // NOR 
                default : alu_ctrl = 4'b0000;
            endcase
        end
        OPCODE_I_TYPE : begin
            case (funct3)
                3'b111  : alu_ctrl = 4'b0000;         // AND
                3'b110  : alu_ctrl = 4'b0001;         // OR
                3'b000  : alu_ctrl = 4'b0010;         // ADD
                3'b010  : alu_ctrl = 4'b0011;         // SUB
                3'b011  : alu_ctrl = 4'b0100;         // SLT
                3'b001  : alu_ctrl = 4'b0101;         // NOR 
                default : alu_ctrl = 4'b0000;
            endcase
        end
    endcase
end
    
endmodule