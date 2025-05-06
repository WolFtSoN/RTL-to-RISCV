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
    input logic [WIDTH-1:0] pc_plus4,
    input logic [1:0]       wb_sel,         // 00 = ALU, 01 = MEM, 10 = PC+4

    output logic [WIDTH-1:0] wb_data
);

// TODO: Select writeback data based on mem_to_reg
always_comb begin
    case (wb_sel)
        2'b00 : wb_data = alu_result;
        2'b01 : wb_data = mem_data;
        2'b10 : wb_data = pc_plus4;     // for jal
        default: wb_data = '0;
    endcase
end

// assign wb_data = (mem_to_reg) ? mem_data : alu_result;
    
endmodule