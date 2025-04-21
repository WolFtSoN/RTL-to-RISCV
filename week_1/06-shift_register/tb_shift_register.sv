module tb_shift_register;

parameter WIDTH = 8;

// Inputs
logic clk, rst, load;
logic [WIDTH-1:0] data_in;
// Outputs
logic serial_out;

shift_register #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .data_in(data_in),
    .serial_out(serial_out)
);

always #5 clk = ~clk;

initial begin
    $display("------------------------------------------------");
    $display(" Time\t| load\t| data_in\t| serial_out\t| shift_register");
    $display(" ----\t| ----\t| -------\t| ----------\t| --------------");
    clk = 0; rst = 1; load = 0; data_in = 8'd85;

    #12; rst = 0;

    // Load value into register
    @(posedge clk); load = 1;   // on rising edge input data_in in parallel
    @(posedge clk); load = 0;   // on next rising edge finished with inserting data

    // Shift for 2 cycles
    for (int i = 0; i < WIDTH + 2; i++) begin
        @(posedge clk); // make it work on every rising edge
        $display(" %4t\t| %0b\t| %b\t| %b\t\t| %b", $time, load, data_in, serial_out, dut.shift_register);
    end

    $display("------------------------------------------------");
    $finish;

end
    
endmodule