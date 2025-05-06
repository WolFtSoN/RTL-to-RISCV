/*
Instruction Decoder
    - Extracts fields from instruction
    - Generates control signals
*/
import all_pkgs::*;

module decoder (
    input logic [WIDTH-1:0] instr,
    // R-type
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7,
    // I-type
    output logic [11:0] imm_i,   
    // S-type
    output logic [11:0] imm_s,
    // B-type
    output logic [11:0] imm_b,
    // J-type
    output logic [19:0] imm_j
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

// S-type
assign imm_s    = {instr[31:25], instr[11:7]};

// B-type
assign imm_b    = {instr[31], instr[7] , instr[30:25], instr[11:8]};    // imm_b[11:0]  

// J-type
assign imm_j    = {instr[31], instr[19:12], instr[20], instr[30:21]};   // imm_j[19:0]  

// always_comb begin
//     $display("instr[31] = %0b | instr[7] = %0b | instr[30:25] = %6b | instr[11:8] = %4b"  , instr[31], instr[7], instr[30:25], instr[11:8]);
// end

    
endmodule