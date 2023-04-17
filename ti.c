#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "ti.h"


instr * ti;
instr * head;

void creationInstr(char* nom, char type)
{
    instr instruction;
    strcpy(instruction.nom, nom);
    instruction.prof=prof;
    instruction.type=type;
    ajoutInstr(instruction);
}

void ajoutInstr (instr a)
{
    if(ti == NULL){
        ti = malloc(sizeof(instr));
        strcpy(ti->nom, a.nom);
        ti->prof = a.prof;
        ti->type = a.type;
        head = ti;

    }else{
        head->next = malloc(sizeof(instr));
        strcpy(head->next->nom, a.nom);
        head->next->prof = a.prof;
        head->next->type = a.type;

        head->next->prev = head;
        head = head->next;
    }
}

void supprInstr (char* nom)
{
    instr locTI = *ti;
    bool trouve = false;
    while (locTI.nom != NULL && !trouve)
    {
        if(!strcmp(nom, locTI.nom)){
            if(locTI.prev != NULL && locTI.next != NULL){
                locTI.prev->next = locTI.next;
            }else if(locTI.prev != NULL){
                head = locTI.prev;
                head->next = NULL;
                free(locTI.prev->next);
            }else if(locTI.next != NULL){
                ti = locTI.next;
                free(locTI.next->prev);
            }else{
                ti = NULL;
                free(ti);
            }
            trouve=true;
        }
        else{
            if(locTI.next != NULL){
                locTI = *(locTI.next);
            }
            else{
                trouve = true;
            }
        }
    }
}

instr * recupInstr(char* nom)
{
    instr locTI = *ti;
    bool nontrouve = false;
    while (locTI.nom != NULL && !nontrouve)
    {   
        if(!strcmp(nom, locTI.nom)){
            if(locTI.prev != NULL && locTI.next != NULL){
                return locTI.next->prev;
            }else if(locTI.prev != NULL){
                return locTI.prev->next;
            }else if(locTI.next != NULL){
                return locTI.next->prev;
            }else{
                return ti;
            }
        }
        else{
            if(locTI.next != NULL){
                locTI = *(locTI.next);
            }
            else{
                nontrouve = true;
            }
        }
    }
    return NULL;
}

void supprProfActInstr(){
    instr locTI = *ti;
    bool trouve = false;
    while (locTI.nom != NULL && !trouve)
    {
        printf("Suppression des variables avec profondeur : %d\n", prof);
        if(prof == locTI.prof){
            if(locTI.prev != NULL && locTI.next != NULL){
                locTI.prev->next = locTI.next;
                locTI.next->prev = locTI.prev;
                locTI = *(locTI.next);
            }else if(locTI.prev != NULL){
                head = locTI.prev;
                head->next = NULL;
                free(locTI.prev->next);
                trouve = true;
            }else if(locTI.next != NULL){
                ti = locTI.next;
                free(locTI.next->prev);
                locTI = *(locTI.next);
            }else{
                ti = NULL;
                free(ti);
                trouve = true;
            }
            
        } else{
            if(locTI.next != NULL){
                locTI = *(locTI.next);
            }
            else{
                trouve = true;
            }
        }
        
    }
}

void modifInitInstr(char* nom)
{
    instr locTI = *ti;
    bool nontrouve = false;
    while (locTI.nom != NULL && !nontrouve)
    {   
        if(!strcmp(nom, locTI.nom)){
            if(locTI.prev != NULL && locTI.next != NULL){
                locTI.next->prev->type = 1;
            }else if(locTI.prev != NULL){
                locTI.prev->next->type = 1;
            }else if(locTI.next != NULL){
                locTI.next->prev->type = 1;
            }else{
                ti->type = 1;
            }
            nontrouve = true;
        }
        else{
            if(locTI.next != NULL){
                locTI = *(locTI.next);
            }
            else{
                nontrouve = true;
            }
        }
    }
}

void supprLastInstr (){
    instr * locTI = head->prev;
    free(head);
    head = locTI;
    if(head == NULL){
        ti = NULL;
    }else{
        head->next = NULL;
    }
}

int * getLastInstr (){
    return (int *) head;
}

int * getPreviousLastInstr (){
    return (int *)head->prev;
}

void modifNomInstr(instr * a, int * nextInstr){
    strcat(a->nom, sprintf(" %p\n", nextInstr));
}

char * getNameInstr(instr * instruction){
    return instruction->nom;
}

#if 0
int main (void){
    creationInstr("instr1", 1);
    prof = 1;
    creationInstr("instr2", 0);
    creationInstr("instr3", 1);
    creationInstr("instr4", 1);
     creationInstr("instr7", 1);
    prof = 2;
    creationInstr("instr5", 1);
    prof = 1;
    creationInstr("instr6", 1);

    supprProfActInstr();

    instr * ap = recupInstr("instr1");
    instr * bp = recupInstr("instr2");
    instr * cp = recupInstr("instr3");
    instr * dp = recupInstr("instr4");
    instr * ep = recupInstr("instr5");
    instr * fp = recupInstr("instr6");
    instr * gp = recupInstr("instr7");

    printf("instr 1 : %p\n", ap);
    printf("instr 2 : %p\n", bp);
    printf("instr 3 : %p\n", cp);
    printf("instr 4 : %p\n", dp);
    printf("instr 5 : %p\n", ep);
    printf("instr 6 : %p\n", fp);
    printf("instr 7 : %p\n", gp);

    return 0;
}
#endif
