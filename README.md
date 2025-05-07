# RTL Design Challenges & RISC-V Single-Cycle CPU

This repository contains my end-to-end journey through RTL design, starting with foundational logic exercises and culminating in the full implementation of a **single-cycle RISC-V CPU** in SystemVerilog. It also includes a **Python-based assembler** that translates assembly instructions into machine code for simulation.

## Project Breakdown

### RTL Challenges (Weeks 1–3)

The `RTL_Challenges/` directory includes 3 weeks of hands-on SystemVerilog. These tasks solidified my understanding of:

- Logic design: muxes, decoders, counters, LFSRs
- FSMs and sequence detectors
- Priority and round-robin arbiters
- AMBA APB bus: master/slave protocols
- FIFO and memory interfaces
- Full SoC-style `apb_system` test

Each folder contains RTL modules and testbenches with waveform verification.

---

### RISC-V Single-Cycle CPU (RV32IM)
<p align="center">
  <img src="risc-v/waveform.png" alt="Waveform of Prime Checker" width="600"/><br/>
  <em>Waveform of Prime Checker</em>
</p>


The `risc-v/` directory holds a complete 32-bit RISC-V CPU implemented in SystemVerilog. Features include:

- **RV32I Base Instruction support**: 
  - **R-type**: `add`, `sub`, `and`, `or`, `slt`, `nor`  
  - **I-type**: `addi`, `subi`, `andi`, `ori`, `slti`, `nori`, `jalr`  
  - **S-type**: `sw`
  - **B-type**: `beq`, `bne`, `bge`
  - **Load**:   `lw`
  - **J-type**: `jal`
- **M-extension**:
  -  `mul`, `mulh`, `mulhsu`, `mulhu`, `rem`, `remu`, `div`, `divu`
- **Control-flow logic**: Verified with Prime Checker program
- **Assembler**: 
  - Python script (`riscv_assembler.py`) to convert human-readable assembly (e.g., `add x5, x1, x2`) into 32-bit machine code
- **Modular RTL Design**:
  - Clean separation into Fetch, Decode, Execute, Memory, Writeback, and Control stages
- **Testbench**: 
  - Loads `.hex` or `.bit` instruction files, checks register/memory state, and enables waveform-based validation

#### 🛠️ Planned Extensions:
- Add `lui`, `auipc` (U-type) to complete RV32I
- Pipeline architecture with hazard handling
- UART peripheral integration

---

**Repository Structure**

<!-- <details>
<summary><strong>Click to expand</strong></summary> -->

```
├── RTL_Challenges/
│   ├── week_1
│   │   │── 01-mux
│   │   │    │── mux_2-1.sv
│   │   │    └── tb_mux.sv
│   │   │ 
│   │   │── 02-d-ff-async
│   │   │    │── d_ff_async.sv
│   │   │    └── tb_d_ff_async.sv
│   │   │ 
│   │   │── 03-edge_detector
│   │   │    └── edge_detector.sv
│   │   │ 
│   │   │── 04-alu
│   │   │    │── alu.sv
│   │   │    └── tb_alu.sv
│   │   │ 
│   │   │── 05-odd_counter
│   │   │    │── alu.sv
│   │   │    └── tb_alu.sv
│   │   │ 
│   │   │── 06-shift_register
│   │   │    │── shift_register.sv
│   │   │    └── tb_shift_register.sv
│   │   │ 
│   │   │── 07-lfsr
│   │   │    │── lfsr.sv
│   │   │    └── tb_lfsr.sv
│   │   │ 
│   ├── week_2
│   │   │── 01-binary_one-hot-converter
│   │   │    └── binary_one-hot-converter.sv
│   │   │ 
│   │   │── 02-binary2graycode
│   │   │    └── binary2graycode.sv
│   │   │ 
│   │   │── 03-reloading_counter
│   │   │    └── reloading_counter.sv
│   │   │ 
│   │   │── 04-parallel2serial_shifter
│   │   │    │── parallel2serial_shifter.sv
│   │   │    └── tb_parallel2serial_shifter.sv
│   │   │ 
│   │   │── 05-sequence_detector_fsm
│   │   │    │── sequence_detector_fsm.sv
│   │   │    └── tb_sequence_detector_fsm.sv
│   │   │ 
│   │   │── 06-ways_to_implement_muxes
│   │   │    │── muxes.sv
│   │   │    └── tb_muxes.sv
│   │   │ 
│   │   │── 07-fixed_priority_arbiter
│   │   │    │── fixed_priority_arbiter.sv
│   │   │    └── tb_fixed_priority_arbiter.sv
│   │   │ 
│   ├── week_3
│   │   │── 01-round_robin_arbiter
│   │   │    │── round_robin_arbiter.sv
│   │   │    └── tb_round_robin_arbiter.sv
│   │   │ 
│   │   │── 02-apb_master
│   │   │    └── 02-apb_master.sv
│   │   │── 03-memory_interface
│   │   │    │── memory_interface.sv
│   │   │    └── tb_memory_interface.sv
│   │   │ 
│   │   │── 04-apb_slave
│   │   │    └── 04-apb_slave.sv
│   │   │ 
│   │   │── 05-fifo
│   │   │    │── fifo.sv
│   │   │    └── tb_fifo.sv
│   │   │ 
│   │   └── 06-apb_system
│   │        │── a01_defines_pkg.sv
│   │        │── a02_arbiter.sv
│   │        │── a03_fifo.sv
│   │        │── a04_apb_master.sv
│   │        │── a05_apb_slave.sv
│   │        │── a06_top_system.sv
│   │        └── tb_top_system.sv
│   │     
│   └── risc-v
│       │── 01-round_robin_arbiter
│       │    │── instr_mem.sv
│       │    └── pc_register.sv
|       |
│       │── 02-decode
│       │    │── decoder.sv
│       │    └── regfile.sv
|       |
│       │── 03-execute
│       │    │── alu_ctrl.sv
│       │    └── alu.sv
|       |
│       │── 04-memory
│       │    └── data_mem.sv
|       |
│       │── 05-writeback
│       │    └── writeback_mux.sv
|       |
│       │── 06-control_unit
|       |    └── control_unit.sv
|       |
|       ├── all_pkgs.sv
|       ├── cpu_single_cycle.sv
|       ├── tb_cpu.sv
|       ├── riscv_assembler.py
|       └── instructions.bit
├── run.bat
└── README.md
```

## 


### Notes:

To run testbenches:  
    Using ModelSim: Run in terminal from main directory (RTL100Challenge) `./run ./<folder containing the design.sv and tb_design.sv>` 

<!--
- To preview: Ctrl+Shift+V
- To convert to pdf: F1 -> write "export" -> choose pdf
- To run waveguide simulation run in terminal: gtkwave.exe .\dump.vcd
--->
