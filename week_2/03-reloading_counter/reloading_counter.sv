/*
Design a counter that:
    Counts down from a reload value
    When it hits 0, it reloads itself automatically
    Has a tick output that pulses every time it reloads
*/

module reload_counter #(
    parameter WIDTH = 4
) (
    input logic         clk, rst,
    input logic [WIDTH-1:0] reload_value,

    output logic [WIDTH-1:0] counter,
    output logic             tick
);

// ------------- Solution -------------

always_ff @( posedge clk or posedge rst ) begin
    if (rst) begin
        counter <= reload_value;
        tick    <= 0; 
    end else begin
        if (counter == 0) begin
            tick <= 1;
            counter <= reload_value;
        end else begin
            tick <= 0;
            counter <= counter - 1;
        end
    end
end
    
endmodule