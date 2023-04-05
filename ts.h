typedef struct symb{
    char nom[11];
    int prof;
    char init;
    struct symb * next;
    struct symb * prev;
} symb;

void ajoutSymb (symb a);
void supprSymb (char* nom);
symb * recupSymb (char* nom);

symb creationSymb(char* nom, int prof, char init);
