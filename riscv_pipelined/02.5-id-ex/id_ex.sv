/*
Purpose:
    Capture and forward all signals from Decode stage to the Execute stage:
    - Values from the register file
    - Decoded instruction fields (opcode, rd, funct3, funct7)
    - The extended immediate
    - The PC (for branch target or jal) 
*/


import all_pkgs::*;

module id_ex (
    input logic                 clk,
    input logic                 rst,
    input logic                 stall,
    input logic                 flush,

    input logic [WIDTH-1:0]     id_pc,
    input logic [WIDTH-1:0]     reg_data1,
    input logic [WIDTH-1:0]     reg_data2,
    input logic [WIDTH-1:0]     imm_ext,
    input logic [4:0]           rs1,
    input logic [4:0]           rs2,
    input logic [4:0]           rd,
    input logic [2:0]           funct3,
    input logic [6:0]           funct7,
    input logic [6:0]           opcode,

    output logic [WIDTH-1:0]    ex_pc,
    output logic [WIDTH-1:0]    ex_reg_data1,
    output logic [WIDTH-1:0]    ex_reg_data2,
    output logic [WIDTH-1:0]    ex_imm_ext,
    output logic [4:0]          ex_rs1,
    output logic [4:0]          ex_rs2,
    output logic [4:0]          ex_rd,
    output logic [2:0]          ex_funct3,
    output logic [6:0]          ex_funct7,
    output logic [6:0]          ex_opcode
);

// TODO: Register all inputs (Reset or Flush = 0 | Stall = hold)
always_ff @(posedge clk or posedge rst) begin
    if (rst | flush) begin
        ex_pc           <= {WIDTH{1'b0}};
        ex_reg_data1    <= {WIDTH{1'b0}};
        ex_reg_data2    <= {WIDTH{1'b0}};
        ex_imm_ext      <= {WIDTH{1'b0}};
        ex_rs1          <= 0;
        ex_rs2          <= 0;
        ex_rd           <= 0;
        ex_funct3       <= 0;
        ex_funct7       <= 0;
        ex_opcode       <= 0;
    end
    else begin
        if (!stall) begin
            ex_pc           <= id_pc;
            ex_reg_data1    <= reg_data1;
            ex_reg_data2    <= reg_data2;
            ex_imm_ext      <= imm_ext;
            ex_rs1          <= rs1;
            ex_rs2          <= rs2;
            ex_rd           <= rd;
            ex_funct3       <= funct3;
            ex_funct7       <= funct7;
            ex_opcode       <= opcode;
        end
    end
end

endmodule