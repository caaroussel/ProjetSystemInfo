int factorial(int num) {
    int result = 1;
    int i;
    while (num > 0) {
        result = result * num;
        num = num - 1;
    }
    return result;
}

void main(void) {
    int n = 5;
    int fact = factorial(n);
    print(fact);
}
