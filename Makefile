all: lex

lex.tab.c lex.tab.h: lex.y
	bison -t -v -d lex.y

lex.yy.c: lex.l lex.tab.h
	flex lex.l

lex: lex.yy.c lex.tab.c lex.tab.h
	gcc -o lex lex.tab.c lex.yy.c ts.c ti.c tn.c tf.c

clean:
	rm lex lex.tab.c lex.yy.c lex.tab.h lex.output

test: all
	echo "int compute(int a, int e) { int b; const int d = 2*6; int c = a + 2 * 5; b = a; while (c > 0) { b = b + a * 4; print(b);} return b;} void main(void) {int a = 3;if (a == 3) {int c = 3 + 5; c = compute(5, a);} else { int b = 6; a = a + 2;}}" | ./lex

testIf: all
	echo "void main(void) {int a = 5;if (a == 3) {print(a);if(a == 3){int c = 6;}} }" | ./lex

testWhile: all
	echo "void main(void) {int a = 5;while (a == 3) {while(a == 3){int c = 6;}print(a);} }" | ./lex