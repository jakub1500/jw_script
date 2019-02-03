import sys
import os.path
import re

DEBUG = 1
ARGS_PREDICTED_LEN = 2 # file name + file to read

def print_debug(debug_info):
    if DEBUG == 1:
        print(debug_info)

def check_if_file_exists(file_path):
    return os.path.exists(file_path)

def check_if_exists_and_recreate(file_path):
    if check_if_file_exists(new_file_name):
        print_debug("removing file {}".format(new_file_name))
        os.remove(new_file_name)
    with open(new_file_name, 'w'):  # Create file if does not exist
        print_debug("creating file {}".format(new_file_name))

def check_args(arg_list):
    if type(arg_list) is not list:
        print("kill yourself")
        print_debug("input args is not alist")
    if len(arg_list) != ARGS_PREDICTED_LEN:
        print("Give file name to read from b!tch")
        exit(1)

def check_consitiency_of_alias_line(line):
    if re.search("^alias\ .*='.*'\n$", line):
        return True
    else:
        return False

def read_aliases_lines_to_list_from_file(file_path):
    lines = []

    if not check_if_file_exists(file_path):
        print("given file not exists")
        exit(1)

    f = open(file_path, 'r')
    for line in f:
        if check_consitiency_of_alias_line(line):
            lines.append(line)
    f.close

    return lines

def process_alias_to_fnc(raw_alias): # output as string ready to write
    match = re.search("^alias\ (.*)='(.*)'\n$", raw_alias)
    print_debug("groups in match = {}".format(match.groups()))

    if len(match.groups()) != 2: # + 1 group as raw full find
        print_debug("unsupported number of group in '{}'".format(raw_alias))
        exit(1)

    full_alias = match.group(0)
    name = match.group(1)
    body = match.group(2)
    
    print_debug("// {} // {} //".format(name, body))

    output_str = "function {}\n\t{}\nend\n".format(name, body)
    return output_str

def write_alias_as_fnc_to_file(alias_list, file_name):
    with open(file_name, 'w') as f:
        for raw_alias in alias_list:
            f.write(process_alias_to_fnc(raw_alias))

# GO START!

check_args(sys.argv)

file = sys.argv[1]
new_file_name = file + "_fish"

check_if_exists_and_recreate(new_file_name)


alias_list = read_aliases_lines_to_list_from_file(file)
write_alias_as_fnc_to_file(alias_list, new_file_name)



# with open(new_file_name, 'w') as outputf, open(file, 'r') as inputf:  # Create file if does not exist
#     print_debug("creating file {}".format(new_file_name))
#     pass

