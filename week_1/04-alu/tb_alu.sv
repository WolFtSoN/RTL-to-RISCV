module tb_alu;

parameter WIDTH = 8;
parameter OPC = 3;

// Inputs
logic [WIDTH-1:0] a, b;
logic [OPC-1:0] alu_ctrl;
// Outputs
logic [WIDTH-1:0] result;

alu #(.WIDTH(WIDTH)) dut  (
    .a(a),
    .b(b),
    .alu_ctrl(alu_ctrl),
    .result(result)
);
    

initial begin
    $display("----------------------------------------------");
    $display("CTRL\t| \tA\t| \tB\t| Result");
    $display("------|---------------|---------------|-------");

    a = 8'd10; b = 8'd5;

    for (int i = 0; i < 8; i++) begin
        alu_ctrl = i[OPC-1:0];
        #1;
        $display(" %03b\t| %0d (%b)\t| %0d (%b)\t| %0d (%b)", alu_ctrl, a, a, b, b, result, result);
    end



    $display("----------------------------------------------");
    $finish;
end

endmodule