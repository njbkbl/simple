#include "syscall.h"

void print(char c, int n){
	int i;
	#if 1
	for(i=0;i<n;i++){
		PutChar(c + i);
	}
	PutChar('\n');
	#endif
}

void printTest(){
	print('a', 1); // charactere simple
	print('@', 1); // caractere ascii "aleatoire"
	print('er', 2); // Ce test reussit a la
									//compilation et donne 'rs' en resultat
	print('é',1); // Test sur un caractere unicode
								// Le caractere ne devrait pas etre reconnu
}

int main(){
	printTest(); // Ensemble des tests sur putchar
	print(GetChar(), 1);
	ThreadExit();
	//return 0;
}
