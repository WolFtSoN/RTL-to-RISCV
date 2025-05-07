/*
ALU
    - Performs arithmetic and logic operations
    - Controlled via ALU control signal
*/
import all_pkgs::*;

module alu (
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic [ALU_OP-1:0] alu_ctrl,      // Control signal for op

    output logic [WIDTH-1:0] result,
    output logic             zero
);
    
// TODO: Implement ALU operation selection
// TODO: Set zero flag if result == 0

// For multiplication and division operations
logic signed [2*WIDTH-1:0] full_result;

always_comb begin 
    case (alu_ctrl)
        ALU_AND : result = a & b;                                 // AND
        ALU_OR  : result = a | b;                                 // OR 
        ALU_ADD : result = a + b;                                 // ADD
        ALU_SUB : result = a - b;                                 // SUB
        ALU_SLT : result = {{(WIDTH-1){1'b0}}, (a < b)};          // SLT - set if less than
        ALU_NOR : result = ~(a | b);                              // NOR
        ALU_MUL : begin                                           // MUL - lower 32 bits | signed × signed
                    full_result = $signed(a) * $signed(b);      
                    result = full_result[31:0]; 
                end
        ALU_MULH : begin                                          // MUL - upper 32 bits | signed × signed
                    full_result = $signed(a) * $signed(b);      
                    result = full_result[63:32]; 
        end
        ALU_MULHU : begin                                         // MUL - upper 32 bits | unsigned × unsigned
                    full_result = a * b;      
                    result = full_result[63:32]; 
        end
        ALU_MULHSU : begin                                        // MUL - upper 32 bits | signed × unsigned
                    full_result = $signed(a) * b;      
                    result = full_result[63:32]; 
        end
        ALU_REM  : result = b == 0 ? 0 : $signed(a) % $signed(b); // REM - signed % signed
        ALU_REMU : result = b == 0 ? 0 : a % b;                   // REM - unsigned % unsigned

        ALU_DIV  : result = b == 0 ? 0 : $signed(a) / $signed(b); // DIV - signed / signed
        ALU_DIVU : result = b == 0 ? 0 : a / b;                   // DIV - unsigned / unsigned
        default : result = {WIDTH{1'b0}};
    endcase
end

assign zero = (result == 0);

// always_comb begin
//     if (alu_ctrl == ALU_DIV)
//         $display("alu_ctrl = %5b | a = %0d | b = %0d", alu_ctrl, a, b);
// end

endmodule