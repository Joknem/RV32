import re
import sys
import os


def defrectify(defstr):
    if defstr == "\n" or defstr == "":
        defstr = ""
    elif defstr[-1] == "\n":
        defstr = defstr[:-1]
    else:
        defstr = defstr
    n = re.fullmatch(
        r"\s*(`define)\s*([0-9A-Z\_]+)\s*([0-9':bh]+)\s*",
        defstr
    )
    if n:
        tmpstr = ""
        index = 1
        for i in n.groups():
            if i == None:
                if index == 1:
                    tmpstr += f'{" ":<16s}'
                elif index == 2:
                    tmpstr += f'{" ":<16s}'
                elif index == 3:
                    tmpstr += f'{" ":<16s}'
            else:
                if index == 1:
                    tmpstr += f'{i:<16s}'
                elif index == 2:
                    tmpstr += f'{i:<16s}'
                elif index == 3:
                    tmpstr += f'{i:<16s}'
            index += 1
        return tmpstr
    else:
        return defstr

def iorectify(iostr):
    if iostr == "\n":
        iostr = ""
    elif iostr == "":
        iostr = ""
    elif iostr[-1] == "\n":
        iostr = iostr[:-1]
    else:
        iostr = iostr
    if re.fullmatch(
        r"\s*(input|output|inout)\s*(wire|reg)?\s*(\[.*\])?\s*([0-9a-zA-Z\_]+)\s*(\[[^\:]+\:[^\:]+\])?\s*(\,?)\s*(.*)",
        iostr,
    ):
        n = re.fullmatch(
            r"\s*(input|output|inout)\s*(wire|reg)?\s*(\[.*\])?\s*([0-9a-zA-Z\_]+)\s*(\[[^\:]+\:[^\:]+\])?\s*(\,?)\s*(.*)",
            iostr,
        )
        tmpstr = "    "
        index = 1
        for i in n.groups():
            if i == None:
                if index == 2:
                    tmpstr = tmpstr + f'{" ":<8s}'
                elif index == 3:
                    tmpstr = tmpstr + f'{" ":<20s}'
                elif index == 4:
                    tmpstr = tmpstr + f'{" ":<24s}'
                elif index == 5:
                    tmpstr = tmpstr + f'{" ":<20s}'
                elif index == 6:
                    tmpstr = tmpstr + f'{" ":<12s}'
                elif index == 7:
                    tmpstr = tmpstr + f'{" ":<8s}'
            else:
                if index == 1:
                    tmpstr = tmpstr + f"{i:<8s}"
                elif index == 2:
                    tmpstr = tmpstr + f"{i:<8s}"
                elif index == 3:
                    tmpstr = tmpstr + f"{i:<20s}"
                elif index == 4:
                    tmpstr = tmpstr + f"{i:<24s}"
                elif index == 5:
                    tmpstr = tmpstr + f"{i:<20s}"
                elif index == 6:
                    tmpstr = tmpstr + f"{i:<12s}"
                elif index == 7:
                    tmpstr = tmpstr + f"{i:<8s}"
            index += 1
        return tmpstr
    else:
        return iostr


def paramrectify(paramstr):
    if paramstr == "\n":
        paramstr = ""
    elif paramstr == "":
        paramstr = ""
    elif paramstr[-1] == "\n":
        paramstr = paramstr[:-1]
    else:
        paramstr = paramstr
    if re.fullmatch(
        r"\s*(localparam|parameter)\s*([0-9a-zA-Z\_]+)\s*(\=)\s*([0-9+|`a-zA-Z|\_]+)+\s*(\,)?\s*(.*)",
        paramstr,
    ):
        p = re.fullmatch(
            r"\s*(localparam|parameter)\s*([0-9a-zA-Z\_]+)\s*(\=)\s*([0-9+|`a-zA-Z|\_]+)+\s*(\,)?\s*(.*)",
            paramstr,
        )
        tmpstr = "    "
        index = 1
        for i in p.groups():
            # print(i)
            if i == None:
                if index == 2:
                    tmpstr += f'{" ":<8s}'
                elif index == 3:
                    tmpstr += f'{" ":<16s}'
                elif index == 4:
                    tmpstr += f'{" ":<20s}'
                elif index == 5:
                    tmpstr += f'{" ":<8s}'
                elif index == 6:
                    tmpstr += f'{" ":<8s}'
            else:
                if index == 1:
                    tmpstr += f"{i:<12s}"
                elif index == 2:
                    tmpstr += f"{i:<20s}"
                elif index == 3:
                    tmpstr += f"{i:<16s}"
                elif index == 4:
                    tmpstr += f"{i:<20s}"
                elif index == 5:
                    tmpstr += f"{i:<8s}"
                elif index == 6:
                    tmpstr += f"{i:<8s}"
            index += 1
        return tmpstr
    else:
        return paramstr


def varectify(varstr):
    if varstr == "\n":
        varstr = ""
    elif varstr == "":
        varstr = ""
    elif varstr[-1] == "\n":
        varstr = varstr[:-1]
    else:
        varstr = varstr
    if re.fullmatch(
        r"\s*(reg|wire)\s*(\[.*\])?\s*([0-9a-zA-Z\_]+)\s*(\[.*\])?\s*(;)\s*(.*)",
        varstr,
    ):
        q = re.fullmatch(
            r"\s*(reg|wire)\s*(\[.*\])?\s*([0-9a-zA-Z\_]+)\s*(\[.*\])?\s*(;)\s*(.*)",
            varstr,
        )
        index = 1
        tmpstr = "    "
        for i in q.groups():
            if i == None:
                if index == 2:
                    tmpstr += f'{" ":<28s}'
                elif index == 3:
                    tmpstr += f'{" ":<28s}'
                elif index == 4:
                    tmpstr += f'{" ":<16s}'
                elif index == 5:
                    tmpstr += f'{" ":<16s}'
                elif index == 6:
                    tmpstr += f'{" ":<16s}'
            else:
                if index == 1:
                    tmpstr += f"{i:<8s}"
                elif index == 2:
                    tmpstr += f"{i:<28s}"
                elif index == 3:
                    tmpstr += f"{i:<28s}"
                elif index == 4:
                    tmpstr += f"{i:<16s}"
                elif index == 5:
                    tmpstr += f"{i:<16s}"
                elif index == 6:
                    tmpstr += f"{i:<16s}"
            index += 1
        return tmpstr
    else:
        return varstr


if __name__ == "__main__":
    path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    src_dir = os.path.join(path, "user", "src")
    src_list = []
    for root, dirs, files in os.walk(src_dir):
        for file_name in files:
            if file_name.endswith('.v'):
                src_list.append(os.path.join(root, file_name))
        for src_file in src_list:
            with open(src_file, 'r') as file:
                lines = file.readlines()
            for line in lines:
                i = defrectify(line)
            with open(src_file, 'w') as file:
                for line in lines:
                    i = iorectify(line)
                    ii = paramrectify(i)
                    iii = varectify(ii)
                    iiii = defrectify(iii)
                    file.write(iiii + '\n')
    print("Format ok!")


