package all_pkgs;

parameter WIDTH = 32;
parameter ADDR_W = $clog2(WIDTH);
parameter DATA_W = 32;
parameter STAGE_W = 5;
parameter ALU_OP = 4;

parameter ZERO = {WIDTH{1'b0}};

parameter BR_NONE = 3'b000;
parameter BR_EQ = 3'b010;
parameter BR_NE = 3'b001;

parameter R_TYPE   = 7'b0110011;
parameter I_TYPE   = 7'b0010011;   // addi
parameter I_LOAD   = 7'b0000011;   // lw
parameter S_TYPE   = 7'b0100011;
parameter B_TYPE   = 7'b1100011;
parameter J_TYPE   = 7'b1101111;
parameter JALR_TYPE = 7'b1100111;
    
endpackage