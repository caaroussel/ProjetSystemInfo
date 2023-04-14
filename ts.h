#ifndef TS_H
#define TS_H
typedef struct symb{
    char nom[11];
    int prof;
    char init;
    struct symb * next;
    struct symb * prev;
} symb;

int prof = 0;

void ajoutSymb (symb a);
void supprSymb (char* nom);
symb * recupSymb (char* nom);

void creationSymb(char* nom, char init);

void supprProfAct();
void supprLast ();
void modifInit(char* nom);
int * getPreviousLast ();
int * getLast ();
#endif