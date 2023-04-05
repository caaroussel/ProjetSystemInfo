#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "ts.h"


symb ts;
symb head;

symb creationSymb(char* nom, int prof, char init)
{
    symb Symbole;
    strcpy(Symbole.nom,nom);
    Symbole.prof=prof;
    Symbole.init=init;
    return Symbole;
}

void ajoutSymb (symb a)
{
    head.next = &a;
    a.prev = head;
    head = a;
}

void supprSymb (char* nom)
{
    symb locTS = ts;
    bool trouve = false;
    while (locTS.next != NULL && !trouve)
    {
        if(strcmp(nom, locTS.nom)){
            locTS.prev = locTS.next;
            free(locTS);
            trouve=true;
        }
        else{
            locTS=locTS.next;
        }
    }
}

symb recupSymb(char* nom)
{
    symb locTS = ts;
    bool trouve = false;
    while (locTS.next != NULL && !trouve)
    {
        if(strcmp(nom, locTS.nom)){
            return locTS;
        }
        else {
            locTS = locTS.next;
        }
    }
    return NULL;
}

int main (void){
    return 0;
}