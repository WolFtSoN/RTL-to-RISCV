/*
Purpose:
    Given two 32-bit inputs `a` and `b`, and a control signal `alu_ctrl`, the ALU performs one of several operations:
    - Add
    - Sub
    - AND, OR, XOR
    - Shift left/right
    - Set-less-then
*/

import all_pkgs::*;

module alu (
    input logic [WIDTH-1:0]     a,
    input logic [WIDTH-1:0]     b,
    input logic [ALU_OP-1:0]    alu_ctrl,

    output logic [WIDTH-1:0]    result,
    output logic                zero
);

// For multiplication and division
logic [2*WIDTH-1:0] full_result;

// TODO: Compute ALU result based on alu_ctrl
always_comb begin
    case (alu_ctrl) 
        ALU_AND : result = a & b;
        ALU_OR  : result = a | b;
        ALU_ADD : result = a + b;
        ALU_SUB : result = a - b;
        ALU_SLT : result = {{(WIDTH-1){1'b0}},(a<b)}; 
        ALU_MUL : begin
            full_result = $signed(a) * $signed(b);
            result = full_result[31:0];
        end 
        ALU_MULH : begin
            full_result = $signed(a) * $signed(b);
            result = full_result[63:32];
        end 
        ALU_MULHU : begin
            full_result = a * b;
            result = full_result[63:32];
        end 
        ALU_MULHSU : begin
            full_result = $signed(a) * b;
            result = full_result[63:32];
        end 

        ALU_REM  : result = (b == 0) ? a : $signed(a) % $signed(b);
        ALU_REMU : result = (b == 0) ? a : a % b;

        ALU_DIV  : result = (b == 0) ? -1 : $signed(a) / $signed(b);
        ALU_DIVU : result = (b == 0) ? '1 : a / b;

        default: result = {WIDTH{1'b0}};
    endcase
end

// TODO: Set zero flag if result == 0
assign zero = (result == 0);


// always_comb begin
//     $display("ALU DEBUG: a = %0d | b = %0d | | alu_ctrl = %b | result = %0d", a, b, alu_ctrl, result);
// end

endmodule