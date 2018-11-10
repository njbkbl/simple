#include "syscall.h"

void print(int i){
	#if 1
	PutInt(i);
	#endif
}

void printIntTest(){
  int n = 1;
  PutInt(n); // test sur un entier simple : resultat attendu : "1"

  //Tests 1 : pour ces deux tests, le nombre en entrée
  //devrait s'afficher correctement dans la console.

  PutInt(2147483647); // test extreme positif
	PutString("\n");
	PutInt(-2147483648); // test extreme negatif
	PutString("\n");

  // Test 2
  PutInt(3000000000); // Le resultat devrait etre imprevisible
                      // car l'entier s'ecrit sur plus de 4 octets

  // Test 2
	GetInt(&n);
	PutString("\n");
	PutInt(n);
	PutString("\n");
}

int main(){
	printIntTest();
	ThreadExit();
	//return 0;
}
