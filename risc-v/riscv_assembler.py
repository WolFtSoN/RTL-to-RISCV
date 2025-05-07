registers = {f'x{i}': i for i in range(32)}

# R-type: funct7(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |
r_type_instrs = {
    "add": {"funct7": "0000000", "funct3": "000", "opcode": "0110011"},
    "sub": {"funct7": "0100000", "funct3": "000", "opcode": "0110011"},
    "and": {"funct7": "0000000", "funct3": "111", "opcode": "0110011"},
    "or" : {"funct7": "0000000", "funct3": "110", "opcode": "0110011"},
    "slt": {"funct7": "0000000", "funct3": "010", "opcode": "0110011"},
    "nor": {"funct7": "0000000", "funct3": "100", "opcode": "0110011"},

    "mul"   : {"funct7": "0000001", "funct3": "000", "opcode": "0110011"},
    "mulh"  : {"funct7": "0000001", "funct3": "001", "opcode": "0110011"},
    "mulhsu": {"funct7": "0000001", "funct3": "010", "opcode": "0110011"},
    "mulhu" : {"funct7": "0000001", "funct3": "011", "opcode": "0110011"},
    "rem"   : {"funct7": "0000001", "funct3": "110", "opcode": "0110011"},
    "remu"  : {"funct7": "0000001", "funct3": "111", "opcode": "0110011"},
    "div"   : {"funct7": "0000001", "funct3": "100", "opcode": "0110011"},
    "divu"  : {"funct7": "0000001", "funct3": "101", "opcode": "0110011"},

}

# I-type: Imm(12-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |
i_type_instrs = {
    "addi": {"funct3": "000", "opcode": "0010011"},
    "subi": {"funct3": "010", "opcode": "0010011"},
    "andi": {"funct3": "111", "opcode": "0010011"},
    "ori" : {"funct3": "110", "opcode": "0010011"},
    "slti": {"funct3": "011", "opcode": "0010011"},
    "nori": {"funct3": "001", "opcode": "0010011"},

    "jalr": {"funct3": "000", "opcode": "1100111"},
    
}

# S-type: Imm_s1(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | Imm_s2(5-bits) | opcode(7-bits) |
s_type_instrs = {
    "sw": {"funct3": "000", "opcode": "0100011"},
    # "sb": {"funct3": "000", "opcode": "0100011"},
}

# I-load: Imm(12-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) | -> offset = imm[11:0]
i_load_instrs = {
    "lw": {"funct3": "000", "opcode": "0000011"},
}

# B-type: Imm_b1(7-bits)[12|10:5] | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | Imm_s2(5-bits)[4:1|11] | opcode(7-bits) |
b_type_instrs = {
    "beq": {"funct3": "010", "opcode": "1100011"},
    "bne": {"funct3": "001", "opcode": "1100011"},
    "bge": {"funct3": "101", "opcode": "1100011"},
}

# J-type: Imm_j(20-bits)[20][10:1][11][19:12] | rd(5-bits) | opcode(7-bits) |
j_type_instrs = {
    "jal": {"opcode": "1101111"},
}


# def encode_nop(op):
#     return (
#         f"{0:032b}"
#     )

def encode_rtype(op, rd, rs1, rs2):
    props = r_type_instrs[op]
    return (
        props["funct7"]
        + f"{registers[rs2]:05b}"
        + f"{registers[rs1]:05b}"
        + props["funct3"]
        + f"{registers[rd]:05b}"
        + props["opcode"]
    )

# def encode_itype(op, rd, rs1, imm):
#     props = i_type_instrs[op]
#     imm_bin = f"{int(imm) & 0xFFF:012b}"
#     return (
#         imm_bin
#         + f"{registers[rs1]:05b}"
#         + props["funct3"]
#         + f"{registers[rd]:05b}"
#         + props["opcode"]
#     )

def encode_itype(op, rd, rs1_or_imm, maybe_imm=None):
    props = i_type_instrs[op]
    if maybe_imm is not None:
        # Format: jalr rd, rs1, imm
        rs1 = rs1_or_imm
        imm = maybe_imm
    else:
        # Format: jalr rd, imm(rs1)
        imm_val, rs1 = rs1_or_imm.strip(')').split('(')
        imm = int(imm_val)

    imm_bin = f"{int(imm) & 0xFFF:012b}"
    return (
        imm_bin
        + f"{registers[rs1]:05b}"
        + props["funct3"]
        + f"{registers[rd]:05b}"
        + props["opcode"]
    )

def encode_stype(op, rs2, imm_rs1):
    props = s_type_instrs[op]
    imm_val, rs1 = imm_rs1.strip(')').split('(')
    imm = int(imm_val)
    imm_bin = f"{imm & 0xFFF:012b}"
    return (
        imm_bin[:7]
        + f"{registers[rs2]:05b}"
        + f"{registers[rs1]:05b}"
        + props["funct3"]
        + imm_bin[7:]
        + props["opcode"]
    )

def encode_btype(op, rs1, rs2, imm):
    props = b_type_instrs[op]
    imm_bin = f"{int(imm) & 0xFFF:012b}"
    imm_bin_new = imm_bin + '0'     
    return (
        imm_bin_new[0]
        + imm_bin_new[2:8]
        + f"{registers[rs2]:05b}"
        + f"{registers[rs1]:05b}"
        + props["funct3"]
        + imm_bin_new[8:12]
        + imm_bin_new[1]
        + props["opcode"]
    )


def encode_iload(op, rd, rs1):
    props = i_load_instrs[op]
    imm_val, rs1 = rs1.strip(')').split('(')
    imm = int(imm_val)
    imm_bin = f"{imm & 0xFFF:012b}"
    return (
        imm_bin
        + f"{registers[rs1]:05b}"
        + props["funct3"]
        + f"{registers[rd]:05b}"
        + props["opcode"]
    )

def encode_jtype(op, rd, imm):
    props = j_type_instrs[op]
    imm_val = int(imm)
    imm_bin = f"{imm_val & 0xFFFFF:020b}"
    return (
        imm_bin[0]            # imm[20]
        + imm_bin[10:20]      # imm[10:1]
        + imm_bin[9]          # imm[11]
        + imm_bin[1:9]        # imm[19:12]
        + f"{registers[rd]:05b}"
        + props["opcode"]
    )

def assemble(instr):
    parts = instr.replace(',', '').split()
    op = parts[0]
    if op in r_type_instrs:
        return encode_rtype(op, parts[1], parts[2], parts[3])
    if op == "li":
        # li rd, imm --> addi rd, x0, imm
        return encode_itype("addi", parts[1], "x0", parts[2])
    elif op == "nop":
        # nop --> addi x0, x0, 0
        return encode_itype("addi", "x0", "x0", "0")
    elif op == "mv":
        # mv rd, rs1 --> addi rd, rs1, 0
        return encode_itype("addi", parts[1], parts[2], "0")
    elif op == "ret":
        # ret --> jalr x0, x1, 0
        return encode_itype("jalr", "x0", "x1", "0")
    elif op == "j":
        # j label --> jal x0, label
        return encode_jtype("jal", "x0", parts[1])
    elif op in i_type_instrs:
        if len(parts) == 4: # Format: jalr x2, x1, 0
            return encode_itype(op, parts[1], parts[2], parts[3])
        else:               # Format: jalr x2, 0(x1)
            return encode_itype(op, parts[1], parts[2])
    elif op in s_type_instrs:
        return encode_stype(op, parts[1], parts[2])
    elif op in i_load_instrs:
        return encode_iload(op, parts[1], parts[2])
    elif op in b_type_instrs:
        return encode_btype(op, parts[1], parts[2], parts[3])
    elif op in j_type_instrs:
        return encode_jtype(op, parts[1], parts[2])
    elif op == "halt":
        return "00000000000000000000000001111111"
    # elif op == "nop":
    #     return encode_nop(op)
    else:
        raise NotImplementedError(f"Instruction '{op}' not implemented.")


# Sample instructions
## Test for R-type | I-type | S-type
# instructions = [
#     "add x5, x1, x2",   # x5 = x1 + x2
#     "add x6, x5, x3",   # x6 = x5 + x3
#     "nop"           ,
#     "addi x2, x1, 5",   # x2 = x1 + 5
#     "sw x3, 8(x1)"  ,   # MEM[x1 + 8] = x3
#     "sw x0, 0(x0)"  ,
#     # "nop"           ,
#     "lw x5, 0(x0)"  ,   # load from memory[0] into x5
# ]

## Test for B-type
# instructions = [
#     "addi x2, x0, 42"   ,      # x2 = 42
#     "addi x3, x0, 30"   ,      # x3 = 03
#     "bge  x2, x3, -8"   ,       # branch taken → skip next  
#     "addi x4, x0, 99"   ,      # should be skipped
#     "addi x5, x0, 7"    ,      # should execute
# ]

## Test for J-type
# instructions = [
#     "addi x1, x0, 42"   ,   # pc = 0  | x1 = x0 + 42 
#     "jal x2, -4"         ,   # pc = 4  | x2 = pc + 4 , pc = pc + 8
#     "addi x3, x0, 99"   ,   # pc = 8  | should be skipped
#     "addi x4, x0, 7"    ,   # pc = 12 | should execute
#     "halt"              ,
# ]

## Test for JARL-type
# instructions = [
#     "addi x1, x0, 4"    ,   # pc = 0  | x1 = x0 + 4 
#     "jalr x2, 8(x1)"    ,   # pc = 4  | x2 = pc + 4 , pc = x1 + 8
#     "addi x3, x0, 99"   ,   # pc = 8  | should be skipped
#     "addi x4, x0, 7"    ,   # pc = 12 | should execute
# ]

## Test for label
# instructions = [
#     "addi x5, x0, 42",
#     "done:",
#     "addi x6, x0, 99",
#     "beq x5, x6, done",
# ]

## Test for M-extension
instructions = [
    "addi x1, x0, 10"   ,     # x1 = 10
    "addi x12, x0, 12"  ,     # x12 = 12
    "addi x2, x0, 3"    ,     # x2 = 3

    "mul x3, x1, x2"    ,     # x3 = 30
    "mulh x4, x1, x2"   ,     # x4 = upper 32 bits of signed(10 * 3) = 0
    "mulhu x5, x1, x2"  ,     # x5 = upper 32 bits of unsigned(10 * 3) = 0
    "mulhsu x6, x1, x2" ,     # x6 = upper 32 bits of signed(10) * unsigned(3) = 0

    "rem x7, x1, x2"    ,     # x7 = 10 % 3 = 1
    "remu x8, x1, x2"   ,     # x8 = 10 % 3 = 1

    "div x9, x12, x2"   ,     # x9 = 12 / 3 = 4
    "divu x10, x12, x2"  ,     # x10 = 12 / 3 = 4
    "halt",
]

## Test Prime Checker
# instructions = [
#     ".text"

#     "main:"          ,               
#         "li x10, 11" ,               # pc = 0    | n = 10
#         "li x1, 2"   ,               # pc = 4    | i = 2
#         "li x2, 1"   ,               # pc = 8    | isPrime = 1 (assume prime)

#     "loop:"                      ,   
#         "bge x1, x10, done"      ,   # pc = 12   | if i >= n → done
#         "rem x3, x10, x1"        ,   # pc = 16   | x3 = x10 % x1
#         "beq x3, x0, not_prime"  ,   # pc = 20   | if rem == 0 → not_prime
#         "addi x1, x1, 1"         ,   # pc = 24   | i++
#         "j loop"                 ,   # pc = 28
    
#     "not_prime:"   ,                
#         "li x2, 0" ,                # pc = 32

#     "done:"        ,                  
#         "nop"      ,                # pc = 36      
#         # if x10 == 1 -> n is prime
#         # if x10 == 0 -> n is not prime
#     "halt",
# ]

# Generate binary output
# def write_to_file(filename, instructions):
#     with open(filename, "w") as f:
#         for instr in instructions:
#             bin_code = assemble(instr)
#             hex_code = f"{int(bin_code, 2):08X}"
#             f.write(f"{bin_code}\n")
#             print(f"{instr:<20} -> {bin_code} -> {hex_code}")

def write_to_file(filename, instructions):
    # First pass: resolve label -> PC address 
    label_map = {}
    pc = 0
    filtered_instructions = []
    for instr in instructions:
        line = instr.strip()
        if not line or line.startswith('.') or line.startswith('#'):
            continue
        if ":" in instr:
            label = instr.replace(":","").strip()
            label_map[label] = pc
        else:
            filtered_instructions.append(instr)
            pc += 4
    # print(f"label_map: {label_map} | pc: {pc}")

    # Second pass: encode with labels resolved
    with open(filename, "w") as f:
        pc = 0
        for instr in filtered_instructions:
            
            parts = instr.replace(',','').split()
            if parts[0] in b_type_instrs and parts[-1] in label_map:
                label = parts[-1]
                offset = label_map[label] - (pc)
                # print(f"label_map: {label_map} | pc: {pc} | offset: {offset}")
                instr = f"{parts[0]} {parts[1]}, {parts[2]}, {offset}"
            elif parts[0] in j_type_instrs and parts[-1] in label_map:
                label = parts[-1]
                offset = label_map[label] - (pc)
                instr = f"{parts[0]} {parts[1]}, {offset}"
            elif parts[0] == "j" and parts[-1] in label_map:
                label = parts[-1]
                offset = label_map[label] - (pc)
                instr = f"jal x0, {offset}"

            bin_code = assemble(instr)
            hex_code = f"{int(bin_code, 2):08X}"
            f.write(f"{bin_code}\n")
            print(f"{instr:<25} -> {bin_code} -> {hex_code}")
            pc += 4


if __name__ == "__main__":
    write_to_file("instructions.bit", instructions)
