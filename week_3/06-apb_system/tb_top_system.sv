
import a01_defines_pkg::*;

module tb_top_system;

 // Clock and reset
logic clk, rst;

// DUT I/Os
logic wr_req_i;
logic [ADDR_W-1:0] wr_addr_i;
logic [DATA_W-1:0] wr_data_i;
logic rd_req_i;
logic [ADDR_W-1:0] rd_addr_i;
logic rd_valid_o;
logic [DATA_W-1:0] rd_data_o;

// Golden memory to track expected results
localparam N = 5;
logic [DATA_W-1:0] golden_mem [0:255];
logic [ADDR_W-1:0] addr_list [0:N-1]; // for storing addresses written

top_system dut (
    .clk(clk),
    .rst(rst),
    .wr_req_i(wr_req_i),
    .wr_addr_i(wr_addr_i),
    .wr_data_i(wr_data_i),
    .rd_req_i(rd_req_i),
    .rd_addr_i(rd_addr_i),
    .rd_valid_o(rd_valid_o),
    .rd_data_o(rd_data_o)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    $display("---------------------------------------------");
    $display("Starting test...");
    rst = 1; wr_req_i = 0; rd_req_i = 0;
    wr_addr_i = 0; wr_data_i = 0; rd_addr_i = 0;

    #20; rst = 0;
    #20;
    $display("------------------Write------------------");
    // WRITE phase — store random addr & data
    for (int i = 0; i < N; i++) begin
        addr_list[i] = $urandom_range(0,255);
        write_request(addr_list[i], $urandom);
    end

    // Wait until FIFO is empty (all writes flushed)
    wait (dut.u_fifo.empty);
    @(posedge clk);


    $display("------------------Read------------------");
    // READ phase — only from addresses that were written
    for (int i = 0; i < N; i++) begin
        read_request(addr_list[i]);
    end

    $display("---------------------------------------------");
    $finish;
end

 // Tasks
task write_request(input [ADDR_W-1:0] addr, input [DATA_W-1:0] data);
    begin
        @(posedge clk);
        wr_req_i <= 1;
        wr_addr_i <= addr;
        wr_data_i <= data;
        @(posedge clk);
        wr_req_i <= 0;
        wr_addr_i <= 0;
        wr_data_i <= 0;

        golden_mem[addr] = data;  // store expected value
        $display("[%4t] WROTE: addr= %3d | data= %10d", $time, addr, data);
    end
endtask

task read_request(input [ADDR_W-1:0] addr);
    begin
        @(posedge clk);
        rd_req_i <= 1;
        rd_addr_i <= addr;
        @(posedge clk);  
        rd_req_i <= 0;
        rd_addr_i <= 0;

        // wait for valid output
        wait(rd_valid_o);
        @(posedge clk);

        if (rd_data_o === golden_mem[addr]) begin
            $display("[%4t] READ:  addr= %3d | data= %10d -> PASS", $time, addr, rd_data_o);
        end else begin
            $display("[%4t] READ:  addr= %0d | data= %01d -> FAIL (expected %10d)", 
                      $time, addr, rd_data_o, golden_mem[addr]);
        end
    end
endtask

// always_ff @(posedge clk) begin
//     if (rd_valid_o)
//         $display("[DEBUG] TB sees rd_valid_o=1 with rd_data_o=%0d", rd_data_o);
// end


endmodule