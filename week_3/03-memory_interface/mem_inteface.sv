/*
Goal: Build a Simple Memory Interface
    - Accepts read and write requests from a client (e.g., APB master, core, DMA)
    - Handles transactions to a simple memory array
    - Uses `valid`/`ready`-style handshaking

Inputs:
    clk,rst
    req_valid -> Request is valid
    req_write -> 1 = write, 0 = read
    req_addr  -> Address to access
    req_wdata -> Write data

Outputs:
    req_ready  -> Module is ready to accept request
    resp_valid -> Response is ready
    resp_rdata -> Read data (valid when `resp_valid`)

The interface should be pipelined: Accept a new request only when `req_valid && req ready`, and return a response a few cycles later
*/

module mem_interface #(
    parameter DATA_W = 8,
    parameter ADDR_W = 4
) (
    input               clk, rst,
    // Request from client
    input logic                 req_valid,
    input logic                 req_write,
    input logic [ADDR_W-1:0]    req_addr,
    input logic [DATA_W-1:0]    req_wdata,
    output logic                req_ready,  // This is the handshake logic -> When we get req_ready we can continue the work
    // Response to client
    output logic                resp_valid,
    output logic [DATA_W-1:0]   resp_rdata
);
    
// Memory
logic [DATA_W-1:0] mem [2**ADDR_W-1:0];

// ------------- Solution -------------

always @(posedge clk or posedge rst) begin
    if (rst) begin
        req_ready  <= 1; // Ready to accept at start
        resp_valid <= 0;
        resp_rdata <= 0;
    end else begin
        resp_valid <= 0;    // Default when no new read
        if (req_valid && req_ready) begin 
            req_ready <= 0;
            if (req_write) begin            // Write to memory
                mem[req_addr] <= req_wdata;
                req_ready <= 1;
            end else begin                  // Read from memory
                resp_rdata <= mem[req_addr];
                resp_valid <= 1;
                req_ready <= 1;
            end
        end  
    end
end

endmodule