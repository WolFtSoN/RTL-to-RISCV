/*
Purpose:
    - This is a pipeline register between the Instruction Fetch (IF) and Decode (ID) stages.
    It holds:
        - The instruction (`instr`)
        - The program counter (`pc`)
    and updates on each clk, unless there's:
        - A stall (hold values)
        - A flush (invalidate instruction)
*/

import all_pkgs::*;

module if_id (
    input logic             clk,
    input logic             rst,
    input logic             stall,
    input logic             flush,
    input logic [WIDTH-1:0] if_pc,
    input logic [WIDTH-1:0] if_instr,

    output logic [WIDTH-1:0] id_pc,
    output logic [WIDTH-1:0] id_instr
);

// TODO: Register pc and instr | (Reset to 0, Flush to 0, Hold if stalled)
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        id_pc    <= {WIDTH{1'b0}};
        id_instr <= {WIDTH{1'b0}};
    end else if (!stall) begin
        if (flush) begin
            id_pc    <= {WIDTH{1'b0}};
            id_instr <= {WIDTH{1'b0}};
        end else begin
            id_pc    <= if_pc;
            id_instr <= if_instr;
        end
    end
end

// always_comb begin
//     $display("IF/ID DEBUG: id_pc = %b | id_instr = %b | flush = %0b", id_pc, id_instr, flush);
// end

endmodule