import all_pkgs::*;

module hazard_unit (
    input logic [6:0]  ex_opcode,
    input logic [4:0]  ex_rd,
    input logic        ex_mem_to_reg,  // Load in EX stage

    input logic [4:0]  id_rs1,
    input logic [4:0]  id_rs2,
    input logic [6:0]  id_opcode,
    input logic        branch_taken,   // from execute_stage

    output logic       stall_if,
    output logic       stall_id,
    output logic       flush_branch,
    output logic       flush_jump
);

assign stall_id = (ex_mem_to_reg &&
                 ((ex_rd != 0) &&
                  ((ex_rd == id_rs1) || (ex_rd == id_rs2))));

assign stall_if = stall_id;


// assign flush = branch_taken || (id_opcode == J_TYPE) || (id_opcode == JALR_TYPE);

endmodule