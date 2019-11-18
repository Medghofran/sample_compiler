%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "SymbolTable.h"
    int errors;
    int lable;
    #define YYDEBUG 1

    install (char *sym_name)
    {
        symrec *s;
        s = getsym(sym_name);
        if (s == 0)
            s = putsym(sym_name);
        else {
            errors++;
            printf("%s is defined\n", sym_name);
        }
    }

    install_num (char *sym_name)
    {
        symrec *s;
        s = getsym(sym_name);
        if (s == 0)
            s = putnum(sym_name);
    }

    context_check(char *sym_name)
    {
        if (getsym(sym_name) == 0)
            printf("%s is undeclared\n", sym_name);
    }

    FILE* output;
%}
%union
{
    int intValue;
    float floatValue;
    char *stringValue;
    int adress;
}
%start program
%token <stringValue> ID
%token <stringValue> NUM
%token IF THEN PROGRAM VAR ARRAY
%token OF INTEGER REAL
%token FUNCTION PROCEDURE
%token START END
%token ASSIGNOP RELOP MULOP
%token ELSE WHILE DO
%token SIGN OR
%token DOUBLEDOT
%token NOT
%left '-' '+'
%left '*' '/'
%%
program: PROGRAM ID '(' prog_list ')' ';' declarations subprogram_declarations compound_statement '.'
         ;
prog_list: ID
         | prog_list ',' ID
         ;
identifier_list: ID  {install($1);}
         | identifier_list ',' ID {install($3);} 
         ;
declarations: declarations VAR identifier_list ':' type ';'
         | /* empty */
         ;
type: standart_type
         | ARRAY '[' NUM DOUBLEDOT NUM ']' OF REAL {set_type("REALARR");}
         | ARRAY '[' NUM DOUBLEDOT NUM ']' OF INTEGER {set_type("INTARR");}
         ;
standart_type: INTEGER {set_type("INTEGER");}
         | REAL {set_type("REAL");}
         ;
subprogram_declarations: subprogram_declarations subprogram_declaration ';'
         | /* empty */
;
subprogram_declaration: subprogram_head declarations compound_statement;
subprogram_head: FUNCTION ID arguments ':' INTEGER ';' {install($2); set_type("INTEGER");}
         | FUNCTION ID arguments ':' REAL ';' {install($2); set_type("REAL");}
         | PROCEDURE ID arguments ';' {install($2); set_proc($2);}
         ;
arguments: '(' parameter_list ')'
         | /* empty */;
parameter_list: identifier_list ':' type
         | parameter_list ';' identifier_list ':' type
         ;
compound_statement: START
                    optional_statements END
         ;
optional_statements: statement_list
         | /* empty */
         ;
statement_list: statement
         | statement_list ';' statement
         ;
statement: variable ASSIGNOP expression
         | procedure_statement
         | compound_statement
         | IF expression THEN statement ELSE statement
         | WHILE expression DO statement
         ;
variable: ID {context_check($1);}
         | ID '[' expression ']' {context_check($1);}
         ;
procedure_statement: ID 
         | ID '(' expression_list ')'
         ;
expression_list: expression
         | expression_list ',' expression
         ;
expression: simple_expression
         | simple_expression RELOP simple_expression
         ;
simple_expression: term
         | SIGN term
         | simple_expression SIGN term
         | simple_expression OR term
         ;
term: factor
         | term MULOP factor
         ;
factor: variable
         | ID '(' expression_list ')' {context_check($1);}
         | NUM {install_num($1);}
         | '(' expression ')'
         | NOT factor
         ;
%%
int main (int argc, char *argv[]) {
    output = fopen("bin/output.asm", "w");
    fprintf(output, "\t  jump.i #lab0\n");
    extern FILE *yyin;
    
    if(argc > 1)
    {
        yyin = fopen(argv[1], "r");
        errors = 0;
        yyparse();
        print_sym_table();
        fprintf(output, "\t  exit");
        fclose(output);
    }
    else{
        printf("ERROR : no file was given");
    }

    return 0;
}

yyerror (char *s) /* Called by yyparse on error */
{
    errors++;
    printf ("%s\n", s);
}