package all_pkgs;

parameter WIDTH = 32;
parameter ADDR_W = $clog2(WIDTH);
parameter DATA_W = 32;
parameter ALU_OP = 5;
parameter HALT = 32'b00000000000000000000000001111111;
parameter HALT_OP = 7'b1111111;

parameter ZERO = {WIDTH{1'b0}};

// ALU ctrl options:
parameter ALU_AND    = 5'b00000;
parameter ALU_OR     = 5'b00001;
parameter ALU_ADD    = 5'b00010;
parameter ALU_SUB    = 5'b00011;
parameter ALU_SLT    = 5'b00100;
parameter ALU_NOR    = 5'b00101;

parameter ALU_MUL    = 5'b00110;
parameter ALU_MULH   = 5'b00111;
parameter ALU_MULHSU = 5'b01000;
parameter ALU_MULHU  = 5'b01001;

parameter ALU_REM    = 5'b01010;
parameter ALU_REMU   = 5'b01011;

parameter ALU_DIV    = 5'b01100;
parameter ALU_DIVU   = 5'b01101;

// B-type options
parameter BR_NONE = 3'b000;
parameter BR_EQ = 3'b010;
parameter BR_NE = 3'b001;
parameter BR_GE = 3'b101;

// RISC-V formats
parameter R_TYPE   = 7'b0110011;
parameter I_TYPE   = 7'b0010011;   // addi
parameter I_LOAD   = 7'b0000011;   // lw
parameter S_TYPE   = 7'b0100011;
parameter B_TYPE   = 7'b1100011;
parameter J_TYPE   = 7'b1101111;
parameter JALR_TYPE = 7'b1100111;
    
endpackage