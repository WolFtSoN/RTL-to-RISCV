/*
Writeback Mux
    - Selects either ALU result or memory data for writeback
    - Controlled by mem_to_reg signal
*/
import all_pkgs::*;

module writeback_mux (
    input logic [WIDTH-1:0] alu_result,
    input logic [WIDTH-1:0] mem_data,
    input logic             mem_to_reg,     // 0 = ALU, 1 = MEM

    output logic [WIDTH-1:0] wb_data
);

// TODO: Select writeback data based on mem_to_reg

assign wb_data = (mem_to_reg) ? mem_data : alu_result;
    
endmodule