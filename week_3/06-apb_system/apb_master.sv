/*
Reads requests from FIFO and drives APB

Pops command from FIFO
    If it's a write: issue APB write
    If it's a read: issue APB read
*/

import defines_pkg::*;

module apb_master (
    input logic                     clk,
    input logic                     rst,
    input logic                     fifo_empty_i,
    input logic [FIFO_DATA_W-1:0]   fifo_data_i,

    output logic                    fifo_rd_en_o,

    // APB signals
    input logic [DATA_W-1:0]    prdata,
    input logic                 pready,

    output logic                psel,
    output logic                penable,
    output logic                pwrite,
    output logic [ADDR_W-1:0]   paddr,
    output logic [DATA_W-1:0]   pwdata,

    // Output
    output logic                rd_valid_o,
    output logic [DATA_W-1:0]   rd_data_o
    
);

// TODO:
    // - On !fifo_empty, read and decode FIFO command
    // - Issue APB write or read accordingly
    // - Forward read result to rd_data_o
    
endmodule