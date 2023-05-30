int racine(int nombre) {
    int racine = 0;
    int carre = 0;
    int i = 0;
    
    while (i < nombre) {
        carre = racine * racine;
        if (carre == nombre) {
            i = nombre;
        } else {
            racine = racine + 1;
            i = i + 1;
        }
    }

    return racine;
}

void main(void) {
    int nombre = 25;
    int resultat = racine(nombre);

    if (resultat != nombre) {
        print(resultat);
    }
}