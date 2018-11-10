#include "syscall.h"

void print(char *c){
	#if 1
	PutString(c);
	#endif
}

void printStringTest(){
	print("Post emensos insuperabilis expeditionis\
	eventus languentibus partium animis, quas periculorum\
	varietas fregerat et laborum, nondum tubarum cessante\
	clangore vel milite locato per stationes hibernas,\
	fortunae saevientis procellae tempestates alias rebus\
	infudere communibus per multa illa et dira facinora Caesaris\
	Galli, qui ex squalore imo miseriarum in aetatis adultae primitiis\
	ad principale culmen insperato saltu provectus ultra terminos\
	potestatis delatae procurrens asperitate nimia cuncta foedabat.\
	propinquitate enim regiae stirpis gentilitateque etiam tum Constantini\
	nominis efferebatur in fastus, si plus valuisset, ausurus hostilia in\
	auctorem suae felicitatis, ut videbatur.\n"); // Test pour chaines longues
	print("!\n");
	print("\n"); // Ce test devrait afficher seulement un saut de ligne
	print("En"); // Chaine sans '\n' -> le programme devrait
							// ne pas passer à l'instruction suivante
}

int main(){
	int n = 1;
	printStringTest();
	//Test 1
	/*PutInt(2147483647); // test extreme positif
	PutString("\n");
	PutInt(-2147483648); // test extreme negatif
	PutString("\n");*/

	// Test 2

	GetInt(&n);
	PutString("\n");
	PutInt(n);
	PutString("\n");

	ThreadExit();
	//return 0;
}
