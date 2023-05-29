#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "tf.h"


functionDetails * tf;
functionDetails * headTf;

char * currentFunction;

void modifyCurrentFunction(char * nom){
    currentFunction = malloc(sizeof(functionDetails));
    strcpy(currentFunction, nom);
}

char * getCurrentFunction(){
    return currentFunction;
}

void creationFunctionDetails(char* nom, int adresseDebut)
{
    functionDetails instruction;
    strcpy(instruction.nom, nom);
    instruction.adresseDebut = adresseDebut;
    ajoutFunctionDetails(instruction);
}

void ajoutFunctionDetails (functionDetails a)
{
    if(tf == NULL){
        tf = malloc(sizeof(functionDetails));
        strcpy(tf->nom, a.nom);
        tf -> adresseDebut = a.adresseDebut;
        headTf = tf;

    }else{
        headTf->next = malloc(sizeof(functionDetails));
        strcpy(headTf->next->nom, a.nom);
        headTf->next->adresseDebut = a.adresseDebut;

        headTf->next->prev = headTf;
        headTf = headTf->next;
    }
}

functionDetails * getFunctionDetails (char * nom){
    functionDetails locTN = *tf;
    bool nontrouve = false;
    while (locTN.nom != NULL && !nontrouve)
    {
        if (!strcmp(nom, locTN.nom))
        {
            if (locTN.prev != NULL && locTN.next != NULL)
            {
                return locTN.next->prev;
            }
            else if (locTN.prev != NULL)
            {
                return locTN.prev->next;
            }
            else if (locTN.next != NULL)
            {
                return locTN.next->prev;
            }
            else
            {
                return tf;
            }
        }
        else
        {
            if (locTN.next != NULL)
            {
                locTN = *(locTN.next);
            }
            else
            {
                nontrouve = true;
            }
        }
    }
    return NULL;
}

void modifFunctionDetails (char * nom, int adresseRetour){
    functionDetails locTN = *tf;
    bool nontrouve = false;
    while (locTN.nom != NULL && !nontrouve)
    {
        if (!strcmp(nom, locTN.nom))
        {
            if (locTN.prev != NULL && locTN.next != NULL)
            {
                locTN.next->prev->adresseRetour = adresseRetour;
            }
            else if (locTN.prev != NULL)
            {
                locTN.prev->next->adresseRetour = adresseRetour;
            }
            else if (locTN.next != NULL)
            {
                locTN.next->prev->adresseRetour = adresseRetour;
            }
            else
            {
                tf->adresseRetour = adresseRetour;
            }
            nontrouve = true;
        }
        else
        {
            if (locTN.next != NULL)
            {
                locTN = *(locTN.next);
            }
            else
            {
                nontrouve = true;
            }
        }
    }
}

void supprLastFunctionDetails (){
    functionDetails * locTN = headTf->prev;
    free(headTf);
    headTf = locTN;
    if(headTf == NULL){
        tf = NULL;
    }else{
        headTf->next = NULL;
    }
}

functionDetails * getLastFunctionDetails (){
    return headTf;
}

char * getLastFunctionDetailsNom (){
    return headTf->nom;
}

int getLastFunctionDetailsAdresseDebut (){
    return headTf->adresseDebut;
}

int getLastFunctionDetailsAdresseRetour (){
    return headTf->adresseRetour;
}

char * getFunctionDetailsNom(functionDetails * instructionVal){
    return instructionVal->nom;
}

int getFunctionDetailsAdresseDebut(functionDetails * instructionVal){
    return instructionVal->adresseDebut;
}

int getFunctionDetailsAdresseRetour(functionDetails * instructionVal){
    return instructionVal->adresseRetour;
}



#if 0
int main (void){

    return 0;
}
#endif
