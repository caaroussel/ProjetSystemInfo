void main(void)
{
    int a, b = 6, c, d;

    if (b > 4) {
        a = 5;
        print(a);
    } else {
        a = 2;
        print(a);
    }

    c = a + b * 2;
    print(c);

    if (c <= 0) {
        a = c * 3;
    }

    d = 4 * 3 - 2;

    while (a > 0) {
        print(a);
        a = a - 1;
    }

    print(d);
}