%{
#include <iostream>
#include <vector>
#include <string>
#include <fstream>
using namespace std;

	vector<vector<char>> vingere();
	string codificar(string pc);
	string decodificar(string pc);
	string codificarFecha(string fecha);
	string decodificarFecha(string fecha);
	int pos(char letra);
	void menu();

	int nc;
	bool cod;
	string cadena;
	string palabram;
	string salida;
	int desplazamiento;
	const int NUM = 31;
	vector<vector<char>> matriz;
%}

natural [0-9]+
entero  ("-"{natural}|{natural})
racional ({entero}"."{natural})
numero {natural}|{entero}|{racional}
letra [a-zA-Z]
palabra ({letra}+)
especial [:#;]
fecha (0[1-9]|[1-2][0-9]|3[0-1])("/"|"-")((0(1|3|5|7|8))|(10|12))("/"|"-")([0-2][0-9][0-9][0-9])|(0[1-9]|[1-2][0-9]|30)("/"|"-")((0(4|6|9))|11)("/"|"-")([0-2][0-9][0-9][0-9])|(0[1-9]|1[0-9]|2[0-8])("/"|"-")02("/"|"-")([-2][0-9][0-9][0-9])
			//Fechas meses 31 días																																			//Fecha meses 30 días																						          	//Febrero

fechacod [0-9][0-9]",,"[0-9][0-9]",,"[0-9][0-9][0-9][0-9]
%%

{fechacod}	salida+=decodificarFecha(yytext);
{numero}	{
	string num(yytext), out;
	bool neg=false;
	if (num.front()=='-') neg=true;
	for(unsigned int i=0; i<num.size();i++)
	{
		if(num[i]!='.' && !neg)
			{
				string aux= num.substr(i,1);
				int digito = stoi(aux);
				digito=(digito+desplazamiento)%10;
				if(digito<0) digito=10+digito;
				out+=to_string(digito);
			}
		else if (neg)
		{
			out+="-";
			neg=false;
		}
		else
			out+=".";
	}
	salida+=out;
}
{palabra}   {
    string a(yytext);
		if (cod)
			salida += codificar(a);
    else
			salida += decodificar(a);
	}
{fecha} {
		if (cod)
			salida += codificarFecha(yytext);
		else
			salida+= decodificarFecha(yytext);
		}
(\t)+	salida+="\t";
(\n)+	salida+="\n";
([ ])	salida+=" ";
(,)   salida+=".";
(\.)   salida+=",";
. salida+=yytext;




%%

string codificarFecha (string fecha){
	string sal;
	for(unsigned int i=0; i<fecha.size();i++)
	{
		if(fecha[i]=='/')
		{
			sal+=",,";
		}
		else
		{
			string aux=fecha.substr(i,1);
			int a=(stoi(aux));
			a=(a+desplazamiento)%10;
			sal+=to_string(a);
		}

	}
	return sal;
}

string decodificarFecha(string fecha){
	string sal;
	bool pasar=false;
	for(int i=0; i<fecha.size(); i++)
	{
		if(fecha[i]==',')
		{
			if(!pasar)
			{
				sal+="/";
				pasar=true;
			}
			else
				pasar=false;
		}
		else
		{

			string aux=fecha.substr(i,1);
			int a=(stoi(aux));
			a=(a+desplazamiento)%10;
			if (a<0) a=10+a;
			sal+=to_string(a);

		}
	}
	return sal;
}

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
		desplazamiento=palabram.size();

    	matriz = vingere();
		bool salid=true, pantalla=true;
		char opcion, conf;


		menu();
		cin >> opcion;

		switch(opcion){
			case 'c':
				cod = true;
				yylex();
				cout << "¿Quiere mostrar la salida en pantalla(S/N)? (En caso contrario se guardará en codificado.txt)" << endl;
				cin >> conf;
				break;
			case 'd':
				cod = false;
				desplazamiento=-desplazamiento;
				yylex();
				cout << "¿Quiere mostrar la salida en pantalla(S/N)? (En caso contrario se guardará en descodificado.txt)" << endl;
				cin >> conf;
				break;
			default:
				salid = false;
				break;
		}
	if(conf=='N' || conf=='n' || conf=='No' || conf=='NO') pantalla=false;
	if (salid){
			if(pantalla)
			{
				salida.resize(salida.size()-1);
	    	cout << salida << endl;
			}
			else
			{
				string nombre;
				if(cod)
				{
					nombre="codificado.txt";
				}
				else
					nombre="descodificado.txt";

				ofstream archivo;
				archivo.open(nombre);
				archivo << salida << endl;
			}
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
