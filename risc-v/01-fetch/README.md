## Instruction Fetch (IF) stage

### In a single-cycle RISC-V CPU:
- Each instruction is fetched from memory.
- The Program Counter (PC) holds the address of the current instruction.
- In a basic pipeline (or single-cycle) implementation, the PC is incremented every cycle `(PC + 4)`.
- The Instruction Memory is read using PC as the address.

### Modules to Implement
1. Program Counter (PC)
   - Inputs: clk, rst, maybe pc_write
   - Output: pc
   - Behavior: Holds the current address and updates it to pc + 4 each clock cycle
  
2. Program Counter (PC)
   - Inputs: addr
   - Output: instr
   - Behavior: Returns the instruction stored at the given address

#### Data Flow
PC -----> Instruction Memory ------> instr
 |                                   
 +-> PC + 4 (next instruction)


<!--
- To preview: Ctrl+Shift+V
- To convert to pdf: F1 -> write "export" -> choose pdf
- To run waveguide simulation run in terminal: gtkwave.exe .\dump.vcd
--->
