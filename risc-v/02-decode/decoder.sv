/*
Instruction Decoder
    - Extracts fields from instruction
    - Generates control signals
*/
import all_pkgs::*;

module decoder (
    input logic [WIDTH-1:0] instr,

    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7,
    output logic [11:0] imm_i  // I-type 
);

// TODO: Extract fields from instruction
// TODO: Route to output ports

// R-type
assign opcode   = instr [6:0];
assign rd       = instr [11:7];
assign funct3   = instr [14:12];
assign rs1      = instr [19:15];
assign rs2      = instr [24:20];
assign funct7   = instr [31:25];

// I-type - has the same opcode, rd, funct3, rs1 | doesn't have rs2 and funct7
assign imm_i    = instr [31:20];
    
endmodule