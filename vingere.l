%{
#include <iostream>
#include <vector>
#include <string>
using namespace std;

	vector<vector<char>> vingere();
	string codificar(string pc);
	string decodificar(string pc);
	int pos(char letra);
	void menu();

	int nc;
	bool cod;
	string cadena;
	string palabram;
	string salida;
	const int NUM = 31;
	vector<vector<char>> matriz;
%}

natural [0-9]+
entero  "-"{natural}
racional ({entero}"."{natural})
racional2	({natural}"."{natural})
letra [a-zA-Z]
especial [:#;]
palabra ({letra}+)


%%

{natural}	salida+="N";
{entero}	salida+="E";
{racional}	salida+="R";
{racional2}	salida+="R";
{palabra}   {
    string a(yytext);
	if (cod)
		salida += codificar(a);
    else
		salida += decodificar(a);
	}

(\t)+	salida+="\t";
(\n)+	salida+="\n";
([ ])	salida+=" ";
(,)   salida+=".";
(.)   salida+=",";




%%


int main (int argc, char *argv[]){

		if (argc == 3){
			yyin = fopen(argv[1],"rt");
			palabram = argv[2];
			if (yyin == NULL){
				cout << "Error de lectura" << endl;
				exit(1);
			}
		}
		else{
			cout << "Error introduciendo los datos" << endl;
			exit(1);
		}

    	matriz = vingere();
		bool m=true;
		char opcion;

		menu();
		cin >> opcion;

		switch(opcion){
			case 'c':
				cod = true;
				yylex();
				break;
			case 'd':
				cod = false;
				yylex();
				break;
			default:
				m = false;
				break;
		}

	if (m){
			salida.resize(salida.size()-1);
    		cout << salida << endl;
		}
}


	vector<vector<char>> vingere(){
		vector<vector<char>> salida;
		vector<char> abecedario = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
		vector<char> temporal;

		for (int i=0; i<abecedario.size(); i++){
        	temporal.resize(0);
        	for(int j=0; j<abecedario.size(); j++){
				temporal.push_back(abecedario[(j+i)%abecedario.size()]);
        	}
        	salida.push_back(temporal);
    	}

    	return salida;
	}

	string codificar (string pc){
    	string salida;
    	for (int i=0; i<pc.size(); i++ ){
        	salida.push_back(matriz[pos(pc[i])][pos(palabram[i%palabram.size()])]);
    	}
    	return salida;
	}

	string decodificar (string pc){
		string salida;
		vector<char> linea;
		bool esta;
		int p=0;

		for (int i=0;i<pc.size();i++){
			esta = false;
			linea = matriz[pos(palabram[i%palabram.size()])];
			for (int j=0; j<linea.size() && esta == false; j++){
				if (pc[i]==linea[j]){
					esta == true;
					p = j;
				}
			}
			salida.push_back(matriz[0][p]);
		}

		return salida;
	}

	int pos(char letra){
    	return (letra & NUM)-1;
	}

	void menu(){
		cout << "Introduce:"<< endl;
		cout << "d) --> Para decodificar" << endl;
		cout << "c) --> Para codificar " << endl;
		cout << "s) --> Para salir " <<endl;
	}
