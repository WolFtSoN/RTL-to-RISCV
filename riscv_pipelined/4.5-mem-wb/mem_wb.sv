/*
Purpose:
    This stage holds:
    - The ALU result
    - The memory data
    - The destination register
    - Control signals: `reg_wr_en`, `mem_to_reg`
*/

import all_pkgs::*;

module mem_wb (
    input logic clk,
    input logic rst,
    input logic stall,
    input logic flush,

    input logic [WIDTH-1:0] mem_data,
    input logic [WIDTH-1:0] alu_result,
    input logic [4:0]       rd,
    input logic             mem_to_reg,
    input logic             reg_wr_en,
    input logic [1:0]       wb_sel,

    output logic [WIDTH-1:0] wb_data_mem,
    output logic [WIDTH-1:0] wb_data_alu,
    output logic [4:0]       wb_rd,
    output logic             wb_mem_to_reg,
    output logic             wb_reg_wr_en,
    output logic [1:0]       wb_wb_sel
);

// TODO: Register everything
always_ff @(posedge clk or posedge rst) begin
    if (rst || flush) begin
        wb_data_mem     <= {WIDTH{1'b0}};    
        wb_data_alu     <= {WIDTH{1'b0}};
        wb_rd           <= 0;
        wb_mem_to_reg   <= 0;    
        wb_reg_wr_en    <= 0;
        wb_wb_sel       <= 0;
    end
    else begin
        if (!stall) begin
            wb_data_mem     <=  mem_data;
            wb_data_alu     <=  alu_result;
            wb_rd           <=  rd;
            wb_mem_to_reg   <=  mem_to_reg;
            wb_reg_wr_en    <=  reg_wr_en;
            wb_wb_sel       <= wb_sel;
        end
    end
end
    
endmodule