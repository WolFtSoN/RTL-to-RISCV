/*
With FSM detect 1011
Mealy-style output(assert detected during transition)
*/

/* States
S0          -> 0(S0) | 1(S1)
S1(01)      -> 1(S1) | 0(S2)
S2(010)     -> 0(S0) | 1(S3)
S3(0101)    -> 0(S2) | 1(S4)
S4(01011)   -> 0(S2) | 1(S1) | detected = 1
*/

module sequence_detector_1011 (
    input logic clk, rst, bit_in,

    output logic detected
);

typedef enum logic [2:0] {
    S0, S1, S2, S3, S4 } state_t;
state_t state, next_state;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
    case (state)
        S0  :   next_state = bit_in ? S1 : S0;
        S1  :   next_state = bit_in ? S1 : S2;
        S2  :   next_state = bit_in ? S3 : S0;
        S3  :   next_state = bit_in ? S4 : S2;
        S4  :   next_state = bit_in ? S1 : S2; 
        default: next_state = S0;
    endcase
end

assign detected = (state == S3 && bit_in);  // We want detected to be high in the same cycle we transition to S4 (Mealy-style) | state == S4 (Moore-style) Output changes only on state transition (next clock)
    
// DEBUG
// always_comb begin
//     $display("state = %b | bit_in = %b", state, bit_in);
// end

endmodule