/*
Signal	    Direction	    Meaning
------      ---------       -------
PADDR	    in	            Address from master
PWDATA	    in	            Data to be written (for write op)
PWRITE	    in	            1 = write, 0 = read
PSEL	    in	            Slave select (must be high to start txn)
PENABLE	    in	            2nd phase: when access happens
PREADY	    out	            Slave says "I’m done"
PRDATA	    out	            Data from slave (only for read ops)

 Basic APB Slave Timing:

    Phase       PSEL        PENABLE     Action 
    -----       ----        -------     ------
    Setup        1             0        Address/Data setup
    Access       1             1        Slave performs read/write
    Done         0             X        Transaction complete

Behavior:
    If PSEL = 1 and PENABLE = 0: Setup phase    -> prepare transaction
    If PSEL = 1 and PENABLE = 1: Access phase   -> transaction occurs
    If PSEL = 0: No transaction
*/

module apb_slave #(
    parameter DATA_W = 8,
    parameter ADDR_W = 4
) (
    input logic clk, rst,
    // APB Interface
    input logic [ADDR_W-1:0]    PADDR,
    input logic [DATA_W-1:0]    PWDATA,
    input logic                 PWRITE,
    input logic                 PSEL,
    input logic                 PENABLE,

    output logic                PREADY,
    output logic [DATA_W-1:0]   PRDATA
);

// Internal memory
logic [DATA_W-1:0] mem [2**ADDR_W-1:0];

// TODO: APB Slave logic
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        PREADY <= 0;
        PRDATA <= 0;
    end else begin
        if (PSEL && PENABLE) begin        // Access phase
            PREADY <= 1;
            if (PWRITE) begin             // write
                mem[PADDR] <= PWDATA;
            end else begin
                PRDATA <= mem [PADDR];    // read
            end
        end else begin
            PREADY <= 0;
        end   
    end
end

endmodule