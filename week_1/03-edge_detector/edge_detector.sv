module edge_detector (
    input logic clk, rst, signal_in,

    output logic detected
);
// We're trying to detect RISING EDGE
// -------------------- Solution --------------------

// Track previous value to compare with the current
logic prev_val;

always_ff @ (posedge clk or posedge rst) begin
    if (rst) begin
        detected <= 0;
        prev_val <= 0;
    end else begin
        if (prev_val == 0 && signal_in == 1)
            detected <= 1;
        else
            detected <= 0;
        prev_val <= signal_in;
    end
end

/*
    Q: What if I want to detect falling edges instead?
    A:   Just flip the logic: detected <= (prev_val == 1 && signal_in == 0);

    Q: How do we detect both Rising and Falling edges
    A:   detected <= (prev_val != signal_in) // The previous value should be different from the current
*/

endmodule