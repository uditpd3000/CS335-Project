TARGET = myCodeGenerator
SRCS = lex.yy.c parser.tab.c
VERBOSE=verbose.txt
acoutput = ../output/ThreeAddressCode.3ac
dot_output=../output/graph.dot
ps_output=../output/graph.ps
output = ../output/x86-output.s

default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@echo "\nYou can use these methods--\n"
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
	@echo "\n"

.PHONY: build
build : # generate files for the executable
	@echo "building your Three Address Code cum AST Generator...\n"
	@flex lexer.l
	@bison -d -t parser.y 2> error.txt
	@g++ lex.yy.c parser.tab.c -o $(TARGET)
	@rm error.txt

.PHONY: run
run: # run the executable using input like `make run input=filepath output=x86-filepath` or else run with terminal input
	@echo "compiling up...\n"
	@./$(TARGET) $(input) $(dot_output) $(acoutput) $(output)
	@[ -e $(VERBOSE) ] && rm $(VERBOSE) || echo "\n~~~Generated tree in Non Verbose Mode~\n"
	@echo "find your results in output folder :p"

.PHONY: verbose
verbose: # run the executable in verbose like `make run input=filepath output=x86-filepath`
	@ ./$(TARGET) $(input) $(dot_output) $(acoutput) $(output)
	@ echo "the emplementation follows-\n"
	@ cat $(VERBOSE)
	@ rm $(VERBOSE)

.PHONY: graph
graph: # to show dot file
	@dot -Tps $(dot_output) -o $(ps_output)
	@cat $(dot_output)

.PHONY: threeAC
threeAC: # to show Three Address Code
	@cat $(acoutput)

.PHONY: asm
asm: # to show x86 Code
	@cat $(output)

.PHONY: clean
clean : # clean up the generated files
	@echo "cleaning up...\n"
	@rm $(TARGET) $(SRCS)
	@rm ../output/symTables/*.csv
	@rm $(acoutput) $(output)
	@rm $(dot_output) 
	@rm $(ps_output)
