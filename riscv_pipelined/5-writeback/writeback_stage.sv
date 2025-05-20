/*
Purpose:
    - Selects the data to be written back to the register file:
        * if `mem_to_reg` == 1 -> choose `mem_data` | Else choose `alu_result` 
    - Drives the final writeback bus (`wb_data`)
    - Forwards: `rd`, `reg_wr_en` 
*/

import all_pkgs::*;

module writeback_stage (
    input logic [WIDTH-1:0] wb_data_mem,
    input logic [WIDTH-1:0] wb_data_alu,
    input logic             mem_to_reg,
    input logic             reg_wr_en,
    input logic [4:0]       rd,
    input logic [WIDTH-1:0] pc_plus4,
    input logic [1:0]       wb_sel,         // 00 = ALU, 01 = MEM, 10 = PC+4

    output logic [WIDTH-1:0] wb_data,
    output logic             wb_wr_en,
    output logic [4:0]       wb_rd
);

// TODO: Forward write enable and destination register
assign wb_rd = rd;
assign wb_wr_en = reg_wr_en;

always_comb begin
    case (wb_sel)
        2'b00 : wb_data = wb_data_alu;
        2'b01 : wb_data = wb_data_mem;
        2'b10 : wb_data = pc_plus4;     // for jal
        default: wb_data = '0;
    endcase
end

endmodule