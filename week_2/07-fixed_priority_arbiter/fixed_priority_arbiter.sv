/*
A 4-input Fixed Priority Arbiter that:
    Accepts 4 request lines req[3:0]
    Grants one and only one output high in grant[3:0]
    Priority is fixed from lowest to highest: req[0] > req[1] > req[2] > req[3]

Truth Table Example:
    req	    grant	Explanation
    ---     -----   -----------
    0000	0000	No request
    0001	0001	Only req[0] → grant[0]
    0111	0001	grant[0] has highest priority ✅
    1110	0010	req[0] off → grant[1]
    1000	1000	only req[3] → grant[3]
*/

module fixed_priority_arbiter #(
    parameter WIDTH = 4
) (
    input logic [WIDTH-1:0] req,

    output logic [WIDTH-1:0] grant
);

always_comb begin
    casez (req)
        4'bzzz1 : grant = 4'b0001;  
        4'bzz1z : grant = 4'b0010;
        4'bz1zz : grant = 4'b0100;
        4'b1zzz : grant = 4'b1000;
        default: grant = 4'd0;
    endcase
end
    
endmodule