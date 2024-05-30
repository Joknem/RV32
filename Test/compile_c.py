import subprocess
import os
import sys
import re

def compile_c(src_file):
    if os.path.exists(src_file) == False:
        print("File not found: " + src_file)
        sys.exit(1)
    compile_cmd = []
    CC = "riscv64-unknown-linux-gnu-gcc"
    CFLAGS = ["-nostdlib", "-march=rv32im", "-mabi=ilp32"]
    compile_cmd.append(CC)
    compile_cmd += CFLAGS
    compile_cmd.append("-o")
    compile_cmd.append(binary_file)
    compile_cmd.append(src_file)
    subp = subprocess.Popen(compile_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    subp.wait(2)
    if subp.poll() == 0:
        print("compile success")
    else:
        print("compile failed")
        sys.exit(1)
    pass

def objdump_bin2txt(binary_file):
    objdump_cmd = []
    objdump_cmd.append("riscv64-unknown-linux-gnu-objdump")
    ARGS = ["-d", binary_file]
    objdump_cmd += ARGS
    with open(text_file, "w") as f:
        subp = subprocess.Popen(objdump_cmd, stdout=f)
        subp.wait(2)
        if subp.poll() == 0:
            print("objdump to txt success")
        else:
            print("objdump to text failed")
            sys.exit(1)

def extract_hex_instructions(file_content):
    pattern = re.compile(r'^\s+[0-9a-f]+:\s+([0-9a-f]{8})\s', re.MULTILINE | re.IGNORECASE)
    hex_instructions = pattern.findall(file_content)
    return hex_instructions

def objdump_txt2mem(text_file):
    with open(text_file, 'rb') as f:
        binary_data = f.read().decode("utf-8")
    hex_instructions = extract_hex_instructions(binary_data)
    mem_file = text_file.split(".")[0] + ".mem"
    mem_file = os.path.join(os.getcwd(), "..", "user", "data", mem_file)
    with open(mem_file, 'w') as f:
        for hex_word in hex_instructions:
            bytes = ''.join(hex_word[i: i+2] + ("\n" if i == 6 else " ") for i in range(0, len(hex_word), 2))
            f.write(bytes)
    print("objdump to mem success")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python compile_c.py <file_file>")
        sys.exit(1)
    src_file = sys.argv[1]
    # binary_file = src_file.split(".")[0] + ".elf"
    # text_file = src_file.split(".")[0] + ".txt"
    # compile_c(src_file)
    # objdump_bin2txt(binary_file)
    objdump_txt2mem(src_file)