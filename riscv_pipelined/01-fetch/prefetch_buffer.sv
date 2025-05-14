/*
A small FIFO\register array:
    - Stores upcoming inctructions fetched from memory
    - Let's the CPU keep moving even if instuction memory is slow
    - Can support multi-cycle or burst instruction fetching
*/

import all_pkgs::*;

module prefetch_buffer (
    input logic             clk,
    input logic             rst,
    // Control input from IF
    input logic [WIDTH-1:0] next_pc,        // Chosen PC (pc + 4, branch, jal)
    input logic             fetch_valid,    // Ready to get instruction (Send a fetch request!)
    input logic [WIDTH-1:0] fetched_instr,  // Data coming from IMEM
    input logic             fetched_valid,  // Instruction is available (Fetch result has arrived!)
    // Outputs to if/id
    output logic [WIDTH-1:0] pc_out,        // current PC value for instruction
    output logic [WIDTH-1:0] instr_out,     // instruction to pass to decode
    output logic             ready          // high when instr_out is available to decode
);
// TODO: Create internal instruction buffer register
logic [WIDTH-1:0] instr_buffer, pc_buffer;
logic full;
// TODO: Store pc and instruction on fetched_valid
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_buffer    <= {WIDTH{1'b0}};
        instr_buffer <= {WIDTH{1'b0}};
        full         <= 0;
    end 
    else begin
        if (fetch_valid) begin
            pc_buffer <= next_pc;
        end    
        if (fetched_valid) begin
            instr_buffer <= fetched_instr;
            full <= 1;
        end
    end
end

// TODO: Assert ready when buffer is valid and stable
assign ready     = full;
assign instr_out = instr_buffer;
assign pc_out    = pc_buffer;

endmodule