module tb_cpu;

logic clk, rst;

cpu_single_cycle u_cpu (
    .clk(clk),
    .rst(rst)
);

always #5 clk = ~clk;

int NUM_INSTRUCTIONS = 0;

initial begin
    $display("---------------------------------------------");
    clk = 0; rst = 1;

    #10 rst = 0;

    // Initialize registers manually 
    // u_cpu.u_regfile.regs[0] = 0;    // x0 = 0
    // u_cpu.u_regfile.regs[1] = 10;   // x1 = 10
    // u_cpu.u_regfile.regs[2] = 20;   // x2 = 20
    // u_cpu.u_regfile.regs[3] = 7;    // x3 = 7

    // Instruction memory initialized from hex file
    $readmemb("instructions.bit", u_cpu.u_imem.imem);
    // for (int i = 0; i < 5; i++) begin
    //     $display("u_cpu.u_imem.imem[%0d] = %b" ,i , u_cpu.u_imem.imem[i]);
    // end

    // ######################
    // ####### R-TYPE #######     
    // ######################

    // $display("\nR-TYPE:\n-------");
    // R-type: funct7(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |

    // add x5, x1, x2 -> x5 = x1 + x2
    // add x6, x5, x3 -> x6 = x5 + x3

    // Wait some cycles to execute
    // repeat(3) @(posedge clk);
    // $display("------- add x5, x1, x2: -------");
    // $display("T = %2t | x5 = x1 + x2 = %0d" ,$time , u_cpu.u_regfile.regs[5]);
    // $display("------- add x6, x5, x3: -------");
    // $display("T = %2t | x6 = x5 + x3 = %0d" ,$time , u_cpu.u_regfile.regs[6]);


    // ######################
    // ####### I-TYPE #######     
    // ######################

    // $display("\nI-TYPE:\n-------");
    // I-type: Imm(12-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |

    // Initialize registers manually 
    // u_cpu.u_regfile.regs[1] = 42;   // x1 = 42

    // addi x2, x1, 5 -> x2 = x1 + 5 = 47
    // repeat(2) @(posedge clk);
    // $display("------- addi x2, x1, 5: -------");
    // $display("T = %2t | x1 = %0d", $time, u_cpu.u_regfile.regs[1]);
    // $display("T = %2t | x2 = x1 + 5 = %0d", $time, u_cpu.u_regfile.regs[2]);

    // ######################
    // ####### S-TYPE #######     
    // ######################

    // $display("\nS-TYPE:\n-------");
    // S-type: Imm_s1(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | Imm_s2(5-bits) | opcode(7-bits) |

    // sw x3, 8(x1) -> MEM[x1 + 8] = x3
    // repeat(2) @(posedge clk);
    // $display("------- sw x3, 8(x1): -------");
    // $display("T = %2t | x3 = %0d | x1 = %0d | offset = %0d", $time, u_cpu.u_regfile.regs[3], u_cpu.u_regfile.regs[1], 8);
    // $display("MEM[x1+8] = %0d", u_cpu.u_mem.mem[50/4]);

    // $display("------- sw x0, 0(x0): -------");
    // $display("T = %2t | x0 = %0d | offset = %0d ", $time, u_cpu.u_regfile.regs[0], 0);
    // $display("MEM[x0+0] = %0d", u_cpu.u_mem.mem[0]);

    // ######################
    // ####### I-LOAD #######     
    // ######################

    // $display("\nI-LOAD:\n-------");

    // lw x5, 0(x0) -> x5 = MEM[x0 + 0]

    // repeat(1) @(posedge clk);
    // $display("------- lw x5, 0(x0): -------");
    // $display("T = %3t | x5 = %0d", $time, u_cpu.u_regfile.regs[5]);

    // ######################
    // ####### B-TYPE #######     
    // ######################

    // $display("\nB-TYPE:\n-------");

    // repeat(6) @(posedge clk);

    // $display("T = %2t | x2 = x0 + 42 = %0d\n" ,$time , u_cpu.u_regfile.regs[2]);

    // $display("T = %2t | x3 = x0 + 30 = %0d\n" ,$time , u_cpu.u_regfile.regs[3]);

    // $display("------- beq  x2, x3, 8 -> skip next -------");

    // $display("T = %2t | x4 = x0 + 99 = %0d\n" ,$time , u_cpu.u_regfile.regs[4]);

    // $display("T = %2t | x5 = x0 + 7 = %0d\n" ,$time , u_cpu.u_regfile.regs[5]);

    // ######################
    // ####### J-TYPE #######     
    // ######################

    // $display("\nJ-TYPE:\n-------");

    // repeat(6) @(posedge clk); 

    // $display("\nT = %2t | x1 = x0 + 42 = %0d\n" ,$time , u_cpu.u_regfile.regs[1]);

    // $display("T = %2t | jal x2, 8 -> x2 = %0d\n" ,$time , u_cpu.u_regfile.regs[2]);

    // $display("T = %2t | x3 = x0 + 99 = %0d\n" ,$time , u_cpu.u_regfile.regs[3]);

    // $display("T = %2t | x4= x0 + 7 = %0d\n" ,$time , u_cpu.u_regfile.regs[4]);

    // #########################
    // ####### JARL-TYPE #######     
    // #########################    

    // $display("\nJALR-TYPE:\n-------");

    // repeat(6) @(posedge clk); 

    // $display("\nT = %2t | x1 = x0 + 4 = %0d\n" ,$time , u_cpu.u_regfile.regs[1]);

    // $display("T = %2t | jalr x2, 0(x1) -> x2 = %0d\n" ,$time , u_cpu.u_regfile.regs[2]);

    // $display("T = %2t | x3 = x0 + 99 = %0d\n" ,$time , u_cpu.u_regfile.regs[3]);

    // $display("T = %2t | x4= x0 + 7 = %0d\n" ,$time , u_cpu.u_regfile.regs[4]);

    // ###########################
    // ####### M-EXTENSION #######     
    // ###########################    

    // $display("\nM-EXTENSION:\n-------");

    // repeat(9) @(posedge clk); 

    // $display("\nT = %2t | x1 = x0 + 10 = %0d\n" ,$time , u_cpu.u_regfile.regs[1]);

    // $display("T = %2t | x2 = x0 + 3  = %0d\n" ,$time , u_cpu.u_regfile.regs[2]);

    // $display("T = %2t | upper 32 bits of signed(10 * 3): x3 = x1 * x2 = %0d\n" ,$time , u_cpu.u_regfile.regs[3]);

    // $display("T = %2t | upper 32 bits of unsigned(10 * 3): x4 = x1 * x2 = %0d\n" ,$time , u_cpu.u_regfile.regs[4]);
    
    // $display("T = %2t | upper 32 bits of unsigned(10 * 3): x5 = x1 * x2 = %0d\n" ,$time , u_cpu.u_regfile.regs[5]);
    
    // $display("T = %2t | upper 32 bits of signed(10) * unsigned(3): x6 = x1 * x2 = %0d\n" ,$time , u_cpu.u_regfile.regs[6]);
    
    // $display("T = %2t | signed: x7 = modulo(x1, x2) = %0d\n" ,$time , u_cpu.u_regfile.regs[7]);
    
    // $display("T = %2t | unsigned: x8 = modulo(x1, x2) = %0d\n" ,$time , u_cpu.u_regfile.regs[8]);


    // #############################
    // ####### Prime Checker #######     
    // ############################# 

    $display("\nPrime Checker:\n-------");

    // repeat(2*NUM_INSTRUCTIONS + 1) @(posedge clk); // Make sure to give it enough time
    wait(u_cpu.halt);

    $display("x0 = %0d", u_cpu.u_regfile.regs[0]);
    $display("x10 = %0d", u_cpu.u_regfile.regs[10]);
    $display("x1 = %0d", u_cpu.u_regfile.regs[1]);
    $display("x2 = %0d <-- isPrime", u_cpu.u_regfile.regs[2]);
    $display("x3 = %0d <-- remainder", u_cpu.u_regfile.regs[3]);
    
    $display("x2 = %0d => %s", u_cpu.u_regfile.regs[2], (u_cpu.u_regfile.regs[2] == 1) ? "prime" : "not prime");

    $display("\n---------------------------------------------");
    $finish;
end

always_ff @(posedge clk) begin
    if (!rst) begin
        $display("PC = %2d | INSTR = %b | OPCODE = %b", u_cpu.pc, u_cpu.instr, u_cpu.opcode);
    end
end

initial begin
    automatic int fd;
    string line;
    fd = $fopen("instructions.bit", "r");
    while (!$feof(fd)) begin
        void'($fgets(line, fd));
        NUM_INSTRUCTIONS++;
    end
    $fclose(fd);
    $display("Loaded %0d instructions", NUM_INSTRUCTIONS);
end

    
endmodule