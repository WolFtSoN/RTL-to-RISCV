/*
Purpose:
    Given the inputs of id_ex:
    - Selects the correct ALU operand (`reg_data2` vs `imm_ext`)
    - Computes the ALU result
    - Computes branch condition (BEQ, BNE, BGE)
*/

import all_pkgs::*;

module execute_stage (
    input logic clk,
    input logic rst,

    input logic [WIDTH-1:0] ex_pc,
    input logic [WIDTH-1:0] reg_data1,
    input logic [WIDTH-1:0] reg_data2,
    input logic [WIDTH-1:0] imm_ext,
    input logic [4:0]       rs1,
    input logic [4:0]       rs2,
    input logic [4:0]       rd,
    input logic [2:0]       funct3,
    input logic [6:0]       funct7,
    input logic [6:0]       opcode,
    input logic             alu_src,        // Control: select reg2 or imm

    output logic [WIDTH-1:0] alu_result,
    output logic             zero,
    output logic             branch_taken
);

logic [ALU_OP-1:0] alu_ctrl;

// TODO: Choose second operand (reg2 or imm)
logic [WIDTH-1:0] alu_operand_b;
assign alu_operand_b = (alu_src) ? imm_ext : reg_data2;     // alu_src == 1 -> use immediate (I/S-type)
                                                            // alu_src == 0 -> use register value (R/B-type)

// TODO: Instantiate alu_ctrl
alu_ctrl u_alu_ctrl (
    .opcode     (opcode),
    .funct3     (funct3),
    .funct7     (funct7),
    .alu_ctrl   (alu_ctrl)
);

// TODO: Instantiate alu
alu u_alu (
    .a          (reg_data1),
    .b          (alu_operand_b),
    .alu_ctrl   (alu_ctrl),
    .result     (alu_result),
    .zero       (zero)
);

// TODO: Compute branch_taken using funct3 + zero (if branch)
assign branch_taken =   (funct3 == BR_EQ && zero)   ||
                        (funct3 == BR_NE && !zero)  ||
                        (funct3 == BR_GE && !(reg_data1 < alu_operand_b));
    
endmodule