import re
import sys
import subprocess
import os

def clean_include(path):
    src_dir = os.path.join(path, "src")
    src_list = []
    for root, dirs, files in os.walk(src_dir):
        for file_name in files:
            if file_name.endswith('.v'):
                src_list.append(os.path.join(root, file_name))
    for src_file in src_list:
        with open(src_file, 'r') as file:
            lines = file.readlines()
        with open(src_file, 'w') as file:
            for line in lines:
                if re.fullmatch(r"\s*`include\s*\".*\"\s*", line):
                    line = line.replace("`", "//`")
                file.write(line)
    pass

def compile(path):
    iverilog_cmd = ['iverilog', '-o', 'a.out', path + '/sim/top.v']
    process = subprocess.Popen(iverilog_cmd)
    process.wait()

def add_include(path):
    src_dir = os.path.join(path, "src")
    src_list = []
    for root, dirs, files in os.walk(src_dir):
        for file_name in files:
            if file_name.endswith('.v'):
                src_list.append(os.path.join(root, file_name))
    for src_file in src_list:
        with open(src_file, 'r') as file:
            lines = file.readlines()
        with open(src_file, 'w') as file:
            for line in lines:
                if re.fullmatch(r"\s*//`include\s*\".*\"\s*", line):
                    line = line.replace("//`", "`")
                file.write(line)

if __name__ == '__main__':
    path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    clean_include(path)
    compile(path)
    add_include(path)
    sys.exit(0)
