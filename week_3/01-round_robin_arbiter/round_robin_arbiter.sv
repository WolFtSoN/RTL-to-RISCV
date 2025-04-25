/*
A Round Robin Arbiter does fairness scheduling:
    Instead of fixed priority (req[0] > req[1] > req[2] > req[3]) like we did before...
    It rotates the priority over time so that all requesters get a fair chance.

Priority moves cyclically:
    First 0, then 1, then 2, then 3, then back to 0, etc.

 Task:
    4 request inputs: req[3:0]
    4 grant outputs: grant[3:0]
    Grant one and only one request based on a rotating priority
    Maintain a priority pointer internally    
*/

module round_robin_arbiter (
    input logic         clk, rst,
    input logic [3:0]   req,

    output logic [3:0]  grant
);

// Track the previous req
logic [1:0] track;  // there're 4 options for req so 2 bits is needed
    
always_ff @( posedge clk or posedge rst ) begin
    if (rst)
        track <= 2'd0;
    else if (req != 0) begin    // update track if req is valid
        track <= track + 1;
    end
end

always_comb begin
    grant = 4'd0;
    case (track)
        2'd0 : begin    // 4'b???1 has the most priority
            casez (req)
                4'b???1 : grant = 4'b0001;
                4'b??1? : grant = 4'b0010;
                4'b?1?? : grant = 4'b0100;
                4'b1??? : grant = 4'b1000;
                default: grant = 4'b0000;
            endcase
            end 
        2'd1 : begin    // 4'b??1? has the most priority
            casez (req)
                4'b??1? : grant = 4'b0010;
                4'b?1?? : grant = 4'b0100; 
                4'b1??? : grant = 4'b1000;
                4'b???1 : grant = 4'b0001;
                default: grant = 4'b0000;
            endcase
            end
        2'd2 : begin    // 4'b?1?? has the most priority
            casez (req)
                4'b?1?? : grant = 4'b0100;
                4'b1??? : grant = 4'b1000; 
                4'b???1 : grant = 4'b0001;
                4'b??1? : grant = 4'b0010;
                default: grant = 4'b0000;
            endcase
            end
        2'd3 : begin    // 4'b1??? has the most priority
            casez (req)     
                4'b1??? : grant = 4'b1000;
                4'b???1 : grant = 4'b0001;
                4'b??1? : grant = 4'b0010;
                4'b?1?? : grant = 4'b0100; 
                default: grant = 4'b0000;
            endcase
            end
    endcase
end

endmodule