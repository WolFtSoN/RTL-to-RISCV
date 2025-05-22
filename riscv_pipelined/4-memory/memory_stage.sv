/*
Purpose:
    - Memory writes (for sw, sb, ...), using mem_wr_en
    - Memory reads  (for lw, lb, ...), using mem_rd_en
*/

import all_pkgs::*;

module memory_stage (
    input logic             clk,
    input logic             rst,
    input logic             mem_wr_en,
    input logic             mem_rd_en,
    input logic [WIDTH-1:0] mem_addr,  
    input logic [WIDTH-1:0] mem_wr_data,

    output logic [WIDTH-1:0] mem_data_out
);

// TODO: Declare memory and implement write/read 
localparam MEM_SZ = 256;
logic [WIDTH-1:0] mem [0:MEM_SZ-1];

// Write
always_ff @(posedge clk) begin
    if (mem_wr_en) begin
        mem[mem_addr[9:2]] <= mem_wr_data;
        // $display("MEM INTERNAL: mem[%0d] = %0d", mem_addr[9:2], mem_wr_data);
    end
end

// Read
assign mem_data_out = (mem_rd_en) ? mem[mem_addr[9:2]] : {WIDTH{1'b0}};

// always_ff @(posedge clk) begin
//     $display("MEM DEBUG: mem_wr_en = %0b | mem_addr = %0d | mem_wr_data = %0d", mem_wr_en, mem_addr[9:2], mem_wr_data);
// end

endmodule