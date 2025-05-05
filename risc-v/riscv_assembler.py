registers = {f'x{i}': i for i in range(32)}

# R-type: funct7(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |
r_type_instrs = {
    "add": {"funct7": "0000000", "funct3": "000", "opcode": "0110011"},
    "sub": {"funct7": "0100000", "funct3": "000", "opcode": "0110011"},
    "and": {"funct7": "0000000", "funct3": "111", "opcode": "0110011"},
    "or" : {"funct7": "0000000", "funct3": "110", "opcode": "0110011"},
    "slt": {"funct7": "0000000", "funct3": "010", "opcode": "0110011"},
    "nor": {"funct7": "0000001", "funct3": "100", "opcode": "0110011"},
}

# I-type: Imm(12-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) |
i_type_instrs = {
    "addi": {"funct3": "000", "opcode": "0010011"},
    "subi": {"funct3": "010", "opcode": "0010011"},
    "andi": {"funct3": "111", "opcode": "0010011"},
    "ori" : {"funct3": "110", "opcode": "0010011"},
    "slti": {"funct3": "011", "opcode": "0010011"},
    "nori": {"funct3": "001", "opcode": "0010011"},
    
}

# S-type: Imm_s1(7-bits) | rs2(5-bits) | rs1(5-bits) | funct3(3-bits) | Imm_s2(5-bits) | opcode(7-bits) |
s_type_instrs = {
    "sw": {"funct3": "010", "opcode": "0100011"},
    # "sb": {"funct3": "000", "opcode": "0100011"},
}

# I-load: Imm(12-bits) | rs1(5-bits) | funct3(3-bits) | rd(5-bits) | opcode(7-bits) | -> offset = imm[11:0]
i_load_instrs = {
    "lw": {"funct3": "010", "opcode": "0000011"},
}

def encode_nop(op):
    return (
        f"{0:032b}"
    )

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

def encode_itype(op, rd, rs1, imm):
    props = i_type_instrs[op]
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

def assemble(instr):
    parts = instr.replace(',', '').split()
    op = parts[0]
    if op in r_type_instrs:
        return encode_rtype(op, parts[1], parts[2], parts[3])
    elif op in i_type_instrs:
        return encode_itype(op, parts[1], parts[2], parts[3])
    elif op in s_type_instrs:
        return encode_stype(op, parts[1], parts[2])
    elif op in i_load_instrs:
        return encode_iload(op, parts[1], parts[2])
    elif op == "nop":
        return encode_nop(op)
    else:
        raise NotImplementedError(f"Instruction '{op}' not implemented.")

# Sample instructions
instructions = [
    "add x5, x1, x2",   # x5 = x1 + x2
    "add x6, x5, x3",   # x6 = x5 + x3
    "nop"           ,
    "addi x2, x1, 5",   # x2 = x1 + 5
    "sw x3, 8(x1)"  ,   # MEM[x1 + 8] = x3
    "sw x0, 0(x0)"  ,
    # "nop"           ,
    "lw x5, 0(x0)"  ,   # load from memory[0] into x5
]

# Generate binary output
def write_to_file(filename, instructions):
    with open(filename, "w") as f:
        for instr in instructions:
            bin_code = assemble(instr)
            hex_code = f"{int(bin_code, 2):08X}"
            f.write(f"{bin_code}\n")
            print(f"{instr:<20} -> {bin_code} -> {hex_code}")


if __name__ == "__main__":
    write_to_file("instructions.bit", instructions)