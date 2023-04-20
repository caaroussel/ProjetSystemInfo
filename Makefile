all: lex

lex.tab.c lex.tab.h: lex.y
	bison -t -v -d lex.y

lex.yy.c: lex.l lex.tab.h
	flex lex.l

lex: lex.yy.c lex.tab.c lex.tab.h
	gcc -o lex lex.tab.c lex.yy.c ts.c ti.c tn.c

clean:
	rm lex lex.tab.c lex.yy.c lex.tab.h lex.output

test: all
	echo "int compute(int a, int d) {int b, c = a + d * 5;b = a;while (c > 0) { b = b + a * 4;}return b;} void main(void) {int a;if (a == 3) {print(a);} else {int b = compute(a, 2 * a);print(b);}}" | ./lex

testIf: all
	echo "void main(void) {int a = 5;if (a == 3) {print(a);if(a == 3){int c = 6;}} }" | ./lex

testWhile: all
	echo "void main(void) {int a = 5;while (a == 3) {while(a == 3){int c = 6;}print(a);} }" | ./lex