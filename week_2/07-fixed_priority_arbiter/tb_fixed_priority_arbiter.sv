module tb_fixed_priority_arbiter;

// Inputs
logic [3:0] req;
// Outputs
logic [3:0] grant;

fixed_priority_arbiter dut (
    .req(req),
    .grant(grant)
);

initial begin
    $display("---------------------------------------------");
    for (int i = 0; i < 16; i++) begin
        req = i[3:0];
        #1;
        $display("T = %0t | req = %b | grant = %b", $time, req, grant);
    end
    
    $display("---------------------------------------------");
    $finish;
end
    
endmodule