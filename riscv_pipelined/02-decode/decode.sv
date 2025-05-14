import all_pkgs::*;

module decode (
    input logic         clk,
    input logic         rst,
    input logic [WIDTH-1:0] if_id_pc,
    input logic [WIDTH-1:0] if_id_instr,
    // regfile 
    input logic             wr_en,
    input logic [ADDR_W-1:0] rs1_addr, rs2_addr, rd_addr,
    input logic [WIDTH-1:0] rd_data, 
    // outputs to id_ex pipeline register
    output logic [WIDTH-1:0] id_pc,
    output logic [4:0]       rs1, rs2,rd,
    output logic [2:0]       funct3,
    output logic [6:0]       opcode,
    output logic [6:0]       funct7,
    output logic [WIDTH-1:0] reg_data1, reg_data2,
    output logic [WIDTH-1:0] imm_ext
);

logic [11:0] imm_i, imm_s, imm_b;
logic [19:0] imm_j;

// TODO: Extract fields from instruction
assign opcode   = if_id_instr [6:0];
assign rd       = if_id_instr [11:7];
assign funct3   = if_id_instr [14:12];
assign rs1      = if_id_instr [19:15];
assign rs2      = if_id_instr [24:20];
assign funct7   = if_id_instr [31:25]; 

// TODO: Compute imm_ext from imm_i, imm_s, imm_b, imm_j
// I-type - has the same opcode, rd, funct3, rs1 | doesn't have rs2 and funct7
assign imm_i    = if_id_instr [31:20];
// S-type
assign imm_s    = {if_id_instr[31:25], if_id_instr[11:7]};
// B-type
assign imm_b    = {if_id_instr[31], if_id_instr[7] , if_id_instr[30:25], if_id_instr[11:8]};    // imm_b[11:0]  
// J-type
assign imm_j    = {if_id_instr[31], if_id_instr[19:12], if_id_instr[20], if_id_instr[30:21]};   // imm_j[19:0]

assign imm_ext = (opcode == I_TYPE || opcode == I_LOAD || opcode == JALR_TYPE) ? {{20{imm_i[11]}}, imm_i} :
                 (opcode == S_TYPE) ? {{20{imm_s[11]}}, imm_s} :
                 (opcode == B_TYPE) ? $signed({{20{imm_b[11]}}, imm_b}) :
                 (opcode == J_TYPE) ? $signed({{12{imm_j[19]}}, imm_j}) : {WIDTH{1'b0}};

// TODO: Declare 32 x 32-bit registers | Asynchronous read | Synchronous write
logic [WIDTH-1:0] regs [0:31];

// Write 
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        for (int i = 0; i < 32; i++)
            regs[i] <= 0;
    end
    else if (wr_en && rd_addr != 0) begin
        regs[rd_addr] <= rd_data;
    end
    else if (!wr_en || rd_addr == 0) begin
        regs[0] <= 0;
    end
end

// Read
assign reg_data1 = regs[rs1_addr];
assign reg_data2 = regs[rs2_addr];
    
endmodule