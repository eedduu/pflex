CXX = g++  -w -std=c++11

all: prueba

lex.yy.c: vingere.l
	@flex vingere.l

prueba:	lex.yy.c
	@$(CXX) $^ -o $@ -lfl

clean: 
	rm lex.yy.c prueba codificado.txt descodificado.txt
