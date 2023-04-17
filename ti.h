#ifndef TI_H
#define TI_H
typedef struct instr{
    char nom[11];
    int prof;
    char type;
    struct instr * next;
    struct instr * prev;
} instr;

extern int prof;

void ajoutInstr (instr a);
void supprInstr (char* nom);
instr * recupInstr (char* nom);
void creationInstr(char* nom, char init);
void supprProfActInstr();
void supprLastInstr ();
void modifInitInstr(char* nom);
int * getPreviousLastInstr ();
int * getLastInstr ();
char * getNameInstr(instr * instruction);
void modifNomInstr(instr * a, int * nextInstr);
#endif