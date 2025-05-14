import all_pkgs::*;

module if_stage (
    input logic         clk,
    input logic         rst,
    input logic [WIDTH-1:0] next_pc,

    output logic [WIDTH-1:0] pc,
    output logic [WIDTH-1:0] instr
);
localparam INSTR_SZ = 256;

// TODO: Declare intruction memory
logic [WIDTH-1:0] imem [INSTR_SZ-1:0];

// TODO: PC register 
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= {WIDTH{1'b0}};
    end 
    else begin
        pc <= next_pc;
    end
end

// TODO: Fetch instruction from imem
assign instr = imem[next_pc[9:2]]; 

endmodule