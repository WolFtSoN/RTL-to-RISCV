import all_pkgs::*;

module cpu_pipelined (
    input logic clk,
    input logic rst
);

logic halt;

//=====================
// FETCH -> IF/ID
//=====================
logic [WIDTH-1:0]   pc_if, instr_if, next_pc_if;
logic               if_ready;

//=====================
// DECODE -> ID/EX
//=====================
logic [WIDTH-1:0]   reg_data1_idex, reg_data2_idex, imm_ext_idex;
logic [4:0]         rs1_idex, rs2_idex,rd_idex;
logic [2:0]         funct3_idex;
logic [6:0]         funct7_idex, opcode_idex;
logic               reg_wr_en_idex, alu_src_idex, mem_wr_en_idex, mem_to_reg_idex;
logic [2:0]         branch_op_idex;
logic [1:0]         wb_sel_idex;
logic [WIDTH-1:0]   pc_idex, instr_idex, pc_plus4_idex_out;

logic [WIDTH-1:0]   pc_idex_out, reg_data1_idex_out, reg_data2_idex_out, imm_ext_idex_out;
logic [4:0]         rs1_idex_out, rs2_idex_out, rd_idex_out;
logic [2:0]         funct3_idex_out;
logic [6:0]         funct7_idex_out, opcode_idex_out;
//=====================
// EX -> EX/MEM
//=====================
logic [WIDTH-1:0]   pc_exmem, alu_result_exmem, reg_data2_exmem;
logic [4:0]         rd_exmem_out;
logic [2:0]         funct3_exmem_out;
logic [6:0]         opcode_exmem_out;
logic               zero_flag;
logic               reg_wr_en_exmem, mem_to_reg_exmem;
logic [1:0]         wb_sel_exmem;

logic [WIDTH-1:0] alu_result_exmem_out, reg_data2_exmem_out, pc_plus4_exmem_out;

//=====================
// MEM -> MEM/WB
//=====================
logic [WIDTH-1:0]   mem_data_memwb, mem_data_memwb_out, alu_result_memwb_out, pc_plus4_memwb_out;
logic [4:0]         rd_memwb_out;
logic               reg_wr_en_memwb_out, mem_to_reg_memwb_out;
logic [1:0]         wb_sel_memwb;


//=====================
// WB STAGE OUTPUTS
//=====================
logic [WIDTH-1:0]   wb_data;
logic [4:0]         wb_rd;
logic               wb_wr_en;

//=====================
// PIPELINE CONTROL
//=====================
// Add stall, flush, branch_taken, etc.
logic               stall_if, stall_id, stall_ex, stall_mem, flush, branch_taken;
logic [WIDTH-1:0]   flush_pc;
// logic               req;

//=====================
// CONTROL UNIT
//=====================
logic       reg_wr_en_cu, alu_src_cu, mem_wr_en_cu, mem_rd_en_cu, mem_to_reg_cu;
logic [2:0] branch_op_cu;
logic [1:0] wb_sel_cu;

//=====================
// FORWARDING UNIT
//=====================
logic [1:0] fwd_a_sel, fwd_b_sel;


assign stall_ex  = 1'b0;
assign stall_mem = 1'b0;

// ====== FETCH and IF/ID Instantiation ======
fetch_stage u_fetch_stage (
    .clk        (clk),
    .rst        (rst),
    .stall      (stall_if),
    .flush      (flush),
    .flush_pc   (flush_pc),
    .next_pc    (next_pc_if),

    .pc_out     (pc_if),
    .instr_out  (instr_if),
    .ready      (if_ready)
);

if_id u_if_id (
    .clk        (clk),
    .rst        (rst),
    .stall      (stall_id),
    .flush      (flush),
    .if_pc      (pc_if),
    .if_instr   (instr_if),

    .id_pc      (pc_idex),
    .id_instr   (instr_idex)
);

// always_ff @(posedge clk) begin
//     $display("FETCH DEBUG: pc_if = %0d | pc_idex = %0d", pc_if, pc_idex);
// end

// always_comb begin
//     $display("IF/ID DEBUG: pc_if = %2d | instr_if = %b | flush = %0b | flush_pc = %0d", pc_if, instr_if, flush, flush_pc);
// end

// ====== DECIDE and ID/EX Instantiation ======
decode_stage u_decode_stage (
    .clk        (clk),
    .rst        (rst),
    .id_pc      (pc_idex),
    .id_instr   (instr_idex),
    .wb_en      (wb_wr_en),
    .wb_rd      (wb_rd),
    .wb_data    (wb_data),

    .reg_data1  (reg_data1_idex),
    .reg_data2  (reg_data2_idex),
    .imm_ext    (imm_ext_idex),
    .rs1        (rs1_idex),
    .rs2        (rs2_idex),
    .rd         (rd_idex),
    .funct3     (funct3_idex),
    .funct7     (funct7_idex),
    .opcode     (opcode_idex)   
);

id_ex u_id_ex (
    .clk            (clk),
    .rst            (rst),
    .stall          (stall_ex),
    .flush          (flush),
    .id_pc          (pc_idex),
    .reg_data1      (reg_data1_idex),
    .reg_data2      (reg_data2_idex),
    .imm_ext        (imm_ext_idex),
    .rs1            (rs1_idex),
    .rs2            (rs2_idex),
    .rd             (rd_idex),
    .funct3         (funct3_idex),
    .funct7         (funct7_idex),
    .opcode         (opcode_idex),
    .reg_wr_en      (reg_wr_en_cu),
    .mem_to_reg     (mem_to_reg_cu),
    .wb_sel         (wb_sel_cu),
    .alu_src        (alu_src_cu),
    .pc_plus4       (pc_idex + 4),
    .mem_wr_en      (mem_wr_en_cu),

    .ex_pc          (pc_idex_out),
    .ex_reg_data1   (reg_data1_idex_out),
    .ex_reg_data2   (reg_data2_idex_out),
    .ex_imm_ext     (imm_ext_idex_out),
    .ex_rs1         (rs1_idex_out),
    .ex_rs2         (rs2_idex_out),
    .ex_rd          (rd_idex_out),
    .ex_funct3      (funct3_idex_out),
    .ex_funct7      (funct7_idex_out),
    .ex_opcode      (opcode_idex_out),
    .ex_reg_wr_en   (reg_wr_en_idex),
    .ex_mem_to_reg  (mem_to_reg_idex),
    .ex_wb_sel      (wb_sel_idex),
    .ex_alu_src     (alu_src_idex),
    .ex_pc_plus4    (pc_plus4_idex_out),
    .ex_mem_wr_en   (mem_wr_en_idex)
);

// always_ff @(posedge clk) begin
//     $display("WB DEBUG: flush = %0b | wb_sel_cu = %b | wb_sel_idex = %b", flush, wb_sel_cu, wb_sel_idex);
// end


// always_comb begin
//     $display("CU: opcode = %b | reg_wr_en = %b | wb_sel = %2b", opcode_idex_out, reg_wr_en_idex, wb_sel_idex);
// end

// always_comb begin
//     $display("DECODE DEBUG: pc_idex = %0d | opcode_idex = %7b | imm_ext_idex = %0d | pc_idex_out = %0d | opcode_idex_out = %7b | imm_ext_idex_out = %0d", pc_idex, opcode_idex, imm_ext_idex, pc_idex_out, opcode_idex_out, imm_ext_idex_out);
// end

// ====== EXECUTE and EX/MEM Instantiation ======
logic mem_wr_en_exmem;
execute_stage u_execute_stage (
    .clk            (clk),
    .rst            (rst),
    .ex_pc          (pc_idex_out),
    .reg_data1      (reg_data1_idex_out),
    .reg_data2      (reg_data2_idex_out),
    .imm_ext        (imm_ext_idex_out),
    .rs1            (rs1_idex_out),
    .rs2            (rs2_idex_out),
    .rd             (rd_idex_out),
    .funct3         (funct3_idex_out),
    .funct7         (funct7_idex_out),
    .opcode         (opcode_idex_out),
    .alu_src        (alu_src_idex),  
    .fwd_a_sel      (fwd_a_sel),
    .fwd_b_sel      (fwd_b_sel),
    .fwd_from_mem   (alu_result_exmem_out),
    .fwd_from_wb    (wb_data),

    .alu_result     (alu_result_exmem),
    .zero           (zero_flag),
    .branch_taken   (branch_taken)
);

ex_mem u_ex_mem (
    .clk            (clk),
    .rst            (rst),
    .stall          (stall_ex),
    .flush          (flush),

    .alu_result     (alu_result_exmem),
    .reg_data2      (reg_data2_idex_out),
    .rd             (rd_idex_out),
    .funct3         (funct3_idex_out),
    .opcode         (opcode_idex_out),
    .reg_wr_en      (reg_wr_en_idex),
    .mem_to_reg     (mem_to_reg_idex),
    .wb_sel         (wb_sel_idex),
    .pc_plus4       (pc_plus4_idex_out), 
    .mem_wr_en      (mem_wr_en_idex), 

    .mem_alu_result (alu_result_exmem_out),
    .mem_reg_data2  (reg_data2_exmem_out),
    .mem_rd         (rd_exmem_out),
    .mem_funct3     (funct3_exmem_out),
    .mem_opcode     (opcode_exmem_out),
    .mem_reg_wr_en  (reg_wr_en_exmem),
    .mem_mem_to_reg (mem_to_reg_exmem),
    .mem_wb_sel     (wb_sel_exmem),
    .mem_pc_plus4   (pc_plus4_exmem_out) ,
    .mem_mem_wr_en  (mem_wr_en_exmem)
);



// ====== MEMORY and MEM/WB Instantiation ======
memory_stage u_memory_stage (
    .clk            (clk),
    .rst            (rst),
    .mem_wr_en      (mem_wr_en_exmem),
    .mem_rd_en      (mem_rd_en_cu),
    .mem_addr       (alu_result_exmem_out),
    .mem_wr_data    (reg_data2_exmem_out),
    
    .mem_data_out   (mem_data_memwb)
);
logic [6:0] opcode_memwb_out;
mem_wb u_mem_wb (
    .clk            (clk),
    .rst            (rst),
    .stall          (stall_mem),
    .flush          (flush),
    .mem_data       (mem_data_memwb),
    .alu_result     (alu_result_exmem_out),
    .rd             (rd_exmem_out),
    .mem_to_reg     (mem_to_reg_exmem),
    .reg_wr_en      (reg_wr_en_exmem),
    .wb_sel         (wb_sel_exmem),
    .pc_plus4       (pc_plus4_exmem_out),
    .opcode         (opcode_exmem_out),

    .wb_data_mem    (mem_data_memwb_out),
    .wb_data_alu    (alu_result_memwb_out),
    .wb_rd          (rd_memwb_out),
    .wb_mem_to_reg  (mem_to_reg_memwb_out),
    .wb_reg_wr_en   (reg_wr_en_memwb_out),
    .wb_wb_sel      (wb_sel_memwb),
    .wb_pc_plus4    (pc_plus4_memwb_out),
    .wb_opcode      (opcode_memwb_out)
);

// ====== WRITEBACK Instantiation ======
writeback_stage wb_stage (
    .wb_data_mem    (mem_data_memwb_out),
    .wb_data_alu    (alu_result_memwb_out),
    .mem_to_reg     (mem_to_reg_memwb_out),
    .reg_wr_en      (reg_wr_en_memwb_out),
    .rd             (rd_memwb_out),
    .pc_plus4       (pc_plus4_memwb_out),
    .wb_sel         (wb_sel_memwb),
    
    .wb_data        (wb_data),
    .wb_wr_en       (wb_wr_en),
    .wb_rd          (wb_rd)
);

// always_comb begin
//     $display("WB DEBUG: wb_sel_memwb = %2b | wb_data = %0d | reg_wr_en = %b | rd = %b", wb_sel_memwb, wb_data, reg_wr_en_memwb_out, rd_memwb_out);
// end

// ====== CONTROL UNIT Instantiation ======
control_unit u_control (
    .opcode     (instr_idex[6:0]),      // Instead of opcode_idex to remove 1 clk delay
    .funct3     (instr_idex[14:12]),    // Instead of funct3_idex to remove 1 clk delay

    .reg_wr_en  (reg_wr_en_cu),
    .alu_src    (alu_src_cu),
    .mem_wr_en  (mem_wr_en_cu),
    .mem_rd_en  (mem_rd_en_cu),
    .mem_to_reg (mem_to_reg_cu),
    .branch_op  (branch_op_cu),
    .wb_sel     (wb_sel_cu)
);

// always_ff @(posedge clk) begin
//     $display("CU: branch_op_cu = %3b ", branch_op_cu);
// end


// ====== HAZARD UNIT Instantiation ======
logic flush_branch, flush_jump;
hazard_unit u_hazard (
    .ex_opcode      (opcode_idex_out),
    .ex_rd          (rd_idex_out),
    .ex_mem_to_reg  (mem_to_reg_idex),
    .id_rs1         (rs1_idex),
    .id_rs2         (rs2_idex),
    .id_opcode      (opcode_idex),
    .branch_taken   (branch_taken),

    .stall_if       (stall_if),
    .stall_id       (stall_id),
    .flush_branch   (flush_branch),
    .flush_jump     (flush_jump)
);
assign flush_branch = branch_taken; // comes from execute stage
assign flush_jump   = (opcode_idex_out == J_TYPE) || (opcode_idex_out == JALR_TYPE); // decode stage
assign flush = flush_branch || flush_jump;


// ====== FORWARDING UNIT Instantiation ======
forwarding_unit u_fwd (
    .ex_rs1        (rs1_idex_out),
    .ex_rs2        (rs2_idex_out),
    .mem_rd        (rd_exmem_out),
    .wb_rd         (rd_memwb_out),
    .mem_reg_wr_en (reg_wr_en_exmem),
    .wb_reg_wr_en  (reg_wr_en_memwb_out),

    .fwd_a_sel     (fwd_a_sel),
    .fwd_b_sel     (fwd_b_sel)
);


// ------ Flush Logic ------
assign flush_pc = (opcode_idex_out  == J_TYPE)    ? (pc_idex_out + imm_ext_idex_out) :
                  (opcode_idex_out  == JALR_TYPE) ? ((reg_data1_idex_out + imm_ext_idex_out) & ~32'd1) :
                  (branch_taken)                  ? (pc_idex_out + imm_ext_idex_out) : 32'd0;

// ------ PC Logic ------
// assign next_pc_if = (flush)     ? flush_pc  : 
//                     (stall_if)  ? pc_if     : pc_if + 4;

assign next_pc_if = ((opcode_idex_out == J_TYPE) || (opcode_idex_out == JALR_TYPE) || branch_taken) ? flush_pc : 
                    (stall_if) ? pc_if : pc_if + 4;

                   

// always_ff @(posedge clk) begin
//     $display("FLUSH DEBUG1: next_pc_if = %0d | imm_ext_idex = %0d | pc_idex = %0d", next_pc_if, imm_ext_idex, pc_idex);
// end

// always_ff @(posedge clk) begin
//     $display("FLUSH DEBUG2: opcode_idex = %b | imm_ext_idex = %0d | pc_idex = %0d | flush_pc = %0d", opcode_idex, imm_ext_idex, pc_idex, flush_pc);
// end

// always_ff @(posedge clk) begin
//     $display("FLUSH DEBUG3: branch_taken = %0b | flush = %b | imm_ext_idex = %0d | pc_idex = %0d | flush_pc = %0d | next_pc_if = %0d", branch_taken, flush, imm_ext_idex, pc_idex, flush_pc, next_pc_if);
// end

// To stop the tb at the right cycle                    
assign halt = (opcode_memwb_out == HALT_OP);                    

endmodule