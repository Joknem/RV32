import os

def buff_count(file_name):
    with open(file_name, 'rb') as f:
        count = 0
        buf_size = 1024 * 1024
        buf = f.read(buf_size)
        while buf:
            count += buf.count(b'\n')
            buf = f.read(buf_size)
        return count

def count_all_lines(path):
    count = 0
    for root, dirs, files in os.walk(path):
        for file_name in files:
            if file_name.endswith('.v'):
                count += buff_count(os.path.join(root, file_name))
    return count

if __name__ == '__main__':
    path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    print("All verilog files have " + str(count_all_lines(path)) + " lines.")