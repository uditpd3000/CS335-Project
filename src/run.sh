flex lexer.l
bison -d -t parser.y
g++ lex.yy.c parser.tab.c -o myCodeGenerator
./myCodeGenerator ../input.java ../output/graph.dot ../output/ThreeAddressCode.3ac
dot -Tps ../output/graph.dot -o ../output/graph.ps
