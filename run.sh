flex lexer.l
bison -d -t myparser.y
g++ lex.yy.c myparser.tab.c
./a.out input.java