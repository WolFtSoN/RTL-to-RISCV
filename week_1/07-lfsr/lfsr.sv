module lfsr #(
    parameter WIDTH = 8
) (
    input logic             clk, rst,
    input logic             enable,     // only shift when enabled
    input logic [WIDTH-1:0] data_in,    // Non-zero initial value

    output logic [WIDTH-1:0] lfsr_out   // LSB that moves out of the shift register
);

// Taps
localparam tap1 = 2;
localparam tap2 = 6;

logic feedback_bit;
logic [WIDTH-1:0] shift_register;

assign feedback_bit = shift_register[tap1] ^ shift_register[tap2];

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_register <= data_in;
    end else if (enable) begin
        shift_register <= {feedback_bit,shift_register[WIDTH-1:1]};
    end

end

assign lfsr_out = shift_register;
    
endmodule