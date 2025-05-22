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

    output logic [WIDTH-1:0] pc
);

// TODO: Implement PC logic 
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 0;
    end else if (!stall) begin
        pc <= next_pc;
    end
end

// always_ff @(posedge clk) begin
//     $display("PC_REG DEBUG: next_pc = %0d", next_pc);
// end
    
endmodule