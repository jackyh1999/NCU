%{
#include "hw1.tab.h"
%}
%%
load	{return(LOAD);}
add	{return(ADD);}
sub	{return(SUB);}
mul	{return(MUL);}
mod	{return(MOD);}
inc	{return(INC);}
dec	{return(DEC);}
" "	{return(SPACE);}
\n	{return(NEXTLINE);}
[0-9]+	{yylval.ival = atoi(yytext);return(INUMBER);}
<<EOF>> {return(END_OF_FILE);}
%%
