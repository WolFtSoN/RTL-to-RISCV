module tb_cpu;

logic clk, rst;

cpu_pipelined u_cpu_pipe (
    .clk(clk),
    .rst(rst)
);

always #5 clk = ~clk;   

int offset, mem_addr;

initial begin
    $display("---------------------------------------------");
    clk = 0; rst = 1;

    #10 rst = 0;

    // Initialize registers manually 
    // u_cpu_pipe.u_decode_stage.u_regfile.regs[0] = 0;    // x0 = 0
    // u_cpu_pipe.u_decode_stage.u_regfile.regs[1] = 10;   // x1 = 10
    // u_cpu_pipe.u_decode_stage.u_regfile.regs[2] = 20;   // x2 = 20
    // u_cpu_pipe.u_decode_stage.u_regfile.regs[3] = 7;    // x3 = 7
    

    // Instruction memory initialized from hex file
    $readmemb("instructions.bit", u_cpu_pipe.u_fetch_stage.u_instr_mem.imem);
    // for (int i = 0; i < 10; i++) begin
    // $display("IMEM[%0d] = %b", i, u_cpu_pipe.u_fetch_stage.u_instr_mem.imem[i]);
    // end
    // for (int i = 0; i < 5; i++) begin
    //     $display("u_cpu_pipe.u_imem.imem[%0d] = %b" ,i , u_cpu_pipe.u_imem.imem[i]);
    // end

    // ######################
    // ####### R-TYPE #######     
    // ######################

    // $display("\nR-TYPE:\n-------");
    // R-type: funct7(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |

    // add x5, x1, x2 -> x5 = x1 + x2
    // add x6, x5, x3 -> x6 = x5 + x3

    // wait(u_cpu_pipe.halt);
    // $display("------- add x5, x1, x2: -------");
    // $display("T = %2t | x1 = %0d" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[1]);
    // $display("T = %2t | x2 = %0d" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[2]);
    // $display("T = %2t | x3 = %0d" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[3]);
    // $display("T = %2t | x5 = x1 + x2 = %0d" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[5]);
    // $display("------- add x6, x5, x3: -------");
    // $display("T = %2t | x6 = x5 + x3 = %0d" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[6]);

    // ######################
    // ####### I-TYPE #######     
    // ######################

    // $display("\nI-TYPE:\n-------");
    // // I-type: Imm(12-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |

    // // Initialize registers manually 
    // u_cpu_pipe.u_decode_stage.u_regfile.regs[1] = 42;   // x1 = 42

    // // addi x2, x1, 5 -> x2 = x1 + 5 = 47

    // wait(u_cpu_pipe.halt);
    // $display("------- addi x2, x1, 5: -------");
    // $display("T = %2t | x1 = %0d", $time, u_cpu_pipe.u_decode_stage.u_regfile.regs[1]);
    // $display("T = %2t | x2 = x1 + 5 = %0d", $time, u_cpu_pipe.u_decode_stage.u_regfile.regs[2]);

    // ######################
    // ####### S-TYPE #######     
    // ######################

    // $display("\nS-TYPE:\n-------");
    // // S-type: Imm_s1(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | Imm_s2(5-bits) | opcode(7-bits) |

    // u_cpu_pipe.u_decode_stage.u_regfile.regs[1] = 10;   // x1 = 10
    // u_cpu_pipe.u_decode_stage.u_regfile.regs[3] = 99;   // x3 = 99

    // // sw x3, 8(x1) -> MEM[x1 + 8] = x3
    // offset = 8;
    // mem_addr = (u_cpu_pipe.u_decode_stage.u_regfile.regs[1] + offset) >> 2;

    // wait(u_cpu_pipe.halt);
    // $display("------- sw x3, 8(x1): -------");
    // $display("T = %2t | x3 = %0d | x1 = %0d | offset = %0d", $time, u_cpu_pipe.u_decode_stage.u_regfile.regs[3], u_cpu_pipe.u_decode_stage.u_regfile.regs[1], 8);
    // $display("MEM[x1+8] = %0d",  u_cpu_pipe.u_memory_stage.mem[mem_addr]);

    // $display("------- sw x0, 0(x0): -------");
    // $display("T = %2t | x0 = %0d | offset = %0d ", $time, u_cpu_pipe.u_decode_stage.u_regfile.regs[0], 0);
    // $display("MEM[x0+0] = %0d",  u_cpu_pipe.u_memory_stage.mem[0]);

    // ######################
    // ####### I-LOAD #######     
    // ######################

    // $display("\nI-LOAD:\n-------");

    // // lw x5, 12(x0) -> x5 = MEM[x0 + 12]

    // u_cpu_pipe.u_memory_stage.mem[3] = 99;
    // wait(u_cpu_pipe.halt);
    // $display("------- lw x5, 12(x0): -------");
    // $display("x5 = %0d\n", u_cpu_pipe.u_decode_stage.u_regfile.regs[5]);

    // ######################
    // ####### B-TYPE #######     
    // ######################

    // $display("\nB-TYPE:\n-------");

    // wait(u_cpu_pipe.halt);

    // $display("T = %2t | x2 = x0 + 42 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[2]);

    // $display("T = %2t | x3 = x0 + 30 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[3]);

    // $display("------- beq  x2, x3, 8 -> skip next -------");

    // $display("T = %2t | x4 = x0 + 99 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[4]);

    // $display("T = %2t | x5 = x0 + 7 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[5]);

    // ######################
    // ####### J-TYPE #######     
    // ######################

    // $display("\nJ-TYPE:\n-------");

    // wait(u_cpu_pipe.halt);

    // $display("\nT = %2t | x1 = x0 + 42 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[1]);

    // $display("T = %2t | jal x2, 8 -> x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[2]);

    // $display("T = %2t | x3 = x0 + 99 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[3]);

    // $display("T = %2t | x4= x0 + 7 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[4]);

    // #########################
    // ####### JARL-TYPE #######     
    // #########################    

    // $display("\nJALR-TYPE:\n-------");

    // wait(u_cpu_pipe.halt);

    // $display("\nT = %2t | x1 = x0 + 4 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[1]);

    // $display("T = %2t | jalr x2, 0(x1) -> x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[2]);

    // $display("T = %2t | x3 = x0 + 99 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[3]);

    // $display("T = %2t | x4= x0 + 7 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[4]);

    // ###########################
    // ####### M-EXTENSION #######     
    // ###########################    

    // $display("\nM-EXTENSION:\n-------");

    // wait(u_cpu_pipe.halt);
    // // repeat(20) @(posedge clk);

    // $display("\nT = %2t | x1 = x0 + 10 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[1]);

    // $display("T = %2t | x12 = x0 + 12  = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[12]);

    // $display("T = %2t | x2 = x0 + 3  = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[2]);

    // $display("T = %2t | upper 32 bits of signed(10 * 3): x3 = x1 * x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[3]);

    // $display("T = %2t | upper 32 bits of unsigned(10 * 3): x4 = x1 * x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[4]);
    
    // $display("T = %2t | upper 32 bits of unsigned(10 * 3): x5 = x1 * x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[5]);
    
    // $display("T = %2t | upper 32 bits of signed(10) * unsigned(3): x6 = x1 * x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[6]);
    
    // $display("T = %2t | signed: x7 = modulo(x1, x2) = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[7]);
    
    // $display("T = %2t | unsigned: x8 = modulo(x1, x2) = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[8]);

    // $display("T = %2t | signed: x9 = x12 / x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[9]);

    // $display("T = %2t | unsigned: x10 = x12 / x2 = %0d\n" ,$time , u_cpu_pipe.u_decode_stage.u_regfile.regs[10]);


    // #############################
    // ####### Prime Checker #######     
    // ############################# 

    $display("\nPrime Checker:\n-------");

    wait(u_cpu_pipe.halt);

    $display("\nN = %0d", u_cpu_pipe.u_decode_stage.u_regfile.regs[10]);
    $display("x3 = %0d <-- remainder", u_cpu_pipe.u_decode_stage.u_regfile.regs[3]);
    
    $display("x2 = %0d => N is: %0s", u_cpu_pipe.u_decode_stage.u_regfile.regs[2], (u_cpu_pipe.u_decode_stage.u_regfile.regs[2] == 1) ? "Prime" : "Not Prime");

    $display("\n---------------------------------------------");
    $finish;
end

always_ff @(posedge clk) begin
    if (!rst && u_cpu_pipe.instr_idex != '0) begin
        $display("PC = %2d | INSTR = %b | OPCODE = %b", u_cpu_pipe.pc_idex, u_cpu_pipe.instr_idex, u_cpu_pipe.opcode_idex);
    end
end
    
endmodule