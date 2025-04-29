module tb_mem_interface;

parameter DATA_W = 8;
parameter ADDR_W = 4;

// Inputs
logic               clk, rst;
logic               req_valid, req_write;
logic [ADDR_W-1:0]  req_addr;
logic [DATA_W-1:0]  req_wdata;
// Outputs
logic               req_ready, resp_valid;
logic [DATA_W-1:0]  resp_rdata;

mem_interface #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) dut (
    .clk(clk),
    .rst(rst),
    .req_valid(req_valid),
    .req_write(req_write),
    .req_addr(req_addr),
    .req_wdata(req_wdata),
    .req_ready(req_ready),
    .resp_valid(resp_valid),
    .resp_rdata(resp_rdata)
);
    
always #5 clk = ~clk;

initial begin
    $display("---------------------------------------------");
    clk = 0; rst = 1; req_valid = 0; req_write = 0;
    req_addr = 0; req_wdata = 0;

    #12; rst = 0;

    // Write Phase
    @(posedge clk);
    req_valid = 1; req_write = 1; req_addr = 4'd0; req_wdata = 8'd10; // Write 10 to address 0
    @(posedge clk);
    req_valid = 1; req_write = 1; req_addr = 4'd1; req_wdata = 8'd20; // Write 20 to address 1
    @(posedge clk);
    req_valid = 1; req_write = 1; req_addr = 4'd2; req_wdata = 8'd30; // Write 30 to address 2
    @(posedge clk);
    req_valid = 0; req_wdata = 0;// No requests for 1 cycle

    // Read Phase
    @(posedge clk);
    req_valid = 1; req_write = 0; req_addr = 4'd0; // Read from address 0
    @(posedge clk);
    req_valid = 1; req_write = 0; req_addr = 4'd1; // Read from address 1
    @(posedge clk);
    req_valid = 1; req_write = 0; req_addr = 4'd2; // Read from address 2
    @(posedge clk);
    req_valid = 0;

    // Wait few cycles to see responses
    repeat(5) @(posedge clk);

    $display("---------------------------------------------");
    $finish;
end

// Display monitor 
always @(posedge clk) begin
    $display(" T = %2t | req_valid = %b | req_write = %b | req_addr = %d | req_wdata = %d | req_ready = %b | resp_valid = %b | resp_wdata = %d",
                $time, req_valid, req_write, req_addr, req_wdata, req_ready, resp_valid, resp_rdata);
end 

endmodule