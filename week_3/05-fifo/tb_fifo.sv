module tb_fifo;

parameter DATA_W = 8;
parameter DEPTH = 16;

// Inputs 
logic clk, rst, wr_en, rd_en;
logic [DATA_W-1:0] din;
// Outputs
logic [DATA_W-1:0] dout;
logic full, empty;

fifo #(.DATA_W(DATA_W), .DEPTH(DEPTH)) dut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);

always #5 clk = ~clk;

initial begin
    $display("---------------------------------------------");
    clk = 0; rst = 1; wr_en = 0; rd_en = 0; din = 0;

    #12; rst = 0;
    // Write to fifo
    for (int i = 1; i <= DEPTH; i++) begin
        wr_en = 1; din = i[7:0];
        @(posedge clk);
    end

    wr_en = 0; din = 0; @(posedge clk);

    // Read from fifo
    for (int i = 1; i <= DEPTH; i++) begin
        rd_en = 1; 
        @(posedge clk);
    end

    rd_en = 0; @(posedge clk);

    // Write and Read together
    wr_en = 1; rd_en = 0; din = 8'd5; @(posedge clk);
    wr_en = 1; rd_en = 1; din = 8'd10; @(posedge clk);

    wr_en = 0; rd_en = 0; @(posedge clk);
    $display("---------------------------------------------");
    $finish;
end

always @(posedge clk) begin
    $display("T = %3t | wr_en = %0b | rd_en = %0b | din = %0d | counter = %0d | dout = %0d | full = %0b | empty = %0b",
    $time, wr_en, rd_en, din, dut.counter, dout, full, empty);
end
    
endmodule