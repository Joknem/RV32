import re
import sys

def assemble_interpreter(code):
    code = re.sub(r'\s+','', code)
    print(code)


if __name__ == '__main__':
    if(len(sys.argv) != 2):
        print("Usage: python3 tools/assemble_interpreter.py <code>")
        exit(-1)
    code = sys.argv[1]
    assemble_interpreter(code)