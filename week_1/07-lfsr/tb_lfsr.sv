module tb_lfsr;

parameter WIDTH = 8;

// Inputs
logic clk, rst, enable;
logic [WIDTH-1:0] data_in;
// Outputs
logic [WIDTH-1:0] lfsr_out;

lfsr #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .data_in(data_in),
    .lfsr_out(lfsr_out)
);

always #5 clk = ~clk;

initial begin
    $display("-------------------------------------------");
    $display(" Time | enable| data_in\t| lfst_out");
    $display(" ---- | ------| -------\t| --------");

    clk = 0; rst = 1; enable = 0; data_in = 8'd85;
    #12; rst = 0; enable = 1;

    for (int i = 0; i < 20; i++) begin
        @(posedge clk);
        $display(" %4t\t| %0b\t| %b\t| %b",$time, enable, data_in, lfsr_out);
    end

    $display("-------------------------------------------");
    $finish;


end
    
endmodule