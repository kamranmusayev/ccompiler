digit    [0-9]
letter    [A-Za-z]
%{
  #include <stdio.h>
  #include <string.h>
  #include "y.tab.h"
  #include <iostream>
  using namespace std;

  int linenum=1;
%}
%%

"void" return VOID;
"main" return MAIN;
"if"    return IFRKW;
"," return COMA;
"while"    return WHILERKW;
"int" return INTRKWA;
";"    return SEMICOLON;
"(" return OP;
")" return CP;
"{" return OCB;
"}" return CCB;
"=" return EQ;
"+"|"-"|"*"|"/" {yylval.str=strdup(yytext);return OPER;}
"||"|"&&" { yylval.str=strdup(yytext); return ANDOR;}
"<"|">"|"<="|">="|"=="|"!=" { yylval.str=strdup(yytext); return COMP;}

{letter}({letter}|{digit})*    { yylval.str=strdup(yytext); return IDENTIFIER;}
[0-9]+    {yylval.str=strdup(yytext); return INTEGER;}
\n    {linenum++;}
[ \t]+
%%