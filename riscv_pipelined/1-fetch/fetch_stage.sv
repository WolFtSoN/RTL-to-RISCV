/*
Purpose:
    - Hold the PC
    - Pass PC to `instr_mem`
    - Latch instruction + PC using `prefetch_buffer`
    - Expose instr, pc, and ready to the next stage
*/

import all_pkgs::*;

module fetch_stage (
    input logic             clk,
    input logic             rst,
    input logic             stall,
    input logic             flush,
    input logic [WIDTH-1:0] flush_pc,      
    input logic [WIDTH-1:0] next_pc,
    // input logic             req,

    output logic [WIDTH-1:0] pc_out,
    output logic [WIDTH-1:0] instr_out,
    output logic             ready
);
logic fetch_valid;
// TODO: Declare internal wires
logic [WIDTH-1:0] pc_reg_out;
logic [WIDTH-1:0] instr_mem_out;
logic imem_valid;

// TODO: Instantiate pc_register
pc_register u_pc_reg (
    .clk        (clk),
    .rst        (rst),
    .next_pc    (next_pc),
    .stall      (stall),

    .pc         (pc_reg_out)
);

// TODO: Instantiate instr_mem
instr_mem u_instr_mem (
    .addr  (pc_reg_out),
    // .req    (req),

    // .valid  (imem_valid),
    .instr  (instr_out)
);
// === Outputs ===
assign pc_out = pc_reg_out;
assign ready  = 1'b1;

// TODO: Instantiate prefetch_buffer
// prefetch_buffer u_prefetch_buf (
//     .clk            (clk),
//     .rst            (rst),
//     .flush          (flush),
//     .next_pc        (pc_reg_out),
//     .fetch_valid    (fetch_valid),
//     // .fetched_valid  (imem_valid),
//     .fetched_instr  (instr_mem_out),

//     .pc_out         (pc_out),
//     .instr_out      (instr_out),
//     .ready          (ready)
// );

// TODO: Always set fetch_valid = 1'b1 for now
// assign fetch_valid = !stall;

// always_ff @(posedge clk) begin
//     $display("FETCH DEBUG: next_pc - input = %0d | pc_reg_out = %0d", next_pc, pc_reg_out);
// end

endmodule