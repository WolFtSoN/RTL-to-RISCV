module tb_round_robin_arbiter;

// Inputs
logic clk, rst;
logic [3:0] req;
// Outputs
logic [3:0] grant;

round_robin_arbiter dut (
    .clk(clk),
    .rst(rst),
    .req(req),
    .grant(grant)
);

always #5 clk = ~clk;

initial begin
    $display("---------------------------------------------");
    clk = 0; rst = 1;
    #12; rst = 0;

    for (int i = 0; i < 8; i++) begin
        req = 4'b1111;
        @(posedge clk);
        $display("T = %0t | req = %b | grant = %b | track = %d ", $time, req, grant, dut.track);
    end
    $display("---------------------------------------------");
    $finish;
end
    
endmodule