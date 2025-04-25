/*
Implement a 4-to-1 Mux using:
    assign with ternary operator ? :
    case statement inside always_comb
    if-else statement inside always_comb
*/

module mux_4to1_all (
    input logic [3:0] in,
    input logic [1:0] sel,

    output logic y_assign,
    output logic y_case,
    output logic y_ifelse
);

// ---------- 1. assign ----------
assign y_assign =   (sel == 2'b00) ? in[0] :
                    (sel == 2'b01) ? in[1] :
                    (sel == 2'b10) ? in[2] : in[3];

// ---------- 2. always_comb with case ----------
always_comb begin
    case (sel)
        2'b00   :   y_case = in[0];
        2'b01   :   y_case = in[1];
        2'b10   :   y_case = in[2];
        2'b11   :   y_case = in[3];
    endcase
end

// ---------- 3. always_comb with ifelse ----------
always_comb begin
    if (sel == 2'b00)       y_ifelse = in[0];
    else if (sel == 2'b01)  y_ifelse = in[1];
    else if (sel == 2'b10)  y_ifelse = in[2];
    else                    y_ifelse = in[3]; 
end     
    
endmodule