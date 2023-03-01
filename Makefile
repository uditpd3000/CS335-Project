TARGET = myASTgenerator
SRCS = lex.yy.c parser.tab.c
VERBOSE=verbose.txt

default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@echo "\nYou can use these methods--\n"
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
	@echo "\n"

.PHONY: build
build : # generate files for the executable
	@echo "building your AST Generator...\n"
	@flex lexer.l
	@bison -d -t parser.y 2> error.txt
	@g++ lex.yy.c parser.tab.c -o $(TARGET)
	@rm error.txt

.PHONY: run
run: # run the executable using input like `make run input-file-path.java` or else run with terminal input
	@./$(TARGET) $(input)
	@[ -e $(VERBOSE) ] && rm $(VERBOSE) || echo "\n~~~Generated tree in Non Verbose Mode~\n"
	@dot -Tps graph.dot -o graph.ps

.PHONY: verbose
verbose: # run the executable in verbose
	@ ./$(TARGET) $(input)
	@ echo "the emplementation follows-\n"
	@ cat $(VERBOSE)
	@ rm $(VERBOSE)
	@dot -Tps graph.dot -o graph.ps

.PHONY: graph
graph: # to show dot file
	@cat graph.dot

.PHONY: clean
clean : # clean up the generated files
	@echo "cleaning up...\n"
	@rm -f $(TARGET) $(SRCS) parser.output graph.dot