flex lexer.l
bison -d -t parser.y
g++ lex.yy.c parser.tab.c -o myCodeGenerator
./myCodeGenerator ../inputArthmetic.java ../output/graph.dot ../output/ThreeAddressCode.3ac ../output/x86-output.s
# dot -Tps ../output/graph.dot -o ../output/graph.ps
