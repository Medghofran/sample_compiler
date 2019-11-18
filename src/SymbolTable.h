#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

struct symrec
{
    char *name;
    int addr;
    char *type;
    struct symrec *next; 
};

typedef struct symrec symrec;
symrec *putsym();
symrec *getsym();
symrec *putnum();
void set_type();
void set_proc();
void set_func();
void print_sym_table();

#endif /*SYMBOL_TABLE_H*/