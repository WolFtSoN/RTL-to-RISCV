/*
Purpose:
    - Hold the current PC value
    - Reset to 0 when rst is high
    - Update it with `next_pc` on every clk
*/

import all_pkgs::*;

module pc_register (
    input logic             clk,
    input logic             rst,
    input logic [WIDTH-1:0] next_pc,
    input logic             stall,      // Hold current PC
    input logic             flush,      // Force reset PC to flush_pc
    input logic [WIDTH-1:0] flush_pc,   // PC to jump to on flush (e.g., from branch)

    output logic [WIDTH-1:0] pc
);

// TODO: Implement PC logic 
always_ff @(posedge clk or posedge rst) begin
    if (rst || flush) begin
        pc <= (rst) ? {WIDTH{1'b0}} : flush_pc;
    end 
    else begin
        if (!stall)
            pc <= next_pc;
    end
end
    
endmodule