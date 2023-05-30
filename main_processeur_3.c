int compute(int a, int b){
    int c = a + b * 2;
    int d;
    if(c > 0){
        d = c * 3;
    }
    return d;
}

void afficher(){
    print(6);
}

int valide(int c){
    int a;
    if(c > 4){
        a = 5;
    }else{
        a = 2;
    }
    return a;
}

void main(void) {
    int a = 3;
    int b = compute(a, 5);
    int c = valide(5);
    print(b);
    while(a > 0){
        a = a - 1;
    }
    afficher();
}