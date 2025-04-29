/*
Feature	            Requirement
-------             -----------
Clocked FIFO	    Synchronous (single clock domain)
Parametrized	    DATA_W (data width) + DEPTH (number of elements)
Interfaces	        wr_en, rd_en, din, dout, full, empty
Correct flow	    Write if not full, read if not empty
Circular buffer	    When reaching end, wrap around
*/

module fifo #(
    parameter DATA_W = 8,
    parameter DEPTH = 16
) (
    input logic                 clk,
    input logic                 rst,
    input logic                 wr_en,
    input logic                 rd_en,
    input logic [DATA_W-1:0]    din,

    output logic [DATA_W-1:0]   dout,
    output logic                full,
    output logic                empty
    );
    

logic [DATA_W-1:0] fifo [0:DEPTH-1];
logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr; 
logic [$clog2(DEPTH):0] counter;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        wr_ptr  <= 0;
        rd_ptr  <= 0;
        counter <= 0;
    end else begin
        if (wr_en && !full) begin      // write
            fifo[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
        end 
        if (rd_en && !empty) begin     // read
            dout <= fifo[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end

        // Counter update
        case ({wr_en && !full, rd_en && !empty})
            2'b10   : counter <= counter + 1;       // Write only
            2'b01   : counter <= counter - 1;       // Read only
            2'b11   : counter <= counter;           // Write + Read together    
            default : counter <= counter;
        endcase
    end
end

assign full = (counter == DEPTH);
assign empty = (counter == 0);

endmodule