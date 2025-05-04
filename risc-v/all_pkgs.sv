package all_pkgs;

parameter WIDTH = 32;
parameter ADDR_W = $clog2(WIDTH);
parameter DATA_W = 32;
parameter STAGE_W = 5;
parameter ALU_OP = 4;

parameter ZERO = {WIDTH{1'b0}};
    
endpackage