all: lex yacc 
	g++ lex.yy.c y.tab.c -ll -o project

yacc: Project.y
	yacc -d -v project.y

lex: Project.l
	lex project.l

clean: lex.yy.c y.tab.c project y.tab.h
	rm lex.yy.c y.tab.c project y.tab.h
