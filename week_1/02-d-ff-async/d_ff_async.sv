module d_ff_async (
    input logic clk, rst, d,

    output logic q
);

// -------------------- Solution --------------------
always_ff @( posedge clk or posedge rst ) begin
    if (rst) 
        q <= 0;
    else
        q <= d;
end

endmodule