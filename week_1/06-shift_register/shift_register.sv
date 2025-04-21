/*
    - Shift Register load N-bit value when load = 1
    - Shift right on each clk edge when load = 0
    - Always shifts out LSB first -> output = LSB
*/

module shift_register #(
    parameter WIDTH = 8
) (
    input logic             clk, rst, load,
    input logic [WIDTH-1:0] data_in,

    output logic            serial_out
);

logic [WIDTH-1:0] shift_register;   // hold shifting state

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        serial_out      <= 0;
        shift_register  <= 0;
    end else begin
        if (load) 
            shift_register <= data_in;
        else begin
            shift_register <= {1'b0,shift_register[WIDTH-1:1]};
            serial_out <= shift_register[0];
        end
    end
end
    
endmodule