#ifndef TF_H
#define TF_H

typedef struct functionDetails{
    char nom[11];
    int adresseDebut;
    int adresseRetour;
    struct functionDetails * next;
    struct functionDetails * prev;
} functionDetails;

void modifyCurrentFunction(char * nom);

char * getCurrentFunction();

void creationFunctionDetails(char* nom, int adresseDebut);

void ajoutFunctionDetails (functionDetails a);

functionDetails * getFunctionDetails (char * nom);

void modifFunctionDetails (char * nom, int adresseRetour);

void supprLastFunctionDetails ();

functionDetails * getLastFunctionDetails ();

char * getLastFunctionDetailsNom ();

int getLastFunctionDetailsAdresseDebut ();

int getLastFunctionDetailsAdresseRetour ();

char * getFunctionDetailsNom(functionDetails * instructionVal);

int getFunctionDetailsAdresseDebut(functionDetails * instructionVal);

int getFunctionDetailsAdresseRetour(functionDetails * instructionVal);

#endif