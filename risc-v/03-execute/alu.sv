/*
ALU
    - Performs arithmetic and logic operations
    - Controlled via ALU control signal
*/
import all_pkgs::*;

module alu (
    input logic signed [WIDTH-1:0] a,
    input logic signed [WIDTH-1:0] b,
    input logic [ALU_OP-1:0] alu_ctrl,      // Control signal for op

    output logic signed [WIDTH-1:0] result,
    output logic             zero
);
    
// TODO: Implement ALU operation selection
// TODO: Set zero flag if result == 0

always_comb begin 
    case (alu_ctrl)
        4'b0000 : result = a & b;           // AND
        4'b0001 : result = a | b;           // OR 
        4'b0010 : result = a + b;           // ADD
        4'b0011 : result = a - b;           // SUB
        4'b0100 : result = (a < b);         // SLT - set if less than
        4'b0101 : result = ~(a | b);        // NOR
        default : result = {WIDTH{1'b0}};
    endcase
end

assign zero = (result == 0);

// always_comb begin
//     $display("alu_ctrl = %4b | a = %0d | b = %0d", alu_ctrl, a, b);
// end

endmodule