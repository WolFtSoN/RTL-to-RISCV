
// ALU Ops:
// 000 - AND
// 001 - OR
// 010 - ADD
// 110 - SUB
// 111 - SLT (signed) = set if less than
// 100 - NOR (optional)

module alu #(
    parameter WIDTH = 8
) (
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic [2:0]       alu_ctrl,

    output logic [WIDTH-1:0] result
);

logic carry, overflow;

always_comb begin
    case (alu_ctrl)
        3'b000  :   result = a & b;
        3'b001  :   result = a | b;
        3'b010  :   begin
                        {carry,result} = a + b;
                        if ((a[WIDTH-1] == b[WIDTH-1]) && (a[WIDTH-1] != result[WIDTH-1]))
                            overflow = 1;
                        else
                            overflow = 0;
                    end
        3'b110  :   begin 
                        {carry,result} = a - b;
                        if ((a[WIDTH-1] != b[WIDTH-1]) && (a[WIDTH-1] != result[WIDTH-1]))
                            overflow = 1;
                        else    
                            overflow = 0;
                    end 
        3'b111  :   result = $signed(a) < $signed(b) ? 1 : 0;
        3'b100  :   result = !(a | b);
        default: result = 0;
    endcase
    
end
    
endmodule