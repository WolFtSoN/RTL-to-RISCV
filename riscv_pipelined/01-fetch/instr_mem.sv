/*
Purpose:
    - A read-only memory (ROM) storing instructions
    - Addressed by PC
*/

import all_pkgs::*;

module instr_mem (
    input logic [WIDTH-1:0] addr,   // PC address
    input logic             req,

    output logic             valid,
    output logic [WIDTH-1:0] instr  // Instruction at PC
);

localparam imem_sz = 256;
// TODO: Declare memory array
logic [WIDTH-1:0] imem [0:imem_sz-1];

// TODO: Word-align the address
assign instr = imem[addr[9:2]];

assign valid = req;
    
endmodule