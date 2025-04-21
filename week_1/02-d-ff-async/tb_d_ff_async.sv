module tb_d_ff_async;

// Inputs
logic clk, rst, d;
// Outputs
logic q;

d_ff_async dut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    $display("----------------------------------------------");
    $display("Time | rst\t| d | q");

    clk = 0; rst = 1; d = 0;
    #12;
    rst = 0;

    d = 1; @(posedge clk);
    $display("%4t | %0b\t| %0b | %0b", $time, rst, d, q);

    d = 0; @(posedge clk);
    $display("%4t | %0b\t| %0b | %0b", $time, rst, d, q);

    rst = 1; @(posedge clk);
    $display("%4t | %0b\t| %0b | %0b", $time, rst, d, q);

    rst = 0; @(posedge clk);
    d = 1; @(posedge clk);
    $display("%4t | %0b\t| %0b | %0b", $time, rst, d, q);

    $display("----------------------------------------------");
    $finish;
end
    
endmodule