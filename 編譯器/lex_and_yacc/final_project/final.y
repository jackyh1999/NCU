%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
void Error(int col);
struct{
	int type;	// 
	int value;
}Stack;
Stack stack[100];
int top = -1;
%}

%union {
int bool;
int ival;
char* word;
}
%token<bool> bool-val
%token<word> id
%token<ival> number
%token print-num print-bool
%token mod and or not

%%
PROGRAM	:	STMTs
		;
STMTs	:	STMT
		|	STMTs STMT
		;
STMT	:	EXP 
		|	DEF-STMT
		|	PRINT-STMT
		;
PRINT-STMT	:	'(' print-num EXP ')'	{printf("%d",stack[top].value);}
			|	'(' print-bool EXP ')'	{printf("%d",stack[top].value);}
			;
EXPs	:	EXP
		|	EXPs EXP
		;
EXP		:	bool-val	{top++;stack.type = 0;stack.value = $1;}
		|	number		{top++;stack.type = 1;stack.value = $1;}
		|	VARIABLE
		|	NUM-OP
		|	LOGICAL-OP
		|	FUN-EXP
		|	FUN-CALL
		|	IF-EXP
		;
NUM-OP	:	PLUS
		|	MINUS
		|	MULTIPLY
		|	DIVIDE
		|	MODULUS
		|	GREATER
		|	SMALLER
		|	EQUAL
		;
PLUS	:	'(' '+' EXP EXPs ')'	{}
		;
MINUS	:	'(' '-' EXP EXP ')'
		;
MULTIPLY	:	'(' '*' EXP EXPs ')'
		;
DIVIDE	:	'(' '/' EXP EXP ')'
		;
MODULUS	:	'(' mod EXP EXP ')'
		;
GREATER	:	'(' '>' EXP EXP ')'
		;
SMALLER	:	'(' '<' EXP EXP ')'
		;
EQUAL	:	'(' '=' EXP EXPs ')'
		;
LOGICAL-OP	:	AND-OP
			|	OR-OP
			|	NOT-OP
			;
AND-OP	:	'(' and EXP EXPs ')'
		;
OR-OP	:	'(' or EXP EXPs ')'
		;
NOT-OP	:	'(' not EXP ')'
		;
DEF-STMT	:	'(' define VARIABLE EXP ')'
			;
VARIABLE	:	id
			;
FUN-EXP	:	'(' fun FUN_IDs FUN-BODY ')'
		;
ids		:	id
		|	ids id
		;
FUN_IDs	:	'(' ids ')'
		|	'(' ')'
		;
FUN-BODY	:	EXP
			;
FUN-CALL	:	'(' FUN-EXP PARAMs ')'
			|	'(' FUN-NAME PARAMs ')'
			;
PARAMs	:
		|	PARAM
		|	PARAMs PARAM
		;
PARAM	:	EXP
		;
LAST-EXP	:	EXP
			;
FUN-NAME	:	id
			;
IF-EXP	:	'(' if TEST-EXP THEN-EXP ELSE-EXP ')'
		;
TEST-EXP	:	EXP
			;
THEN-EXP	:	EXP
			;
ELSE-EXP	:	EXP
			;

%%
void yyerror (const char *message)
{
    fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}