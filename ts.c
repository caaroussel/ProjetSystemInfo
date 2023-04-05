#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "ts.h"


symb * ts;
symb * head;

symb creationSymb(char* nom, int prof, char init)
{
    symb symbole;
    strcpy(symbole.nom,nom);
    symbole.prof=prof;
    symbole.init=init;
    return symbole;
}

void ajoutSymb (symb a)
{
    if(ts == NULL){
        ts = malloc(sizeof(symb));
        strcpy(ts->nom, a.nom);
        ts->prof = a.prof;
        ts->init = a.init;
        head = ts;

    }else{
        head->next = malloc(sizeof(symb));
        strcpy(head->next->nom, a.nom);
        head->next->prof = a.prof;
        head->next->init = a.init;

        head->next->prev = head;
        head = head->next;
    }
}

void supprSymb (char* nom)
{
    symb locTS = *ts;
    bool trouve = false;
    while (locTS.nom != NULL && !trouve)
    {
        if(!strcmp(nom, locTS.nom)){
            if(locTS.prev != NULL && locTS.next != NULL){
                locTS.prev->next = locTS.next;
            }else if(locTS.prev != NULL){
                head = locTS.prev;
                head->next = NULL;
                free(locTS.prev->next);
            }else if(locTS.next != NULL){
                ts = locTS.next;
                free(locTS.next->prev);
            }else{
                ts = NULL;
                free(ts);
            }
            trouve=true;
        }
        else{
            if(locTS.next != NULL){
                locTS = *(locTS.next);
            }
            else{
                trouve = true;
            }
        }
    }
}

symb * recupSymb(char* nom)
{
    symb locTS = *ts;
    bool nontrouve = false;
    while (locTS.nom != NULL && !nontrouve)
    {   
        if(!strcmp(nom, locTS.nom)){
            if(locTS.prev != NULL && locTS.next != NULL){
                return locTS.next->prev;
            }else if(locTS.prev != NULL){
                return locTS.prev->next;
            }else if(locTS.next != NULL){
                return locTS.next->prev;
            }else{
                return ts;
            }
        }
        else{
            if(locTS.next != NULL){
                locTS = *(locTS.next);
            }
            else{
                nontrouve = true;
            }
        }
    }
    return NULL;
}

int main (void){
    symb a = creationSymb("symb1", 1, 0);
    symb b = creationSymb("symb2", 1, 1);
    symb c = creationSymb("symb3", 1, 1);

    ajoutSymb(a);
    ajoutSymb(b);
    ajoutSymb(c);

    symb * ap = recupSymb("symb1");

    supprSymb("symb2");

    symb * bp = recupSymb("symb2");

    supprSymb("symb2");

    supprSymb("symb3");

    recupSymb("symb3");

    return 0;
}