/*
Purpose:
    Given a 32-bit RISC-V instruction, it extracts:
    - Opcode
    - Register indices (`rs1`, `rs2`, `rd`)
    - funct3, funct7
    - Immediates for I, S, B, J types 
*/

import all_pkgs::*;

module decoder (
    input logic [WIDTH-1:0] instr,

    output logic [6:0]  opcode,
    output logic [4:0]  rd,
    output logic [2:0]  funct3,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [6:0]  funct7,
    
    output logic [WIDTH-1:0] imm_ext
);

logic [11:0] imm_i;
logic [11:0] imm_s;
logic [11:0] imm_b;
logic [19:0] imm_j;

// TODO: Extract all fields from instr
assign opcode   = instr[6:0];
assign rd       = instr[11:7];
assign funct3   = instr[14:12];
assign rs1      = instr[19:15];
assign rs2      = instr[24:20];
assign funct7   = instr[31:25];

assign imm_i = instr[31:20];
assign imm_s = {instr[31:25], instr[11:7]};
assign imm_b = {instr[31], instr[7], instr[30:25], instr[11:8]};
assign imm_j = {instr[31], instr[19:12], instr[20], instr[30:21]};

assign imm_ext = (opcode == I_TYPE || opcode == I_LOAD || opcode == JALR_TYPE) ? {{20{imm_i[11]}}, imm_i} :
                 (opcode == S_TYPE) ? {{20{imm_s[11]}}, imm_s} :
                 (opcode == B_TYPE) ? $signed({{20{imm_b[11]}}, imm_b}) :
                 (opcode == J_TYPE) ? $signed({{12{imm_j[19]}}, imm_j}) : 
                 {WIDTH{1'b0}};

// always_comb begin
//     $display("DECODE DEBUG: opcode = %7b | imm_ext = %0d", opcode, imm_ext);
// end

endmodule