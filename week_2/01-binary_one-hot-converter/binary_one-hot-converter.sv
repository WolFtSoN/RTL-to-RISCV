module binary_to_onehot #(
    parameter IN_WIDTH = 3
) (
    input logic [IN_WIDTH-1:0]  in,

    output logic [(1 << IN_WIDTH)-1:0] out  // (1 << IN_WIDTH) shift 1 maximum times to the left to get the max range
);

// ----------------- Solution -----------------
assign out = 1 << in;
    
endmodule