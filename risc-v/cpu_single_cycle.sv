import all_pkgs::*;

module cpu_single_cycle(
    input logic clk,
    input logic rst
);

logic [WIDTH-1:0] wb_data;
logic reg_wr_en, alu_src, mem_wr_en, mem_rd_en, mem_to_reg;
logic halt;
 //====================
// FETCH
//====================
logic [WIDTH-1:0] pc, next_pc;
logic [WIDTH-1:0] instr;

// PC register
// TODO: Instantiate and connect PC register
pc_register u_pc(
    .clk(clk),
    .rst(rst),
    .next_pc(next_pc),
    .pc(pc)
);

// Instruction memory (imem)
// TODO: Instantiate and connect imem
instr_mem u_imem (
    .addr(pc),
    .instr(instr)
);

//====================
// DECODE
//====================
logic [STAGE_W-1:0] rs1, rs2, rd;
logic signed [WIDTH-1:0] reg_data1, reg_data2;
logic [6:0] opcode, funct7;
logic [2:0] funct3;
logic [11:0] imm_i;
logic [11:0] imm_s;  
logic [11:0] imm_b;  
logic [19:0] imm_j;

decoder u_decoder (
    .instr(instr),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm_i(imm_i),
    .imm_s(imm_s),
    .imm_b(imm_b),
    .imm_j(imm_j)
);


// Register File
// TODO: Instantiate and connect register file
regfile u_regfile (
    .clk(clk),
    .rst(rst),
    .wr_en(reg_wr_en),
    .rs1_addr(rs1),
    .rs2_addr(rs2),
    .rd_addr(rd),
    .rd_data(wb_data),
    .rs1_data(reg_data1),
    .rs2_data(reg_data2)
);

// Immediate Generator
// TODO: Instantiate and connect immediate generator

//====================
// EXECUTE
//====================
logic signed [WIDTH-1:0]   alu_result;
logic [ALU_OP-1:0]  alu_ctrl_sig;
logic               branch_taken, branch;
logic [2:0]         branch_op;
logic               zero_flag;
logic [WIDTH-1:0]   alu_b;
logic signed [WIDTH-1:0]   imm_ext;

assign imm_ext = (opcode == I_TYPE)     ? {{20{imm_i[11]}}, imm_i} :
                 (opcode == S_TYPE)     ? {{20{imm_s[11]}}, imm_s} :
                 (opcode == I_LOAD)     ? {{20{imm_i[11]}}, imm_i} :
                 (opcode == B_TYPE)     ? $signed({{20{imm_b[11]}}, imm_b}) :      // RISC-V branch offsets are word-aligned, so LSB is not stored in instr — we shift left by 1 during decode to recover full byte offset
                 (opcode == J_TYPE)     ? $signed({{12{imm_j[19]}}, imm_j}) :
                 (opcode == JALR_TYPE)  ? {{20{imm_i[11]}}, imm_i} :
                 32'd0;

assign alu_b = (alu_src) ? imm_ext : reg_data2; // 1 = I-type , 0 = R type (B type)
// ALU
// TODO: Instantiate and connect ALU
alu u_alu (
    .a(reg_data1),
    .b(alu_b),
    .alu_ctrl(alu_ctrl_sig),
    .result(alu_result),
    .zero(zero_flag)
);

assign branch_taken =   (branch_op == BR_EQ && zero_flag) || 
                        (branch_op == BR_NE && !zero_flag) ||
                        (branch_op == BR_GE && !(reg_data1 < reg_data2));

// ALU Control
// TODO: Instantiate and connect ALU control
alu_ctrl u_alu_ctrl (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .alu_ctrl(alu_ctrl_sig)
);


//====================
// MEMORY (for load/store)
//====================
logic [WIDTH-1:0] data_mem_out;
// Data Memory
// TODO: Instantiate and connect data memory
data_mem u_mem (
    .clk(clk),
    .mem_wr_en(mem_wr_en),
    .mem_rd_en(mem_rd_en),
    .addr(alu_result),
    .wr_data(reg_data2),
    .rd_data(data_mem_out)
);

// always_comb begin
//     $display("After MEM: reg_data1 = %0d + alu_b = %0d -> alu_result = %0d", reg_data1, alu_b, alu_result);
// end

//====================
// WRITEBACK
//====================
logic [WIDTH-1:0] pc_plus4;
logic [1:0] wb_sel;

assign pc_plus4 = pc + 4;
assign wb_sel = (opcode == J_TYPE || opcode == JALR_TYPE)   ? 2'b10 :   // pc+4
                                               (mem_to_reg) ? 2'b01 :   // memory
                                                              2'b00;    // alu
// TODO: Choose between alu_result and data_mem_out for wb_data
writeback_mux u_wbmux (
    .alu_result (alu_result),
    .mem_data   (data_mem_out),
    .mem_to_reg (mem_to_reg),
    .pc_plus4   (pc_plus4),
    .wb_sel     (wb_sel),
    .wb_data    (wb_data)
);

//====================
// CONTROL UNIT
//====================
// TODO: Instantiate and connect main control unit
control_unit u_ctrl (
    .opcode      (opcode),
    .funct3      (funct3),
    .reg_wr_en   (reg_wr_en),
    .alu_src     (alu_src),
    .mem_wr_en   (mem_wr_en),
    .mem_rd_en   (mem_rd_en),
    .mem_to_reg  (mem_to_reg),
    .branch      (branch),
    .branch_op   (branch_op)
);


assign next_pc =    (opcode == J_TYPE)      ? (pc + imm_ext) :
                    (opcode == JALR_TYPE)   ? ((reg_data1 + imm_ext) & ~32'd1) :
                    (branch_taken)          ? (pc + imm_ext) : 
                    pc + 4;
                    
// To stop the tb at the right cycle                    
assign halt = (instr == HALT);

// always_comb begin
//     if (opcode == J_TYPE)
//         $display("reg_data1: %0b | imm_ext_d = %0d | imm_ext_b = %0b  | = pc %0d", reg_data1, imm_ext, imm_ext, pc);
// end

endmodule