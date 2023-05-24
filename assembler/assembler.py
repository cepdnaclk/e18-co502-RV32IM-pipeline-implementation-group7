import csv
import os
import argparse
import sys

# Instruction sets grouped by the type
instruction_data = {}

# Command-line argument types
arg_list = {'input_file': '', 'output_file': ''}

# Command-line argument keywords
arg_keys = {'-i': 'input_file', '-o': 'output_file'}

# Array to store the instructions
instructions = []

# This dictionary is used to remember the position of the label
label_position = {}

# The instruction count written to the file
instruction_count = 0

FILE_SIZE = 1024


def format_number(num_of_digits, num):
    """
    Formats a number as a string with leading zeros up to the specified number of digits.

    Args:
        num_of_digits (int): The desired number of digits.
        num (int): The number to format.

    Returns:
        str: The formatted number.
    """
    return str(num).zfill(num_of_digits)[:num_of_digits]


def format_instructions(instructions):
    """
    Formats the list of instructions.

    Args:
        instructions (list): The list of instructions to format.
    """
    for index, instruction in enumerate(instructions):
        format_instruction(instruction, index)


def format_instruction(instruction, index):
    """
    Formats an individual instruction.

    Args:
        instruction (str): The instruction to format.
        index (int): The index of the instruction in the list.
    """
    final_instruction = []
    instruction_parts = instruction.split()
    instruction_name = instruction_parts.pop(0)
    final_instruction.append(instruction_name.upper())

    for part in instruction_parts:
        instructions_array = part.split(',')
        instructions_array = list(filter(None, instructions_array))

        segmented_list = []

        for item in instructions_array:
            tmp_item = item
            item = item.replace('x', '')

            if '(' and ')' in item:
                item = item.replace(')', '')
                tmp_split_3 = item.split('(')
                tmp_split_3.reverse()
                segmented_list.extend(tmp_split_3)
            elif item.isalpha():
                segmented_list.append((label_position[tmp_item] - index - 1) * 4)
            else:
                segmented_list.append(item)

        final_instruction.extend(segmented_list)

    handle_instruction(final_instruction)


def read_csv():
    """
    Reads the CSV file and populates the `instruction_data` dictionary.
    """
    with open('RV32IM.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        instruction_data.update({row[3]: {'opcode': format_number(7, row[0]),
                                          'funct3': format_number(3, row[1]),
                                          'funct7': format_number(7, row[2]),
                                          'type': row[4]} for row in csv_reader})


# def handle_instruction(separated_instruction):
#     """
#     Handles the formatting and processing of each instruction.

#     Args:
#         separated_instruction (list): The list containing the separated instruction components.
#     """
#     instruction = None
#     instruction_type = instruction_data[separated_instruction[0]]['type']

#     if instruction_type == "R-Type":
#         instruction = f"{instruction_data[separated_instruction[0]]['funct7']}{to_bin(5, separated_instruction[3])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"
    
#     elif instruction_type == "I - Type ":
#         instruction = f"{to_bin(12, separated_instruction[3])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "S-Type":
#         immediate = to_bin(12, separated_instruction[3])
#         instruction = f"{immediate[:7]}{to_bin(5, separated_instruction[1])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{immediate[7:]}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "B-Type":
#         immediate = to_bin(13, separated_instruction[3])
#         instruction = f"{immediate[0]}{immediate[2:8]}{to_bin(5, separated_instruction[2])}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['funct3']}{immediate[8:12]}{immediate[1]}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "U -Type":
#         immediate = to_bin(32, separated_instruction[2])
#         instruction = f"{immediate[0:20]}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "J-Type":
#         immediate = to_bin(21, separated_instruction[2])
#         instruction = f"{immediate[0]}{immediate[10:20]}{immediate[9]}{immediate[1:9]}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "NOP-type":
#         instruction = "0" * 32

#     # print(separated_instruction[0], separated_instruction, instruction, hex(int(instruction, 2)))
#     print(separated_instruction[0], separated_instruction, instruction)
#     save_to_file(instruction)

def handle_instruction(separated_instruction):
    """
    Handles the formatting and processing of each instruction.

    Args:
        separated_instruction (list): The list containing the separated instruction components.
    """
    instruction = None
    instruction_type = instruction_data[separated_instruction[0]]['type']

    if instruction_type == "R-Type":
        print("R type: ")
        instruction = f"{instruction_data[separated_instruction[0]]['funct7']}{to_bin(5, separated_instruction[3])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"
    
    elif instruction_type == "I - Type ":
        print("I type: ")
        print(f"{to_bin(12, separated_instruction[3])}")
        print(f"{separated_instruction[3]}")
        print(f"{instruction_data[separated_instruction[0]]['funct3']}")
        instruction = f"{to_bin(12, separated_instruction[3])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

    elif instruction_type == "S-Type":
        print("S-Type instruction")
        immediate = to_bin(12, separated_instruction[3])
        instruction = f"{immediate[:7]}{to_bin(5, separated_instruction[1])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{immediate[7:]}{instruction_data[separated_instruction[0]]['opcode']}"

    elif instruction_type == "B-Type":
        print("B Type")
        immediate = to_bin(13, separated_instruction[3])
        instruction = f"{immediate[0]}{immediate[2:8]}{to_bin(5, separated_instruction[2])}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['funct3']}{immediate[8:12]}{immediate[1]}{instruction_data[separated_instruction[0]]['opcode']}"

    elif instruction_type == "U -Type":
        print("U type")
        immediate = to_bin(32, separated_instruction[2])
        instruction = f"{immediate[0:20]}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

    elif instruction_type == "J-Type":
        print("J type")
        immediate = to_bin(21, separated_instruction[2])
        print(separated_instruction)
        instruction = f"{immediate[0]}{immediate[10:20]}{immediate[9]}{immediate[1:9]}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

    elif instruction_type == "NOP-type":
        print("NOP-type instruction")
        instruction = "0" * 32

    # instruction = "{:032b}".format(int(instruction, 2))   
    print(instruction)
    save_to_file(instruction)

# def handle_instruction(separated_instruction):
#     """
#     Handles the formatting and processing of each instruction.

#     Args:
#         separated_instruction (list): The list containing the separated instruction components.
#     """
#     instruction = None
#     instruction_type = instruction_data[separated_instruction[0]]['type']

#     if instruction_type == "R-Type":
#         instruction = f"{instruction_data[separated_instruction[0]]['funct7']}{to_bin(5, separated_instruction[3])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"
    
#     elif instruction_type == "I - Type ":
#         instruction = f"{to_bin(12, separated_instruction[3])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "S-Type":
#         immediate = to_bin(12, separated_instruction[3])
#         instruction = f"{immediate[:7]}{to_bin(5, separated_instruction[1])}{to_bin(5, separated_instruction[2])}{instruction_data[separated_instruction[0]]['funct3']}{immediate[7:]}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "B-Type":
#         immediate = to_bin(13, separated_instruction[3])
#         instruction = f"{immediate[0]}{immediate[2:8]}{to_bin(5, separated_instruction[2])}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['funct3']}{immediate[8:12]}{immediate[1]}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "U -Type":
#         immediate = to_bin(32, separated_instruction[2])
#         instruction = f"{immediate[0:20]}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "J-Type":
#         immediate = to_bin(21, separated_instruction[2])
#         instruction = f"{immediate[0]}{immediate[10:20]}{immediate[9]}{immediate[1:9]}{to_bin(5, separated_instruction[1])}{instruction_data[separated_instruction[0]]['opcode']}"

#     elif instruction_type == "NOP-type":
#         instruction = "0" * 32

#     # Print the binary instruction as a 32-bit value
#     binary_instruction = format_number(32, int(instruction, 2))
#     print(binary_instruction)


def handle_args():
    """
    Handles command-line arguments.
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', dest='input_file', help='Input file')
    parser.add_argument('-o', dest='output_file', help='Output file')
    args = parser.parse_args()
    arg_list['input_file'] = args.input_file
    arg_list['output_file'] = args.output_file


def handle_input_file():
    """
    Handles the input file, reads the instructions, and identifies label positions.
    """
    global label_position

    if not arg_list['input_file']:
        print('Input file not found')
        sys.exit(1)

    with open(arg_list['input_file'], "r") as f:
        line_count = 0

        for instruction in f:
            if not instruction.strip():
                continue
            elif instruction.strip()[0] == ';':
                continue
            elif instruction.strip()[-1] == ':':
                label_position[instruction.strip()[:-1]] = line_count
            else:
                instructions.append(instruction)
                line_count += 1

    format_instructions(instructions)


# def     to_bin(num_of_digits, num):
#     """
#     Converts a number to its binary representation with leading zeros up to the specified number of digits.

#     Args:
#         num_of_digits (int): The desired number of digits.
#         num (int): The number to convert.

#     Returns:
#         str: The binary representation of the number.
#     """
#     return format_number(num_of_digits, int(num))

def to_bin(num_of_digits, num):
    """
    Converts a number to its binary representation with leading zeros up to the specified number of digits.

    Args:
        num_of_digits (int): The desired number of digits.
        num (int or str): The number to convert.

    Returns:
        str: The binary representation of the number.
    """
    if isinstance(num, str):
        num = int(num)
    binary = bin(num)[2:]  # Remove the '0b' prefix from the binary representation
    binary = binary.zfill(num_of_digits)  # Add leading zeros to match the desired number of digits
    return binary



def save_to_file(line):
    """
    Saves the formatted instruction to the output file.

    Args:
        line (str): The formatted instruction.
    """
    global instruction_count
    file = f"../cpu/build/{arg_list['input_file'].split('.')[0]}.bin"

    if arg_list['output_file']:
        file = f"../cpu/build/{arg_list['output_file']}"

    with open(file, "a") as f:
        for i in range(3, -1, -1):
            f.write(f"{line[(i*8):(i*8+8)]}\n")

    instruction_count += 1


def fill_the_file():
    """
    Fills the remaining space in the output file with placeholder values.
    """
    global FILE_SIZE
    file = f"../cpu/build/{arg_list['input_file'].split('.')[0]}.bin"

    if arg_list['output_file']:
        file = f"../cpu/build/{arg_list['output_file']}"

    with open(file, "a") as f:
        for _ in range(FILE_SIZE - (4 * instruction_count)):
            f.write('x' * 8 + '\n')


if __name__ == "__main__":
    # Remove existing binary files in the output directory
    for i in os.listdir("../cpu/build"):
        if i.endswith(".bin"):
            os.remove(f"../cpu/build/{i}")

    # Read the instruction set from the CSV file
    read_csv()

    # Handle command-line arguments
    handle_args()

    # Process the input file and format the instructions
    handle_input_file()

    # Fill the remaining space in the output file with placeholders
    fill_the_file()

    # Print the label positions for debugging purposes
    print(label_position)