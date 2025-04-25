/*
What is APB?
    APB (Advanced Peripheral Bus) is part of the AMBA bus family (used in ARM SoCs).
    It’s simple, low-power, and designed for connecting to things like UARTs, timers, and GPIOs.

Task: APB Master
    You’ll implement the APB master logic that:
    Drives APB transactions to a slave
    Uses multi-cycle timing: setup → enable → done
    Supports both read and write transactions

APB Timing (Simplified Write)
    Cycle 1:
        PSEL  = 1 (slave selected)
        PWRITE = 1 (write op)
        PENABLE = 0 (setup)

    Cycle 2:
        PENABLE = 1 (access phase)
        PSEL remains 1

    Cycle 3:
        DONE → PSEL = 0, PENABLE = 0

    Read is similar, just don’t drive PWDATA.
*/

/*
Basic FSM to Control the Bus
    State	What happens
    -----   
    IDLE	Wait for start input
    SETUP	Raise PSEL, prepare PADDR, PWDATA, etc.
    ACCESS	Raise PENABLE, wait for PREADY
    DONE	Drop PSEL, go back to IDLE
*/

module apb_master #(
    parameter WIDTH = 8
) (
    input logic clk, rst, 
    // Master request
    input logic             start,
    input logic             write,
    input logic [WIDTH-1:0] addr,
    input logic [WIDTH-1:0] wdata,
    // Outputs to slave
    output logic             PSEL,
    output logic             PENABLE,
    output logic             PWRITE,
    output logic [WIDTH-1:0] PADDR,
    output logic [WIDTH-1:0] PWDATA,
    // Inputs from slave
    input logic              PREADY,
    input logic              PRDATA,
    // Master response 
    output logic             done,
    output logic [WIDTH-1:0] rdata
);


// TODO: FSM + output assignments
typedef enum logic [1:0] {     
    IDLE, SETUP, ACCESS
} state_t;

state_t state, next_state;

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        state <= IDLE;
    else 
        state <= next_state;
end

logic [WIDTH-1:0] addr_reg, wdata_reg;
logic             write_reg;
always_ff @(posedge clk) begin
    if (start) begin
        addr_reg  <= addr;
        wdata_reg <= wdata;
        write_reg <= write;
    end
end 

always_comb begin
    next_state = state;
    case (state)
        IDLE    : next_state = start ? SETUP : IDLE; 
        SETUP   : next_state = ACCESS;
        ACCESS  : next_state = (PREADY) ? IDLE : ACCESS;
        default : next_state = IDLE;
    endcase
end

always_comb begin
    // Default outputs
    PSEL    = 0;
    PENABLE = 0;
    PADDR   = 8'd0;
    PWRITE  = 0;
    PWDATA  = 8'd0;
    rdata   = 8'd0;
    case (state)
        IDLE    : ;
        SETUP   : begin
            PSEL    = 1;
            PADDR   = addr_reg;
            PWRITE  = write_reg;
            PWDATA  = wdata_reg; 
        end
        ACCESS  : begin
            PSEL = 1;
            PENABLE     = 1;
            PADDR       = addr_reg;
            PWRITE      = write_reg;
            PWDATA      = wdata_reg;
            rdata       = PRDATA;
        end
        default : begin
            PSEL = 0; PENABLE = 0; PADDR = 0; PWDATA = 0;
            PWDATA = 0; rdata= 0;
        end
    endcase
end

assign done = (state == ACCESS && PREADY);

endmodule