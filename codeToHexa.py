dictInstruction = {
    "ADD" : "01",
    "MUL" : "02",
    "SUB" : "03",
    "COP" : "05",
    "AFC" : "06",
    "LDR" : "07",
    "STR" : "08",
    "GT" : "09",
    "JMF" : "0A",
    "JMT" : "0B",
    "EQ" : "0C",
}

def formatHex(chaine):
    if(len(str(hex(int(chaine))).split("x")[1]) == 1):
        return "0" + str(hex(int(separated[1]))).split("x")[1]
    else:
        return str(hex(int(separated[1]))).split("x")[1]
        
        
line = input()
while line != 'EOF':
    separated = line.split(" ");
    
    listeInstruction = []
    listeInstruction.append(dictInstruction[separated[0]])
    
    for i in range(1, len(separated)):
        listeInstruction.append(formatHex(separated[i]))
    
    for i in range (4 - len(listeInstruction)):
        listeInstruction.append("00")
    
    print("".join(listeInstruction))
        
    try:
        line = input()
    except:
        # print("End of the file ☺")
        exit(0)