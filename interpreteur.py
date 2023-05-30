def interpret_opcode(opcode):
    registers = [0] * 8  # Registers: [R0, R1, R2, R3, R4, R5, R6, R7]
    pile = []  # Pile
    program_counter = 0  # Program counter

    while program_counter < len(opcode):
        sinstruction = opcode[program_counter]
        instruction = sinstruction.split(" ")

        # print("IP - ", program_counter, " - ", sinstruction, " - ", registers)

        if instruction[0] == "JMT":
            program_counter = int(instruction[1]) - 1

        elif instruction[0] == "JMF":
            jump_index = int(instruction[1])
            temp = int(opcode[program_counter - 1].split(" ")[1])
            if registers[temp] == 0:
                program_counter = jump_index - 1

        elif instruction[0] == "AFC":
            register_index = int(instruction[1])
            value = int(instruction[2])
            registers[register_index] = value

        elif instruction[0] == "COP":
            destination_index = int(instruction[1])
            source_index = int(instruction[2])
            registers[destination_index] = registers[source_index]

        elif instruction[0] == "ADD":
            destination_index = int(instruction[1])
            operand1_index = int(instruction[2])
            operand2_index = int(instruction[3])
            registers[destination_index] = registers[operand1_index] + \
                registers[operand2_index]

        elif instruction[0] == "SUB":
            destination_index = int(instruction[1])
            operand1_index = int(instruction[2])
            operand2_index = int(instruction[3])
            registers[destination_index] = registers[operand1_index] - \
                registers[operand2_index]

        elif instruction[0] == "MUL":
            destination_index = int(instruction[1])
            operand1_index = int(instruction[2])
            operand2_index = int(instruction[3])
            registers[destination_index] = registers[operand1_index] * \
                registers[operand2_index]

        elif instruction[0] == "DIV":
            destination_index = int(instruction[1])
            operand1_index = int(instruction[2])
            operand2_index = int(instruction[3])
            registers[destination_index] = registers[operand1_index] / \
                registers[operand2_index]

        elif instruction[0] == "EQ":
            register_index = int(instruction[1])
            compare_index_1 = int(instruction[2])
            compare_index_2 = int(instruction[3])

            if registers[compare_index_1] == registers[compare_index_2]:
                registers[register_index] = 1
            else:
                registers[register_index] = 0

        elif instruction[0] == "NE":
            register_index = int(instruction[1])
            compare_index_1 = int(instruction[2])
            compare_index_2 = int(instruction[3])

            if registers[compare_index_1] != registers[compare_index_2]:
                registers[register_index] = 1
            else:
                registers[register_index] = 0

        elif instruction[0] == "LT":
            register_index = int(instruction[1])
            compare_index_1 = int(instruction[2])
            compare_index_2 = int(instruction[3])

            if registers[compare_index_1] < registers[compare_index_2]:
                registers[register_index] = 1
            else:
                registers[register_index] = 0

        elif instruction[0] == "GT":
            register_index = int(instruction[1])
            compare_index_1 = int(instruction[2])
            compare_index_2 = int(instruction[3])

            if registers[compare_index_1] > registers[compare_index_2]:
                registers[register_index] = 1
            else:
                registers[register_index] = 0

        elif instruction[0] == "LE":
            register_index = int(instruction[1])
            compare_index_1 = int(instruction[2])
            compare_index_2 = int(instruction[3])

            if registers[compare_index_1] <= registers[compare_index_2]:
                registers[register_index] = 1
            else:
                registers[register_index] = 0

        elif instruction[0] == "GE":
            register_index = int(instruction[1])
            compare_index_1 = int(instruction[2])
            compare_index_2 = int(instruction[3])

            if registers[compare_index_1] >= registers[compare_index_2]:
                registers[register_index] = 1
            else:
                registers[register_index] = 0

        elif instruction[0] == "PRI":
            register_index = int(instruction[1])
            print(registers[register_index])

        elif instruction[0] == "BX":
            program_counter = int(instruction[1]) - 1

        elif instruction[0] == "POP":
            register_index = int(instruction[1])
            value = int(pile.pop(0))
            registers[register_index] = value

        elif instruction[0] == "PUSH":
            register_index = int(instruction[1])
            pile.append(registers[register_index])

        elif instruction[0] == "RET":
            register_index = int(instruction[1])
            pile.append(registers[register_index])

        elif instruction[0] == "CALL":
            jump_index = int(instruction[1])
            return_register = int(instruction[2])
            opcodes[program_counter + 1] = f"POP {return_register}"
            program_counter = jump_index - 1

        program_counter += 1


# Main Program

opcodes = []

with open("output_interpreteur", "r") as file:
    ligne = file.readline()
    i = 0
    while (ligne != ""):
        opcodes.append(ligne.split("\n")[0])
        ligne = file.readline()


interpret_opcode(opcodes)
