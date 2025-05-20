/*
Purpose:
    Given the instruction (`id_instr`) and PC (`id_pc`) from the IF/ID register, this stage"
    - Extracts:
        * `rs1`, `rs2`, `rd`
        * `opcode`, `funct3`, `funct7`
        * imm_ext
    - Reads `rs1` and `rs2` register values from the regfile
    - Accepts write-back inputs (`wb_rd`, `wb_data`, `wb_en`)
    - Passes all decoded outputs to the ID/EX pipeline register
*/

import all_pkgs::*;

module decode_stage (
    input logic             clk,
    input logic             rst,

    input logic [WIDTH-1:0] id_pc,
    input logic [WIDTH-1:0] id_instr,

    input logic             wb_en,
    input logic [4:0]       wb_rd,
    input logic [WIDTH-1:0] wb_data,

    output logic [WIDTH-1:0] reg_data1,
    output logic [WIDTH-1:0] reg_data2,
    output logic [WIDTH-1:0] imm_ext,
    output logic [4:0]       rs1,
    output logic [4:0]       rs2,
    output logic [4:0]       rd,
    output logic [2:0]       funct3,
    output logic [6:0]       funct7,
    output logic [6:0]       opcode
);

// TODO: Instantiate decoder
decoder u_decoder (
    .instr      (id_instr),
    .opcode     (opcode),
    .rd         (rd),
    .funct3     (funct3),
    .rs1        (rs1),
    .rs2        (rs2),
    .funct7     (funct7),
    .imm_ext    (imm_ext)
);

// TODO: Instantiate regfile
regfile u_regfile (
    .clk        (clk),
    .rst        (rst),
    .wr_en      (wb_en),
    .rs1_addr   (rs1),
    .rs2_addr   (rs2),
    .rd_addr    (wb_rd),
    .rd_data    (wb_data),
    .rs1_data   (reg_data1),
    .rs2_data   (reg_data2)
);
 
endmodule