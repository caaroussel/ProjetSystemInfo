#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "tn.h"


instrVal * tn;
instrVal * head;

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
        head = tn;

    }else{
        head->next = malloc(sizeof(instrVal));
        head->next->pointInstr = a.pointInstr;

        head->next->prev = head;
        head = head->next;
    }
}

void supprLastInstrVal (){
    instrVal * locTN = head->prev;
    free(head);
    head = locTN;
    if(head == NULL){
        tn = NULL;
    }else{
        head->next = NULL;
    }
}

int * getLastInstrVal (){
    return (int *) head->pointInstr;
}

instr * getInstr(instrVal * instructionVal){
    return instructionVal->pointInstr;
}



#if 0
int main (void){

    return 0;
}
#endif
