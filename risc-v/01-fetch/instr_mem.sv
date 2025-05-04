/*
Instruction Memory
    - ROM holding 32-bit instructions
    - Read-only memory
    - Addressed by PC
    - Outputs instruction at current PC
*/
import all_pkgs::*;

module instr_mem (
    input logic [WIDTH-1:0] addr,       // Address from PC

    output logic [WIDTH-1:0] instr      // Instruction output
);

// TODO: Declare ROM array (e.g., 256 instructions)
// TODO: Read instruction at word-aligned address - address points to the start of a full word (4 bytes in RISC-V)
localparam INSTR_W = 256;
logic [WIDTH-1:0] imem [0:INSTR_W-1];

assign instr = imem[addr[9:2]];         // Equivalent to (addr/4), gives you the instruction index |  division by 4 is just dropping the two least significant bits
    
endmodule