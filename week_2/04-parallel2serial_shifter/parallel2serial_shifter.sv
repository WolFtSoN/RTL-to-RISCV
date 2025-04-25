/*
Design a module that:
    - Loads a parallel data word when load = 1
    - Shifts the work out serially(LSB first) one bit per clock
    - Asserts valid = 1 when a valid bit is being output
    - Clears valid once all bits have been shifted
*/

module parallel2serial #(
    parameter WIDTH = 8
) (
    input logic             clk, rst, load,
    input logic [WIDTH-1:0] data_in,

    output logic            serial_out, valid
);

logic [WIDTH-1:0] shifter;
logic [$clog2(WIDTH)-1:0] counter;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        shifter     <= 0;
        counter     <= 0;
        valid       <= 0;
        serial_out  <= 0;
    end else begin
        if (load) begin
            shifter <= data_in;
            valid   <= 1; 
            counter <= 0;
        end else begin
            if (valid) begin
                shifter     <= {1'b0, shifter[WIDTH-1:1]};
                serial_out  <= shifter[0];
                counter     <= counter + 1'b1; 

                if (counter == WIDTH-1)
                    valid <= 0;
            end
        end
    end
end
    
    // always_comb begin
    //     $display("load = %b, shifter = %b",load, shifter);
    // end

endmodule