CC=gcc
CFLAGS  = -Wall -g -Wno-unused-variable
LDFLAGS = -lm
OUTFOLDER=bin/
OBJFOLDER=obj/
TEST = $(wildcard test/*.ll)

.PHONY: clean test

all : $(OBJS)

%.c: %.y
%.c: %.l


#compile the bison gramar definition file.
parser.tab.c parser.tab.h: parser.y SymbolTable.h
	@bison -t -v -d --output parser.tab.c parser.y

#compile the flex lexer file
lexer.yy.c: lexer.l parser.tab.h
	@flex -o $@ $< 

#compile the lexer without linking
$(OBJFOLDER)lexer.o: lexer.yy.c
	@echo "creating intermediate code for $@ ...."
	@mkdir -p $(OBJFOLDER)
	@$(CC) $(CFLAGS) -c -o $@ $^

#compile the parser without linking
$(OBJFOLDER)parser.o: parser.tab.c
	@echo "creating intermediate code for $@ ...."
	@mkdir -p $(OBJFOLDER)
	@$(CC) $(CFLAGS) -c -o $@ $^

#compile the symbol table without linking
$(OBJFOLDER)SymbolTable.o: SymbolTable.c
	@echo "creating intermediate code for $@ ...."
	@mkdir -p $(OBJFOLDER)
	@$(CC) $(CFLAGS) -c -o $@ $^

#rule to assemble the parts together
main: $(OBJFOLDER)lexer.o $(OBJFOLDER)parser.o $(OBJFOLDER)SymbolTable.o 
	@echo "compiling...."
	@mkdir -p $(OUTFOLDER)
	@$(CC) $(CFLAGS) -o $(OUTFOLDER)$@ $^ $(LDFLAGS)

#rule to test 
test:
	@$(OUTFOLDER)main test/test.ll

#rule to clean the project stucture
clean: 
	@echo "cleaning solution..."
	@rm -rf $(OBJFOLDER) $(OUTFOLDER) parser.output parser.tab.h parser.tab.c lexer.yy.c
	@echo "done."