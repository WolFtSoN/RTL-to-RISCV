/*
Connects everything together
*/

import a01_defines_pkg::*;

module top_system (
    input logic              clk,
    input logic              rst,
    // External write interface
    input logic              wr_req_i,
    input logic [ADDR_W-1:0] wr_addr_i,
    input logic [DATA_W-1:0] wr_data_i,
    // External read interface
    input logic              rd_req_i,
    input logic [ADDR_W-1:0] rd_addr_i,

    // Read output
    output logic             rd_valid_o,
    output logic [DATA_W-1:0] rd_data_o
);
    
// Wires
logic                   fifo_wr_en;
logic [FIFO_DATA_W-1:0] fifo_data_in;
logic                   fifo_rd_en;
logic [FIFO_DATA_W-1:0] fifo_data_out;
logic                   fifo_full, fifo_empty;

logic psel, penable, pwrite, pready;
logic [ADDR_W-1:0] paddr;
logic [DATA_W-1:0] pwdata, prdata;

// ------------------------
// Instantiate Arbiter
// ------------------------
arbiter u_arbiter (
    .clk(clk),
    .rst(rst),
    .wr_req_i(wr_req_i),
    .wr_addr_i(wr_addr_i),
    .wr_data_i(wr_data_i),
    .rd_req_i(rd_req_i),
    .rd_addr_i(rd_addr_i),
    .fifo_wr_en_o(fifo_wr_en),
    .fifo_data_o(fifo_data_in)
);

// ------------------------
// Instantiate FIFO
// ------------------------
fifo u_fifo (
    .clk(clk),
    .rst(rst),
    .wr_en(fifo_wr_en),
    .rd_en(fifo_rd_en),
    .din(fifo_data_in),
    .dout(fifo_data_out),
    .full(fifo_full),
    .empty(fifo_empty)
);

// ------------------------
// Instantiate APB Master
// ------------------------
apb_master u_apb_master (
    .clk(clk),
    .rst(rst),
    .fifo_empty_i(fifo_empty),
    .fifo_data_i(fifo_data_out),
    .fifo_rd_en_o(fifo_rd_en),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready),
    .rd_valid_o(rd_valid_o),
    .rd_data_o(rd_data_o)
);

// ------------------------
// Instantiate APB Slave
// ------------------------
apb_slave u_apb_slave (
    .clk(clk),
    .rst(rst),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
);

endmodule