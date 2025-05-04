module tb_cpu;

logic clk, rst;

cpu_single_cycle u_cpu (
    .clk(clk),
    .rst(rst)
);

always #5 clk = ~clk;

initial begin
    $display("---------------------------------------------");
    clk = 0; rst = 1;

    #10 rst = 0;

    // Initialize registers manually 
    u_cpu.u_regfile.regs[1] = 10;   // x1 = 10
    u_cpu.u_regfile.regs[2] = 20;   // x2 = 20
    u_cpu.u_regfile.regs[3] = 7;    // x3 = 7

    // Load instruction memory (R-type)
    // add x5, x1, x2 ->  instr = funct7(7'd0)_rs2(5'd2)_rs1(5'd1)_funct3(3'b000)_rd(5'd5)_opcode(7'b0110011)
    u_cpu.u_imem.imem[0] = 32'b0000000_00010_00001_000_00101_0110011;

    // add x6, x5, x3 -> x6 = x5 + x3
    u_cpu.u_imem.imem[1] = 32'b0000000_00011_00101_000_00110_0110011;

    // Wait some cycles to execute
    #100;

    // Observe register contents
    $display("x5 = %0d",u_cpu.u_regfile.regs[5]);
    $display("x6 = %0d",u_cpu.u_regfile.regs[6]);
    $display("---------------------------------------------");
    $finish;
end
    
endmodule