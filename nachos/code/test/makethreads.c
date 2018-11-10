#include "syscall.h"

void Print(char c){

	PutChar('\n');
	PutChar(c);

	//Must not be in the main
	//In order to not shutdown the main instead of the thread
	ThreadExit();
}

void Print2(char c){


	PutString("Coucou\n");

	//Must not be in the main
	//In order to not shutdown the main instead of the thread
	ThreadExit();
}

/*
 * Tester comportement PutChar & GetChar en thread
 */


int main(){
	int i;
	for(i=0;i<2;i++){
		ThreadCreate(Print, 'a'+i);
	}
	//ThreadCreate(Print, 'a');
	PutChar('f');
	ThreadExit();
	//return 0;
}
