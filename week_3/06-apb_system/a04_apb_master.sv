import a01_defines_pkg::*;

module apb_master (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    fifo_empty_i,
    input  logic [FIFO_DATA_W-1:0]  fifo_data_i,

    output logic                    fifo_rd_en_o,   // rd_en from FIFO

    // APB signals
    input  logic [DATA_W-1:0]       prdata,
    input  logic                    pready,

    output logic                    psel,
    output logic                    penable,
    output logic                    pwrite,
    output logic [ADDR_W-1:0]       paddr,
    output logic [DATA_W-1:0]       pwdata,

    // Output
    output logic                    rd_valid_o,
    output logic [DATA_W-1:0]       rd_data_o
);

typedef enum logic [2:0] {
    IDLE, READ_FIFO, WAIT_DATA, SETUP, ACCESS
} state_t;
state_t state, next_state;

logic               cmd_pwrite;
logic [ADDR_W-1:0]  cmd_paddr;
logic [DATA_W-1:0]  cmd_pwdata;

// FSM transition
always_ff @(posedge clk or posedge rst) begin
    if (rst) state <= IDLE;
    else     state <= next_state;
end

always_comb begin
    next_state = state;
    case (state)
        IDLE      : next_state = fifo_empty_i ? IDLE : READ_FIFO;
        READ_FIFO : next_state = WAIT_DATA;       // pulse rd_en
        WAIT_DATA : next_state = SETUP;           // FIFO output is valid now
        SETUP     : next_state = ACCESS;
        ACCESS    : next_state = (pready) ? IDLE : ACCESS;
        default   : next_state = IDLE;
    endcase
end

// FIFO control
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        fifo_rd_en_o <= 0;
    else
        fifo_rd_en_o <= (next_state == READ_FIFO);  // 1-cycle pulse
end

// Latch command
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        cmd_pwrite <= 0;
        cmd_paddr  <= 0;
        cmd_pwdata <= 0;
    end else if (state == SETUP) begin
        {cmd_pwrite, cmd_paddr, cmd_pwdata} <= {fifo_data_i[64], fifo_data_i[63:32], fifo_data_i[31:0]};
    end
end

// APB outputs
assign psel     = (state == SETUP || state == ACCESS);
assign penable  = (state == ACCESS);
assign pwrite   = cmd_pwrite;
assign paddr    = cmd_paddr;
assign pwdata   = cmd_pwdata;

// Data from slave
assign rd_valid_o = (state == ACCESS && pready && !cmd_pwrite);
assign rd_data_o  = prdata;

// always_ff @(posedge clk) begin
//     if (!pwrite && psel && penable)
//         $display("DEBUG MASTER: WRITE addr=%0d rd_data_o=%0d rd_valid_o=%0d", paddr, prdata, rd_valid_o);
// end

endmodule
