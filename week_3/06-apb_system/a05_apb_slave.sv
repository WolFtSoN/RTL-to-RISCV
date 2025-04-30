/*
Simple memory-mapped interface

Simple memory model (e.g., small memory array)
*/

import a01_defines_pkg::*;

module apb_slave (
    input logic                 clk,
    input logic                 rst,
    input logic                 psel,
    input logic                 penable,
    input logic                 pwrite,
    input logic [ADDR_W-1:0]    paddr,
    input logic [DATA_W-1:0]    pwdata,

    output logic [DATA_W-1:0]   prdata,
    output logic                pready
);

// TODO:
    // - Implement a small memory 
    // - When pwrite=1 and psel && penable -> perform write
    // - When pwrite=0 and psel && penable -> perform read
    // - pready should be asserted after 1 cycle

// Memory
localparam MEM_DEPTH = 256;
logic [DATA_W-1:0] mem [0:MEM_DEPTH-1];

// APB logic
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        pready    <= 0;
        prdata    <= 0;
        // read_data <= 0;
    end else begin
        pready <= 0;

        if (psel && penable) begin
            pready <= 1;
            if (pwrite) begin
                mem[paddr[$clog2(MEM_DEPTH)-1:0]] <= pwdata;
            end else begin
                prdata <= mem[paddr[$clog2(MEM_DEPTH)-1:0]];
            end
        end
    end
end

// always_ff @(posedge clk) begin
//     if (psel && penable && !pwrite && pready)
//         $display("DEBUG SLAVE: WRITE addr=%0d prdata=%0d", paddr, mem[paddr[$clog2(MEM_DEPTH)-1:0]]);
// end
    
endmodule