/*
Purpose:
    This module captures:
    - ALU result
    - Second register value 
    - Destination register ID (rd)
    - Opcode, funct3
    - Control signals 
*/

import all_pkgs::*;

module ex_mem (
    input logic clk,
    input logic rst,
    input logic stall,
    input logic flush,

    input logic [WIDTH-1:0] alu_result,
    input logic [WIDTH-1:0] reg_data2,
    input logic [4:0]       rd,
    input logic [2:0]       funct3,
    input logic [6:0]       opcode,
    input logic             reg_wr_en,
    input logic             mem_to_reg,
    input logic [1:0]       wb_sel,

    output logic [WIDTH-1:0] mem_alu_result,
    output logic [WIDTH-1:0] mem_reg_data2,
    output logic [4:0]       mem_rd,
    output logic [2:0]       mem_funct3,
    output logic [6:0]       mem_opcode,
    output logic             mem_reg_wr_en,
    output logic             mem_mem_to_reg,
    output logic [1:0]       mem_wb_sel
);

// TODO: Register all inputs | Reset or Flush = 0 | Stall = hold

always_ff @(posedge clk or posedge rst) begin
    if (rst || flush) begin
        mem_alu_result  <= {WIDTH{1'b0}};
        mem_reg_data2   <= {WIDTH{1'b0}};
        mem_rd          <= 0;
        mem_funct3      <= 0;
        mem_opcode      <= 0;
        mem_reg_wr_en   <= 0;
        mem_mem_to_reg  <= 0;
        mem_wb_sel      <= 0;
    end
    else begin
        if (!stall) begin
            mem_alu_result  <= alu_result;
            mem_reg_data2   <= reg_data2;
            mem_rd          <= rd;    
            mem_funct3      <= funct3;
            mem_opcode      <= opcode;
            mem_reg_wr_en   <= reg_wr_en;
            mem_mem_to_reg  <= mem_to_reg;
            mem_wb_sel      <= wb_sel;
        end
    end
end


endmodule