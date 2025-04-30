/*
16-depth FIFO buffering read/write transactions

Depth = 16
Store structure: {rw_bit, addr, data}
    rw_bit = 1 → write
    rw_bit = 0 → read
Outputs to APB Master
*/

import a01_defines_pkg::*;

module fifo (
    input logic                     clk,
    input logic                     rst,
    input logic                     wr_en,
    input logic                     rd_en,
    input logic [FIFO_DATA_W-1:0]   din,
    
    output logic [FIFO_DATA_W-1:0]  dout,
    output logic                    full,
    output logic                    empty
);

// TODO:   
    // - Implement 16-depth FIFO for 66-bit entries
    // - Use circular buffer logic with write and read pointers

// Pointers and counter
logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr, rd_ptr;
logic [$clog2(FIFO_DEPTH):0] counter;

// FIFO
logic [FIFO_DATA_W-1:0] fifo [0:FIFO_DEPTH-1];

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        wr_ptr  <= 0;
        rd_ptr  <= 0;
        counter <= 0;
    end else begin
        if (wr_en && !full) begin
            fifo[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
        end
        if (rd_en && !empty) begin
            dout <= fifo[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end

        // Counter phases
        case ({wr_en && !full, rd_en && !empty})
            2'b10 : counter <= counter + 1;     // Write
            2'b01 : counter <= counter - 1;     // Read
            2'b11 : counter <= counter;         // Write & Read together
            default: counter <= counter;
        endcase
    end
end

// Output full & empty
assign full = (counter == FIFO_DEPTH);
assign empty = (counter == 0);

// always_ff @(posedge clk) begin
//     if (wr_en && !full)
//         $display("DEBUG FIFO: WR ptr=%0d data=%0d", wr_ptr, din[31:0]);
//     if (rd_en && !empty)
//         $display("DEBUG FIFO: RD ptr=%0d data=%0d", rd_ptr, fifo[rd_ptr][31:0]);
// end
    
endmodule