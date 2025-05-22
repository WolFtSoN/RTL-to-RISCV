/*
Purpose:
    Given the inputs of id_ex:
    - Selects the correct ALU operand (`reg_data2` vs `imm_ext`)
    - Computes the ALU result
    - Computes branch condition (BEQ, BNE, BGE)
*/

import all_pkgs::*;

module execute_stage (
    input logic clk,
    input logic rst,

    input logic [WIDTH-1:0] ex_pc,
    input logic [WIDTH-1:0] reg_data1,
    input logic [WIDTH-1:0] reg_data2,
    input logic [WIDTH-1:0] imm_ext,
    input logic [4:0]       rs1,
    input logic [4:0]       rs2,
    input logic [4:0]       rd,
    input logic [2:0]       funct3,
    input logic [6:0]       funct7,
    input logic [6:0]       opcode,
    input logic             alu_src,        // Control: select reg2 or imm

    input  logic [1:0]       fwd_a_sel,      // Forwarding select for operand A
    input  logic [1:0]       fwd_b_sel,      // Forwarding select for operand B
    input  logic [WIDTH-1:0] fwd_from_mem,   // Forwarding data from MEM stage
    input  logic [WIDTH-1:0] fwd_from_wb,    // Forwarding data from WB stage

    output logic [WIDTH-1:0] alu_result,
    output logic             zero,
    output logic             branch_taken
);

logic [ALU_OP-1:0] alu_ctrl;

// TODO: Choose second operand (reg2 or imm)
logic [WIDTH-1:0] alu_operand_b;
// assign alu_operand_b = (alu_src) ? imm_ext : reg_data2; 

// Forwarding
logic [WIDTH-1:0] alu_operand_a, alu_operand_b_input;             

    // === Operand A Mux (reg_data1) ===
    always_comb begin
        case (fwd_a_sel)
            2'b00: alu_operand_a = reg_data1;
            2'b01: alu_operand_a = fwd_from_wb;
            2'b10: alu_operand_a = fwd_from_mem;
            default: alu_operand_a = reg_data1;
        endcase
    end

    // === Operand B Input Mux (reg_data2) ===
    always_comb begin
        case (fwd_b_sel)
            2'b00: alu_operand_b_input = reg_data2;
            2'b01: alu_operand_b_input = fwd_from_wb;
            2'b10: alu_operand_b_input = fwd_from_mem;
            default: alu_operand_b_input = reg_data2;
        endcase
    end

    // === Final Operand B: IMM or Forwarded Reg ===
    assign alu_operand_b = (alu_src) ? imm_ext : alu_operand_b_input;


// TODO: Instantiate alu_ctrl
alu_ctrl u_alu_ctrl (
    .opcode     (opcode),
    .funct3     (funct3),
    .funct7     (funct7),

    .alu_ctrl   (alu_ctrl)
);

// TODO: Instantiate alu
alu u_alu (
    .a          (alu_operand_a),
    .b          (alu_operand_b),
    .alu_ctrl   (alu_ctrl),

    .result     (alu_result),
    .zero       (zero)
);

// TODO: Compute branch_taken using funct3 + zero (if branch)
assign branch_taken =   (funct3 == BR_EQ && zero)   ||
                        (funct3 == BR_NE && !zero)  ||
                        (funct3 == BR_GE && !(alu_operand_a < alu_operand_b));
    

// always_comb begin
//     $display("EXECUTE DEBUG: alu_operand_a = %0d | alu_operand_b = %0d | | alu_ctrl = %b | alu_result = %0d", alu_operand_a, alu_operand_b, alu_ctrl, alu_result);
// end

// always_ff @(posedge clk) begin
//     $display("ALU DEBUG: pc=%0d | a=%0d | b=%0d | imm_ext=%0d | alu_src=%b | alu_ctrl=%b | result=%0d",
//         ex_pc, alu_operand_a, alu_operand_b, imm_ext, alu_src, alu_ctrl, alu_result);
// end

endmodule