%{
#include "parser.tab.h"
#include <string.h>
#define YY_FLEX_DEBUG 1
%}

letter      [a-zA-Z]
digit       [0-9]
ID          {letter}({letter}|{digit})*
delim       [ \t\n]
NUM         {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+

%%
{ws}        {                                           }
if          {return(IF);                                }
then        {return(THEN);                              }
else        {return(ELSE);                              }
{NUM}       {yylval.stringValue = strdup(yytext); return(NUM);          }
"<"         {yylval.stringValue = "<"; return(RELOP);   }
"<="        {yylval.stringValue = "<="; return(RELOP);  }
"="         {yylval.stringValue = "="; return(RELOP);   }
">"         {yylval.stringValue = ">"; return(RELOP);   }
">="        {yylval.stringValue = ">="; return(RELOP);  }
"<>"        {yylval.stringValue = "<>"; return(RELOP);  }
":="        {return(ASSIGNOP);                          }
do          {return(DO);                                }
program     {return(PROGRAM);                           }
var         {return(VAR);                               }
array       {return(ARRAY);                             }
of          {return(OF);                                }
integer     {return(INTEGER);                           }
real        {return(REAL);                              }
function    {return(FUNCTION);                          }
procedure   {return(PROCEDURE);                         }
begin       {return(START);                             }
end         {return(END);                               }
div         {yylval.stringValue = "div"; return(MULOP); }
mod         {yylval.stringValue = "mod"; return(MULOP); }
and         {yylval.stringValue = "and"; return(MULOP); }
"*"         {yylval.stringValue = "*"; return(MULOP);   }
"/"         {yylval.stringValue = "/"; return(MULOP);   }
while       {return(WHILE);                             }
or          {return(OR);                                }
"+"         {yylval.stringValue = "+"; return(SIGN);    }
"-"         {yylval.stringValue = "-"; return(SIGN);    }
".."        {return(DOUBLEDOT);                         }
","         {return *yytext;                            }
"("         {return *yytext;                            }
")"         {return *yytext;                            }
"["         {return *yytext;                    }
"]"         {return *yytext;                    }
";"         {return *yytext;                                }
":"         {return *yytext;                                }
"."         {return *yytext;                                }
not         {return(NOT);                               }
{ID}        {yylval.stringValue= strdup(yytext); return(ID);}
%%
int yywrap(void){}