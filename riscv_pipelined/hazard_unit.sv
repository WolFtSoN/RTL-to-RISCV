import all_pkgs::*;

module hazard_unit (
    input logic [6:0]  ex_opcode,
    input logic [4:0]  ex_rd,
    input logic        ex_mem_to_reg,  // Load in EX stage
    input logic        ex_reg_wr_en,   

    input logic [4:0]  id_rs1,
    input logic [4:0]  id_rs2,
    input logic [6:0]  id_opcode,
    input logic        branch_taken,   // from execute_stage

    output logic       stall_if,
    output logic       stall_id,
    output logic       flush_branch,
    output logic       flush_jump
);

logic stall_4_lw, stall_4_ex_hzrd;

// Load-use hazard
assign stall_4_lw = (ex_mem_to_reg &&
                    ((ex_rd != 0) &&
                    ((ex_rd == id_rs1) || (ex_rd == id_rs2))));

// General EX hazard (ID uses result from EX alu/mul before writeback)

assign stall_4_ex_hzrd = (ex_reg_wr_en &&
                         ((ex_rd != 0) &&
                         ((ex_rd == id_rs1) || (ex_rd == id_rs2))));


// Final stall logic (stall only for unresolved hazards in EX)                        
assign stall_id = stall_4_lw || stall_4_ex_hzrd;
assign stall_if = stall_id;

endmodule