%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
int top = -1;
int stack[10]; 
%}
%union{
int ival;
}
%token<ival> INUMBER
%token LOAD ADD SUB MUL MOD INC DEC
%token SPACE NEXTLINE END_OF_FILE
%%
lines : line
      | lines line
      ;
line : LOAD SPACE INUMBER {top++;stack[top]=$3;}
     | ADD    	 {if(top==0){printf("Invalid format\n");return(0);} 
		  else{stack[top-1]=stack[top]+stack[top-1];top--;}}
     | SUB	 {if(top==0){printf("Invalid format\n");return(0);}
                  else{stack[top-1]=stack[top]-stack[top-1];top--;}}
     | MUL 	 {if(top==0){printf("Invalid format\n");return(0);}
                  else{stack[top-1]=stack[top]*stack[top-1];top--;}}
     | MOD 	 {if(top==0){printf("Invalid format\n");return(0);}
                  else{stack[top-1]=stack[top]%stack[top-1];top--;}}
     | INC   	 {stack[top]++;}
     | DEC   	 {stack[top]--;}
     | NEXTLINE  {}
     | END_OF_FILE	 {if(top>0){printf("Invalid format\n");}
        		  else{printf("%d\n",stack[0]);}return(0);}
     ;
%%
void yyerror(const char *message){
	fprintf(stderr,"%s\n",message);
}
int main(int argc,char *argv[]){
	yyparse();
	return(0);
}
