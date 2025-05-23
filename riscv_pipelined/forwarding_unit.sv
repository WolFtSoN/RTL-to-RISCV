/*
Purpose:
    - Resolve data hazards by forwarding results from later pipeline stages (MEM or WB)
    - Selects data source for ALU inputs via 2-bit signals:
        00 = use register file (no hazard)
        01 = forward from WB stage
        10 = forward from MEM stage
*/

import all_pkgs::*;

module forwarding_unit (
    input logic [4:0] ex_rs1,
    input logic [4:0] ex_rs2,
    input logic [4:0] mem_rd,
    input logic [4:0] wb_rd,
    input logic       mem_reg_wr_en,
    input logic       wb_reg_wr_en,

    output logic [1:0] fwd_a_sel,
    output logic [1:0] fwd_b_sel      
);

// TODO: Implement forwarding logic
// Default: no forwarding
assign fwd_a_sel = (mem_reg_wr_en && (mem_rd != 0) && (mem_rd == ex_rs1)) ? 2'b10 :
                   (wb_reg_wr_en  && (wb_rd != 0)  && (wb_rd == ex_rs1))  ? 2'b01 :
                   2'b00;

assign fwd_b_sel = (mem_reg_wr_en && (mem_rd != 0) && (mem_rd == ex_rs2)) ? 2'b10 :
                   (wb_reg_wr_en  && (wb_rd != 0)  && (wb_rd == ex_rs2))  ? 2'b01 :
                   2'b00;

// always_comb begin
//     $display("FORWARDING DEBUG: ex_rs1 = %0d | ex_rs2 = %0d | fwd_a_sel = %b | fwd_b_sel = %b", ex_rs1, ex_rs2 ,fwd_a_sel, fwd_b_sel);
// end

// always_comb begin
//     $display("FORWARD WB DEBUG: wb_rd = %0d | wb_reg_wr_en = %b", wb_rd, wb_reg_wr_en);
// end
    
endmodule