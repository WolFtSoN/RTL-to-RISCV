/*
PC Register
    - Holds the current program counter
    - Synchronous reset
    - Loads new PC on each cycle
*/
import all_pkgs::*;

module pc_register (
    input logic             clk,
    input logic             rst,
    input logic [WIDTH-1:0] next_pc,
    
    output logic [WIDTH-1:0] pc
);

// TODO: Implement synchronous reset
// TODO: Store next_pc into pc every cycle

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= {WIDTH{1'b0}};
    end else begin
        pc <= next_pc;
    end
end

endmodule