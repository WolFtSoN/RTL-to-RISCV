module tb_parallel2serial_shifter;

parameter WIDTH = 8;

// Inputs 
logic clk, rst, load;
logic [WIDTH-1:0] data_in;
// Outputs
logic serial_out, valid;

parallel2serial #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .data_in(data_in),
    .serial_out(serial_out),
    .valid(valid)
);

always #5 clk = ~clk;

initial begin
    $display("-----------------------------------------------");
    $display(" Time | load\t| serial_out\t| valid\t| shift_value\t| counter");
    $display(" ---- | ----\t| ----------\t| -----\t| -----------\t| -------");

    clk = 0; rst = 1; load = 0; data_in = 8'b10101010;
    #12; rst = 0;

    // Load data into shifter - load goes high for 1 cycle
    @(posedge clk); load = 1;
    @(posedge clk); load = 0;

    // Observe shifting
    for (int i = 0; i < WIDTH + 2; i++) begin
        @(posedge clk);
        $display("%4t \t| %0b\t| %b\t\t| %b\t| %b\t| %d ", $time, load, serial_out, valid, dut.shifter, dut.counter);
    end
    $display("-----------------------------------------------");
    $finish;
end

endmodule