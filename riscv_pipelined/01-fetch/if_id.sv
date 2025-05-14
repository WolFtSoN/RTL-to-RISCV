/*
This module is the register between the IF and ID stages
It holds:
    - The PC at the current instruction
    - The instruction itself
*/

import all_pkgs::*;
module if_id (
    input logic         clk,
    input logic         rst,
    input logic [WIDTH-1:0] if_pc,
    input logic [WIDTH-1:0] if_instr,

    output logic [WIDTH-1:0] id_pc,
    output logic [WIDTH-1:0] id_instr
);

// TODO: Declare id_pc and id_instr registers
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        id_pc    <= {WIDTH{1'b0}};
        id_instr <= {WIDTH{1'b0}};
    end
    else begin
        id_pc    <= if_pc;
        id_instr <= if_instr;
    end
end

endmodule

