/*
Register File
    - 32 general-purpose 32-bit registers
    - 2 read ports, 1 write port
    - Register x0 is hardwired to 0
*/
import all_pkgs::*;

module regfile (
    input logic              clk,
    input logic              rst,
    input logic              wr_en,
    input logic [ADDR_W-1:0] rs1_addr,      // Read address 1
    input logic [ADDR_W-1:0] rs2_addr,      // Read address 2
    input logic [ADDR_W-1:0] rd_addr,       // Write address
    input logic [WIDTH-1:0]  rd_data,       // Write data

    output logic [WIDTH-1:0] rs1_data,
    output logic [WIDTH-1:0] rs2_data
);
    
// TODO: Declare 32 x 32-bit registers
// TODO: Asynchronous reads
// TODO: Synchronous write
// TODO: Ensure x0 is always zero

logic [WIDTH-1:0] regs [0:31];      // We want 32 registers regardless so we hardcode it 

// Write
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        for (int i = 0; i < 32; i++)
            regs[i] <= 0;
    end else if (wr_en && rd_addr != 0) begin
        regs[rd_addr] <= rd_data;
    end else begin
        regs[0] <= 0; // keep x0 wired to zero
    end
end

// Read
assign rs1_data = regs[rs1_addr];
assign rs2_data = regs[rs2_addr];

endmodule