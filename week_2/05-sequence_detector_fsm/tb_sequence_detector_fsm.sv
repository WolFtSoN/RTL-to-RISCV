module tb_sequence_detector_fsm;

// Inputs
logic clk, rst, bit_in;
// Outputs
logic detected;

sequence_detector_1011 dut(
    .clk(clk),
    .rst(rst),
    .bit_in(bit_in),
    .detected(detected)
);

always #5 clk = ~clk;

logic [6:0] bitsteam = 7'b1011011;

initial begin
    $display("---------------------------------------------");
    clk = 0; rst = 1;
    #12; rst = 0;
    
    for (int i = 6; i >= 0; i--) begin
        bit_in = bitsteam[i];
        @(posedge clk);
        $display("T = %4t | bit_in = %b | detected = %b", $time, bit_in, detected);
    end

    $display("---------------------------------------------");
    $finish;
end

endmodule