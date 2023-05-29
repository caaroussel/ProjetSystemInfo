#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "tn.h"

instrVal *tn;
instrVal *headTn;

void creationInstrVal(instr *instruction, int type, char *nom)
{
    instrVal instructionVal;
    instructionVal.pointInstr = instruction;
    instructionVal.type = type;
    strcpy(instructionVal.nom, nom);
    // printf("J'ai crée un %s\n", nom);
    ajoutInstrVal(instructionVal);
}

void ajoutInstrVal(instrVal a)
{
    if (tn == NULL)
    {
        tn = malloc(sizeof(instrVal));
        tn->pointInstr = a.pointInstr;
        strcpy(tn->nom, a.nom);
        tn->type = a.type;
        headTn = tn;
    }
    else
    {
        headTn->next = malloc(sizeof(instrVal));
        headTn->next->pointInstr = a.pointInstr;
        strcpy(headTn->next->nom, a.nom);
        headTn->next->type = a.type;
        headTn->next->prev = headTn;
        headTn = headTn->next;
    }
}

void supprLastInstrVal(int type, char *nom)
{
    instrVal locTI = *headTn; // Start from headTi instead of ti
    bool trouve = false;
    while (locTI.nom != NULL && !trouve)
    {
        if (!strcmp(nom, locTI.nom))
        {
            // Rest of the code remains the same
            if (locTI.prev != NULL && locTI.next != NULL)
            {
                locTI.prev->next = locTI.next;
            }
            else if (locTI.prev != NULL)
            {
                headTn = locTI.prev;
                headTn->next = NULL;
                free(locTI.prev->next);
            }
            else if (locTI.next != NULL)
            {
                tn = locTI.next;
                free(locTI.next->prev);
            }
            else
            {
                tn = NULL;
                free(tn);
            }
            trouve = true;
        }
        else
        {
            if (locTI.prev != NULL) // Traverse backwards if locTI.prev is not NULL
            {
                locTI = *(locTI.prev);
            }
            else
            {
                trouve = true;
            }
        }
    }
}

instr *getLastInstrVal(int type, char *nom)
{
    instrVal locTI = *headTn;
    bool nontrouve = false;
    while (locTI.nom != NULL && !nontrouve)
    {
        if (!strcmp(nom, locTI.nom))
        {
            if (locTI.prev != NULL && locTI.next != NULL)
            {
                return locTI.next->prev->pointInstr;
            }
            else if (locTI.prev != NULL)
            {
                return locTI.prev->next->pointInstr;
            }
            else if (locTI.next != NULL)
            {
                return locTI.next->prev->pointInstr;
            }
            else
            {
                return tn->pointInstr;
            }
        }
        else
        {
            if (locTI.prev != NULL)
            {
                locTI = *(locTI.prev);
            }
            else
            {
                nontrouve = true;
            }
        }
    }
    return headTn->pointInstr;
}

instr *getFirstInstrVal()
{
    // printf("Je veux recup le tout premier ☻ %s -- %p\n", tn->nom, tn->pointInstr);
    return tn->pointInstr;
}

int getLastInstrValIndex(int type, char *nom)
{
    instrVal locTI = *headTn;
    bool nontrouve = false;
    while (locTI.nom != NULL && !nontrouve)
    {
        if (!strcmp(nom, locTI.nom))
        {
            if (locTI.prev != NULL && locTI.next != NULL)
            {
                return locTI.next->prev->pointInstr->index;
            }
            else if (locTI.prev != NULL)
            {
                return locTI.prev->next->pointInstr->index;
            }
            else if (locTI.next != NULL)
            {
                return locTI.next->prev->pointInstr->index;
            }
            else
            {
                return tn->pointInstr->index;
            }
        }
        else
        {
            if (locTI.prev != NULL)
            {
                locTI = *(locTI.prev);
            }
            else
            {
                nontrouve = true;
            }
        }
    }
    return headTn->pointInstr->index;
}

instr *getInstr(instrVal *instructionVal)
{
    return instructionVal->pointInstr;
}

#if 0
int main (void){

    return 0;
}
#endif
