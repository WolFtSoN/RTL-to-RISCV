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

    $display("R-TYPE:\n-------");
    // R-type: funct7(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |

    // add x5, x1, x2 ->  instr = funct7(7'd0)_rs2(5'd2)_rs1(5'd1)_funct3(3'b000)_rd(5'd5)_opcode(7'b0110011)
    u_cpu.u_imem.imem[0] = 32'b0000000_00010_00001_000_00101_0110011;

    // add x6, x5, x3 -> x6 = x5 + x3
    u_cpu.u_imem.imem[1] = 32'b0000000_00011_00101_000_00110_0110011;

    // Wait some cycles to execute
    repeat(3) @(posedge clk);

    // Observe register contents
    $display("T = %2t | x5 = %0d" ,$time , u_cpu.u_regfile.regs[5]);
    $display("T = %2t | x6 = %0d" ,$time , u_cpu.u_regfile.regs[6]);

    $display("I-TYPE:\n-------");
    // I-type: Imm(12-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |

    // Initialize registers manually 
    u_cpu.u_regfile.regs[1] = 42;   // x1 = 42

    // addi x2, x1, 5 -> x2 = x1 + 5 = 47
    u_cpu.u_imem.imem[3] = 32'b000000000101_00001_000_00010_0010011;

    repeat(3) @(posedge clk);

    $display("T = %2t | x1 = %0d", $time, u_cpu.u_regfile.regs[1]);
    $display("T = %2t | x2 = %0d", $time, u_cpu.u_regfile.regs[2]);

    $display("S-TYPE:\n-------");
    // S-type: Imm_s1(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | Imm_s2(5-bits) | opcode(7-bits) |

    // sw x3, 8(x1) -> MEM[x1 + 8] = x3
    u_cpu.u_imem.imem[6] = 32'b0000000_00011_00001_000_01000_0100011;

    repeat(3) @(posedge clk);

    $display("T = %2t | x1 = %0d", $time, u_cpu.u_regfile.regs[1]);
    $display("T = %2t | x3 = %0d", $time, u_cpu.u_regfile.regs[3]);
    $display("MEM[x1+8] <- x3 = %0d", u_cpu.u_mem.mem[50/4]);

    $display("---------------------------------------------");
    $finish;
end

// always_ff @(posedge clk) begin
//     $display("PC = %0d | INSTR = %b | OPCODE = %b | alu_result = %0d", u_cpu.pc, u_cpu.instr, u_cpu.opcode, u_cpu.alu_result);
// end
// always_ff @(posedge clk) begin
//     if (u_cpu.instr == 32'hFFFFFFFF) begin
//         $display("Simulation halted.");
//         $finish;
//     end
// end
    
endmodule