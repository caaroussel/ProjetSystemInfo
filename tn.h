#ifndef TN_H
#define TN_H

#include "ti.h"

typedef struct instrVal{
    instr * pointInstr;
    int type;
    char nom[11];
    struct instrVal * next;
    struct instrVal * prev;
} instrVal;

void ajoutInstrVal (instrVal a);
void creationInstrVal(instr * instruction, int type, char * nom);
void supprLastInstrVal (int type, char * nom);
instr * getLastInstrVal (int type, char * nom);
instr * getFirstInstrVal ();
int getLastInstrValIndex (int type, char * nom);
instr * getInstr(instrVal * instructionVal);

#endif