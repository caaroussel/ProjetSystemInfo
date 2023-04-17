#ifndef TN_H
#define TN_H

#include "ti.h"

typedef struct instrVal{
    instr * pointInstr;
    struct instrVal * next;
    struct instrVal * prev;
} instrVal;

void ajoutInstrVal (instrVal a);
void creationInstrVal(instr * instruction);
void supprLastInstrVal ();
int * getLastInstrVal ();
instr * getInstr(instrVal * instructionVal);

#endif