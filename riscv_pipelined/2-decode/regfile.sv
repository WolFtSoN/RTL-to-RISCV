/*
Purpose:
    - 32 registers, each 32 bits wide
    - Register 0 (`x0`) is always zero
    - Two read ports (`rs1`, `rs2`) - asynchronous read
    - One write port (`rd`) - synchronous write
*/

import all_pkgs::*;

module regfile (
    input logic             clk,
    input logic             rst,
    input logic             wr_en,
    input logic [4:0]       rs1_addr,
    input logic [4:0]       rs2_addr,
    input logic [4:0]       rd_addr,
    input logic [WIDTH-1:0] rd_data,

    output logic [WIDTH-1:0] rs1_data,
    output logic [WIDTH-1:0] rs2_data
);

// TODO: Declare register array
logic [WIDTH-1:0] regs [0:31];

// TODO: Write logic
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        for (int i = 0; i < 32; i++) begin
            regs[i] <= {WIDTH{1'b0}};
        end
    end
    else begin
        if (wr_en && rd_addr != 0)
            regs[rd_addr] <= rd_data; 
        else
            regs[0] <= {WIDTH{1'b0}};
    end 
end

// TODO: Read logic
assign rs1_data = regs[rs1_addr];
assign rs2_data = regs[rs2_addr];

endmodule