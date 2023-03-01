CXX = g++

TARGET = myASTgenerator

SRCS = lex.yy.c parser.tab.c

all: $(TARGET) 
	./$(TARGET) $(input) >$(output) 

$(TARGET): $(SRCS)
	$(CXX) -o $@ $^

lex.yy.c: lexer.l
	flex $<

parser.tab.c parser.tab.h: parser.y
	bison -d -t $<

clean:
	rm -f $(TARGET) $(SRCS) parser.output graph.dot

.PHONY: all clean