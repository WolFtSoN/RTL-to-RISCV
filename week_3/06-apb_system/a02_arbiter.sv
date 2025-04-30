/*
Accepts incoming read/write requests, prioritizes writes, outputs to FIFO

Inputs  : wr_req_i, rd_req_i
Outputs : Selected command (write first if both active)
Generates FIFO input: {type, addr, data}
*/

import a01_defines_pkg::*;

module arbiter (
    input logic                 clk,
    input logic                 rst,
    input logic                 wr_req_i,
    input logic [ADDR_W-1:0]    wr_addr_i,
    input logic [DATA_W-1:0]    wr_data_i,
    input logic                 rd_req_i,
    input logic [ADDR_W-1:0]    rd_addr_i,

    output logic                fifo_wr_en_o,   // Enable write into FIFO
    output logic [64:0]         fifo_data_o     // {1'brw, 32-bit addr, 32-bit data}  // 1'brw = read/write 
);
    
// TODO:
    // - Give priority to write over read
    // - If wr_req_i        : send {1,addr,data} to FIFO
    // - Else if rd_req_i   : send {0,addr,X} to FIFO


always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        fifo_wr_en_o    <= 0;
        fifo_data_o     <= '0;
    end else begin
        if (wr_req_i) begin
            fifo_wr_en_o    <= 1;
            fifo_data_o     <= {1'b1,wr_addr_i,wr_data_i}; 
        end else if (rd_req_i) begin
            fifo_wr_en_o    <= 1;
            fifo_data_o     <= {1'b0,rd_addr_i,{ADDR_W{1'b0}}};
        end else begin
            fifo_wr_en_o    <= 0;
            fifo_data_o     <= '0;
        end
    end
end

// always_ff @(posedge clk) begin
//     if (wr_req_i)
//         $display("DEBUG ARBITER: wr_req_i = %0d | fifo_wr_en_o = %0b | wr/rd = %0b | addr = %0d | data = %0d", wr_req_i,fifo_wr_en_o, fifo_data_o[64], fifo_data_o[63:32], fifo_data_o[31:0]);
//     if (rd_req_i)
//         $display("DEBUG ARBITER: rd_addr_i = %0d | fifo_wr_en_o = %0b | wr/rd = %0b | addr = %0d | data = %0d", rd_addr_i,fifo_wr_en_o, fifo_data_o[64], fifo_data_o[63:32], fifo_data_o[31:0]);
// end
endmodule