CXX = g++ -O2 -w -std=c++11

all: prueba

lex.yy.c: vingere.l
	@flex vingere.l

prueba:	lex.yy.c
	@$(CXX) $^ -o $@ -lfl

