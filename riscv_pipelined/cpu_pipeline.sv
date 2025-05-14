import all_pkgs::*;

module cpu_pipelined (
    input logic clk,
    input logic rst
);

logic halt;
   
//====================
// FETCH STAGE SIGNALS
//====================
logic [WIDTH-1:0] pc, next_pc;
logic [WIDTH-1:0] instr;
logic [WIDTH-1:0] if_id_pc, if_id_instr;

//====================
// DECODE STAGE SIGNALS
//====================
logic [4:0] rs1, rs2, rd;
logic [6:0] opcode, funct7;
logic [2:0] funct3;
logic [11:0] imm_i, imm_s, imm_b, imm_j;
logic [WIDTH-1:0] reg_data1, reg_data2;
logic        reg_wr_en, alu_src, mem_wr_en, mem_rd_en, mem_to_reg;
logic signed [WIDTH-1:0] imm_ext;

logic [WIDTH-1:0] id_ex_pc, id_ex_reg1, id_ex_reg2, id_ex_imm_ext;
logic [4:0]  id_ex_rd;
logic        id_ex_reg_wr_en, id_ex_alu_src;

//====================
// EXECUTE STAGE SIGNALS
//====================
logic [WIDTH-1:0] alu_in_b, alu_result;
logic [ALU_OP-1:0]  alu_ctrl_sig;
logic        zero_flag;
logic        branch, branch_taken;
logic [2:0]  branch_op;

logic [WIDTH-1:0] ex_mem_alu_result, ex_mem_reg2;
logic [4:0]  ex_mem_rd;
logic        ex_mem_reg_wr_en;

//====================`
// MEMORY STAGE SIGNALS
//====================
logic [WIDTH-1:0] mem_data_out;
logic [WIDTH-1:0] mem_wb_alu_result, mem_wb_mem_data;
logic [4:0]  mem_wb_rd;
logic        mem_wb_reg_wr_en, mem_wb_mem_to_reg;
logic [WIDTH-1:0] mem_wb_wb_data;

//====================
// WRITEBACK STAGE SIGNALS
//====================
logic [WIDTH-1:0] pc_plus4;
logic [1:0] wb_sel;
logic [WIDTH-1:0] wb_data;


// Stages

//====================
// Fetch state
//====================

pc_register u_pc (
    .clk        (clk),
    .rst        (rst),
    .next_pc    (next_pc),
    .pc         (pc)
);

instr_mem u_imem (
    .addr   (pc),
    .instr  (instr)
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        if_id_pc    <= {WIDTH{1'b0}};
        if_id_instr <= {WIDTH{1'b0}};
    end else begin
        if_id_pc    <= pc;
        if_id_instr <= instr; 
    end
end


//====================
// Decode state
//====================

decoder u_decoder (
    .instr      (instr),
    .opcode     (opcode),
    .rd         (rd),
    .funct3     (funct3),
    .rs1        (rs1),
    .rs2        (rst2),
    .funct7     (funct7),
    .imm_i      (imm_i),
    .imm_s      (imm_s),
    .imm_b      (imm_b),
    .imm_j      (imm_j)
);

regfile u_regfile (
    .clk        (clk),
    .rst        (rst),
    .wr_en      (reg_wr_en),
    .rs1_addr   (rs1),
    .rs2_addr   (rs2),
    .rd_addr    (rd),
    .rd_data    (wb_data),
    .rs1_data   (reg_data1),
    .rs1_data   (reg_data2)
);

//====================
// Execute state
//====================

assign imm_ext = (opcode == I_TYPE)     ? {{20{imm_i[11]}}, imm_i} :
                 (opcode == S_TYPE)     ? {{20{imm_s[11]}}, imm_s} :
                 (opcode == I_LOAD)     ? {{20{imm_i[11]}}, imm_i} :
                 (opcode == B_TYPE)     ? $signed({{20{imm_b[11]}}, imm_b}) :      // RISC-V branch offsets are word-aligned, so LSB is not stored in instr — we shift left by 1 during decode to recover full byte offset
                 (opcode == J_TYPE)     ? $signed({{12{imm_j[19]}}, imm_j}) :
                 (opcode == JALR_TYPE)  ? {{20{imm_i[11]}}, imm_i} :
                 32'd0;

assign alu_in_b = (alu_src) ? imm_ext : reg_data2;

alu u_alu (
    .a          (reg_data1),
    .b          (alu_in_b),
    .alu_ctrl   (alu_ctrl_sig),
    .result     (alu_result),
    .zero       (zero_flag)
);

alu_ctrl u_alu_ctrl (
    .opcode     (opcode),
    .funct3     (funct3),
    .funct7     (funct7),
    .alu_ctrl   (alu_ctrl_sig)
);

assign branch_taken = (branch_op == BR_EQ && zero_flag) ||
                      (branch_op == BR_NE && !zero_flag) ||
                      (branch_op == BR_GE && !(reg_data1 < reg_data2));

//====================
// Memory stage
//====================
data_mem u_mem (
    .clk        (clk),
    .mem_wr_en  (mem_wr_en),
    .mem_rd_en  (mem_rd_en),
    .addr       (alu_result),
    .wr_data    (reg_data2),
    .rd_data    (mem_data_out)
);

//====================
// WriteBack stage
//====================
assign pc_plus4 = pc + 4;
assign wb_sel = (opcode == J_TYPE || opcode == JALR_TYPE)   ? 2'b10 :   // pc+4
                                               (mem_to_reg) ? 2'b01 :   // memory
                                                              2'b00;    // alu

writeback_mux u_wbmux (
    .alu_result (alu_result),
    .mem_data   (mem_data_out),
    .mem_to_reg (mem_to_reg),
    .pc_plus4   (pc_plus4),
    .wb_sel     (wb_sel),
    .wb_data    (wb_data)
);

//====================
// Control Unit stage
//====================
control_unit u_ctrl (
    .opcode     (opcode),
    .funct3     (funct3),
    .reg_wr_en  (reg_wr_en),
    .alu_src    (alu_src),
    .mem_wr_en  (mem_wr_en),
    .mem_rd_en  (mem_rd_en),
    .mem_to_reg (mem_to_reg),
    .branch     (branc),
    .branch_op  (branch_op)
);

assign next_pc =    (opcode == J_TYPE)      ? (pc + imm_ext) :
                    (opcode == JALR_TYPE)   ? ((reg_data1 + imm_ext) & ~32'd1) :
                    (branch_taken)          ? (pc + imm_ext) : 
                    pc + 4;

// To stop the tb at the right cycle                    
assign halt = (instr == HALT);                    

endmodule