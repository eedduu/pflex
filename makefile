CXX = g++  -w -std=c++11

all: prog

lex.yy.c: vingere.l
	@flex vingere.l

prog:	lex.yy.c
	@$(CXX) $^ -o $@ -lfl

clean: 
	rm lex.yy.c prog codificado.txt descodificado.txt
