module tb_mux;

// Inputs 
logic a, b, sel;
// Outputs
logic y;

mux2to1 dut (
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);

initial begin
    $display("--------------------------------------------------");
    $display("sel\t| a\t| b\t|| y");
    $display("------|-------|-------||------");

    for (int i = 0; i < 2; i++) begin
        for (int j = 0; j < 2; j++) begin
            for (int k = 0; k < 2; k ++) begin
                sel = i;
                a = j;
                b = k;
                #1; // Wait for propagation
                $display(" %b\t| %b\t| %b\t|| %b", sel, a, b, y);
            end
        end
    end
    
    $display("--------------------------------------------------");
    $finish;
end
    
endmodule