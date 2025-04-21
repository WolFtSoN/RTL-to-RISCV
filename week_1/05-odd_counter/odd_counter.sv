module odd_counter #(
    parameter SZ = 8   // counter size is 4 bits
) (
    input logic clk, rst,

    output logic [SZ-1:0] count_out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        count_out <= 0;
    end else begin
        if (count_out[0] == 1)  // odd number if LSB = 1
            count_out <= count_out + 1;
    end
end

/*
    Useful for clock-gating or power-saving counters
*/
    
endmodule