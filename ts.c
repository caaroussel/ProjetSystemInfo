#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include "ts.h"


symb * ts;
symb * head;

void creationSymb(char* nom, char init)
{
    symb symbole;
    strcpy(symbole.nom,nom);
    symbole.prof=prof;
    symbole.init=init;
    ajoutSymb(symbole);
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

void supprProfAct(){
    symb locTS = *ts;
    bool trouve = false;
    while (locTS.nom != NULL && !trouve)
    {
        printf("Suppression des variables avec profondeur : %d\n", prof);
        if(prof == locTS.prof){
            if(locTS.prev != NULL && locTS.next != NULL){
                locTS.prev->next = locTS.next;
                locTS.next->prev = locTS.prev;
                locTS = *(locTS.next);
            }else if(locTS.prev != NULL){
                head = locTS.prev;
                head->next = NULL;
                free(locTS.prev->next);
                trouve = true;
            }else if(locTS.next != NULL){
                ts = locTS.next;
                free(locTS.next->prev);
                locTS = *(locTS.next);
            }else{
                ts = NULL;
                free(ts);
                trouve = true;
            }
            
        } else{
            if(locTS.next != NULL){
                locTS = *(locTS.next);
            }
            else{
                trouve = true;
            }
        }
        
    }
}

void modifInit(char* nom)
{
    symb locTS = *ts;
    bool nontrouve = false;
    while (locTS.nom != NULL && !nontrouve)
    {   
        if(!strcmp(nom, locTS.nom)){
            if(locTS.prev != NULL && locTS.next != NULL){
                locTS.next->prev->init = 1;
            }else if(locTS.prev != NULL){
                locTS.prev->next->init = 1;
            }else if(locTS.next != NULL){
                locTS.next->prev->init = 1;
            }else{
                ts->init = 1;
            }
            nontrouve = true;
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
}

void supprLast (){
    symb * locTS = head->prev;
    free(head);
    head = locTS;
    if(head == NULL){
        ts = NULL;
    }else{
        head->next = NULL;
    }
}

int * getLast (){
    return (int *) head;
}

int * getPreviousLast (){
    return (int *)head->prev;
}

#if 0
int main (void){
    creationSymb("symb1", 1);
    prof = 1;
    creationSymb("symb2", 0);
    creationSymb("symb3", 1);
    creationSymb("symb4", 1);
     creationSymb("symb7", 1);
    prof = 2;
    creationSymb("symb5", 1);
    prof = 1;
    creationSymb("symb6", 1);

    supprProfAct();

    symb * ap = recupSymb("symb1");
    symb * bp = recupSymb("symb2");
    symb * cp = recupSymb("symb3");
    symb * dp = recupSymb("symb4");
    symb * ep = recupSymb("symb5");
    symb * fp = recupSymb("symb6");
    symb * gp = recupSymb("symb7");

    printf("Symb 1 : %p\n", ap);
    printf("Symb 2 : %p\n", bp);
    printf("Symb 3 : %p\n", cp);
    printf("Symb 4 : %p\n", dp);
    printf("Symb 5 : %p\n", ep);
    printf("Symb 6 : %p\n", fp);
    printf("Symb 7 : %p\n", gp);

    return 0;
}
#endif
