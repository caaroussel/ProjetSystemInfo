#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "tn.h"


instrVal * tn;
instrVal * headTn;

void creationInstrVal(instr * instruction)
{
    instrVal instructionVal;
    instructionVal.pointInstr=instruction;
    ajoutInstrVal(instructionVal);
}

void ajoutInstrVal (instrVal a)
{
    if(tn == NULL){
        tn = malloc(sizeof(instrVal));
        tn->pointInstr = a.pointInstr;
        headTn = tn;

    }else{
        headTn->next = malloc(sizeof(instrVal));
        headTn->next->pointInstr = a.pointInstr;

        headTn->next->prev = headTn;
        headTn = headTn->next;
    }
}

void supprLastInstrVal (){
    instrVal * locTN = headTn->prev;
    free(headTn);
    headTn = locTN;
    if(headTn == NULL){
        tn = NULL;
    }else{
        headTn->next = NULL;
    }
}

instr * getLastInstrVal (){
    return headTn->pointInstr;
}

int getLastInstrValIndex (){
    return headTn->pointInstr->index;
}

instr * getInstr(instrVal * instructionVal){
    return instructionVal->pointInstr;
}



#if 0
int main (void){

    return 0;
}
#endif
