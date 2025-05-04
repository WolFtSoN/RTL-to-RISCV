/*
Data Memory (MEM stage)
    - Read/Write memory block
    - Supports word-aligned access
    - Synchronous write, asynchronous read
*/
import all_pkgs::*;

module data_mem (
    input logic             clk,
    input logic             mem_wr_en,
    input logic             mem_rd_en,
    input logic [WIDTH-1:0] addr,
    input logic [WIDTH-1:0] wr_data,

    output logic [WIDTH-1:0] rd_data
);

// TODO: Declare memory (e.g., 256 x 32-bit words)
// TODO: Synchronous write
// TODO: Asynchronous read
// TODO: Handle word alignment if needed

localparam MEM_SZ = 256;
logic [WIDTH-1:0] mem [0:MEM_SZ-1];

// Write
always_ff @(posedge clk) begin
    if (mem_wr_en) begin
        mem[addr[9:2]] <= wr_data;
    end
end

// Read
assign rd_data = (mem_rd_en) ? mem[addr[9:2]] : 0;

endmodule