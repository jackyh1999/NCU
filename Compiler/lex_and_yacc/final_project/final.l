%{
#include "final.tab.h"
%}
separator	[\t\n\r ]
letter	[a-z]
digit	[0-9]
number	(0|[1-9]{digit}*|\-[1-9]{digit}*)
ID	{letter}({letter}|{digit}|'-')*

%%
"+"|"-"|"*"|"/"|">"|"<"|"="|"("|")"		{return(yytext[0]);}
mod		{return(mod);}
and		{return(and);}
or		{return(or);}
not		{return(not);}
ID		{yylval.word = yytext; return(id);}
number	{yylval.ival = atoi(yytext); return(number);}
#t		{yylval.bool = 1; return(bool-val);}
#f		{yylval.bool = 0; return(bool-val);}
"print-num"		{return(print-num);}
"print-bool"	{return(print-bool);}

%%