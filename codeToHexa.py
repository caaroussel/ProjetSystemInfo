from time import sleep

dictInstruction = {
    "ADD" : "01",
    "MUL" : "02",
    "SUB" : "03",
    "COP" : "05",
    "AFC" : "06",
    "LDR" : "07",
    "STR" : "08",
    "JMT" : "0A",
    "JMF" : "0B",
    "SUBEQ" : "83",
    "SUBNE" : "93",
    "SUBLT" : "A3",
    "SUBGT" : "B3",
    "SUBLE" : "C3",
    "SUBGE" : "D3",
}

def formatHex(chaine):
    if(len(str(hex(int(chaine))).split("x")[1]) == 1):
        return "0" + str(hex(int(separated[1]))).split("x")[1]
    else:
        return str(hex(int(separated[1]))).split("x")[1]
        

tousLesInstructions = []
with open("output", "r") as file:
    ligne = file.readline()
    i = 0
    while(ligne != ""):
        # print(ligne.split("\n")[0])
        tousLesInstructions.append(ligne.split("\n")[0])
        ligne = file.readline()

# print(tousLesInstructions);

i = 0
    
while i < len(tousLesInstructions):
    line = tousLesInstructions[i]
    separated = line.split(" ")
    if(separated[0] == "ADD"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+2, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+3, f"ADD {1} {1} {2}")
        tousLesInstructions.insert(i+4, f"STR {separated[1]} {1}")
        del tousLesInstructions[i]
        i += 3
    elif(separated[0] == "SUB"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+2, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+3, f"SUB {1} {1} {2}")
        tousLesInstructions.insert(i+4, f"STR {separated[1]} {1}")
        del tousLesInstructions[i]
        i += 3
    elif(separated[0] == "MUL"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+2, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+3, f"MUL {1} {1} {2}")
        tousLesInstructions.insert(i+4, f"STR {separated[1]} {1}")
        del tousLesInstructions[i]
        i += 3
    elif(separated[0] == "COP"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[2]}")
        tousLesInstructions.insert(i+2, f"STR {separated[1]} {1}")
        del tousLesInstructions[i]
        i += 1
    elif(separated[0] == "AFC"):
        tousLesInstructions.insert(i+1, f"AFC {1} {separated[2]}")
        tousLesInstructions.insert(i+2, f"STR {separated[1]} {1}")
        del tousLesInstructions[i]
        i += 1
    elif(separated[0] == "EQ"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+1, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+2, f"SUBEQ {1} {1} {2}")
        del tousLesInstructions[i]
        i += 2
    elif(separated[0] == "NE"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+1, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+2, f"SUBNE {1} {1} {2}")
        del tousLesInstructions[i]
        i += 2
    elif(separated[0] == "LT"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+1, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+2, f"SUBLT {1} {1} {2}")
        del tousLesInstructions[i]
        i += 2
    elif(separated[0] == "GT"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+1, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+2, f"SUBGT {1} {1} {2}")
        del tousLesInstructions[i]
        i += 2
    elif(separated[0] == "LE"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+1, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+2, f"SUBLE {1} {1} {2}")
        del tousLesInstructions[i]
        i += 2
    elif(separated[0] == "GE"):
        tousLesInstructions.insert(i+1, f"LDR {1} {separated[1]}")
        tousLesInstructions.insert(i+1, f"LDR {2} {separated[2]}")
        tousLesInstructions.insert(i+2, f"SUBGE {1} {1} {2}")
        del tousLesInstructions[i]
        i += 2
    
    
    i += 1    

for i in tousLesInstructions:
    print(i)

print("\n")
    
for line in tousLesInstructions:
    separated = line.split(" ")
    
    listeInstruction = ["0x"]
    listeInstruction.append(dictInstruction[separated[0]])
    
    for i in range(1, len(separated)):
        listeInstruction.append(formatHex(separated[i]))
    
    for i in range (5 - len(listeInstruction)):
        listeInstruction.append("00")
    
    print("".join(listeInstruction))


"""
    ADD => LDR LDR ADD STR => IP + 4
    SUB => LDR LDR SUB STR => IP + 4
    MUL => LDR LDR MUL STR => IP + 4
    COP => LDR STR => IP + 2 
    AFC => AFC STR => IP + 2
    EQ => LDR LDR SUBEQ => IP + 3
    NE => LDR LDR SUBNE => IP + 3
    LT => LDR LDR SUBLT => IP + 3
    GT => LDR LDR SUBGT => IP + 3
    LE => LDR LDR SUBLE => IP + 3
    GE => LDR LDR SUBGE => IP + 3
"""