/*
binary = 4'b0110  (6 in binary)
        >> 1  = 4'b0011
------------------------------
gray   = 4'b0101

*/

module binary_to_gray #(
    parameter WIDTH = 4
) (
    input logic [WIDTH-1:0] binary,

    output logic [WIDTH-1:0] gray
);

assign gray = binary ^ (binary >> 1);

endmodule

/*
Why Use Gray Code?
    Reduces errors due to bit transition glitches in hardware
    Used in:
        Rotational encoders
        FIFO pointers across clock domains
        Error detection
*/