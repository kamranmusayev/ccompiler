%{ 

	#include <stdio.h> 

	#include <iostream> 

	#include <string> 

	#include <vector> 

	using namespace std; 

	#include "y.tab.h" 

	extern FILE *yyin; 

	extern int yylex(); 

	void yyerror(string s); 

	extern int linenum; 

	string finalOutput; 

	vector<pair<string,string>> functions; //First string conatins the name of the string the second string contains statements in it.

	 

%} 

  



%token VOID MAIN IFRKW COMA INTRKWA WHILERKW SEMICOLON OP CP OCB CCB  EQ EQSMALLER EQLARGER DEFINERSW 

%token <str> ANDOR IDENTIFIER INTEGER COMP OPER 
%type<str> Ident operand comparison multi_var init comparison_block

%union{ 

	char * str; 

	int number; 

} 

  

%% 

  

statements: 

	statement statements
	| 
	; 

  

statement: 

	VOID Ident OP CP openCurly func closeCurly {functions.push_back(make_pair(string($2),finalOutput));finalOutput = "";}
	| 
	VOID MAIN OP CP openCurly func closeCurly {finalOutput = "void main()" + finalOutput;}
	; 

func:
	func inside_func
	|
	;
inside_func:
	condition_op condition_block openCurly func closeCurly
	|
	INTRKWA	multi_var SEMICOLON {finalOutput += "int "+string($2)+";\n";}
	|
	IDENTIFIER EQ init SEMICOLON {finalOutput += string($1) + " = " + string($3) + ";\n"; }
	|
	IDENTIFIER OP CP SEMICOLON{	int index; bool find=false;
								for(int i = 0;i<functions.size();i++){
									if(string($1) == functions.at(i).first)
									{index = i;find = true;break;}	
								}
								if(find)
									finalOutput += functions.at(index).second;
								else{
									cout<<"error: function "+string($1)+" does not exists"<<endl;
									exit(1);
									} 
							}
	;

init:
	operand {$$ = strdup($1);}
	|
	operand OPER init {$$ = strdup(string(string($1) + string($2)+ string($3)).c_str());}
	;


multi_var:
	IDENTIFIER {$$ = strdup($1);}
	|
	IDENTIFIER COMA multi_var {$$ = strdup(string(string($1) + "," + string($3)).c_str());}
	;
	

	
condition_op: 
	IFRKW  {finalOutput += "if";}
	| 
	WHILERKW {finalOutput += "while";}
	; 

condition_block: 
	OPA comparison_block CPA
	; 

comparison_block: 
	comparison_block ANDOR comparison {finalOutput += string($2)+ string($3);}
	| 
	comparison {finalOutput += string($1);}
	; 

comparison: 
	operand COMP operand {$$ = strdup(string(string($1)+string($2) + string($3)).c_str());}
	; 

operand: 
	IDENTIFIER  {$$ = strdup($1);}
	| 
	INTEGER {$$ = strdup($1);}
	; 
Ident:
	IDENTIFIER {$$ = strdup($1);}
	;
openCurly: 
	OCB  {finalOutput += "\n{\n";}
	; 

closeCurly: 
	CCB {finalOutput += "}\n";}
	; 
OPA:
	OP{finalOutput += "(";}
	;
CPA:
	CP{finalOutput += ")";}
%% 

void yyerror(string s){ 

  

		cerr<<"Error at line: "<<linenum<<endl; 

} 

int yywrap(){ 

	return 1; 

} 

int main(int argc, char *argv[]) 

{ 

    /* Call the lexer, then quit. */ 

    yyin=fopen(argv[1],"r"); 
    yyparse(); 
    fclose(yyin); 
	cout<<finalOutput; 

    return 0; 

} 