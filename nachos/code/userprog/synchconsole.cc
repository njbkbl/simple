#ifdef CHANGED
#include "copyright.h"
#include "system.h"
#include "synchconsole.h"
#include "synch.h"

static Semaphore *readAvail;
static Semaphore *writeDone;
static Semaphore *consoleMutex;
static void ReadAvailHandler(void *arg) { (void) arg; readAvail->V(); }
static void WriteDoneHandler(void *arg) { (void) arg; writeDone->V(); }

SynchConsole::SynchConsole(const char *in, const char *out)
{
	readAvail = new Semaphore("read avail", 0);
	writeDone = new Semaphore("write done", 0);
	consoleMutex = new Semaphore("consoleMutex", 1);
	console = new Console (in, out, ReadAvailHandler, WriteDoneHandler, 0);
}
SynchConsole::~SynchConsole()
{
	delete console;
	delete writeDone;
	delete readAvail;
	delete consoleMutex;
}
void SynchConsole::SynchPutChar(int ch)
{
	consoleMutex->P();

	console->PutChar (ch);
	writeDone->P ();

	consoleMutex->V();
}
int SynchConsole::SynchGetChar()
{
	consoleMutex->P();
	readAvail->P ();	// wait for character to arrive
	int character = console->GetChar ();
	consoleMutex->V();
	return character;
}
void SynchConsole::SynchPutString(const char s[])
{
	int i = 0;
	while(s[i] != '\0'){
		SynchPutChar(s[i]);
		i++;
	}
}
void SynchConsole::SynchGetString(char *s, int n)
{
	// No need of mutex because of context changes on process
	for(int i=0;i<n;i++){
		s[i] = SynchGetChar();
	}
}

int SynchConsole::copyStringFromMachine(int from, char *to, unsigned size)
{
	int character = 'a';
	unsigned i=0;

	while(character != '\0' && i<size){
		machine->ReadMem(from+i, 1, &character);
		to[i] = (char) character;
		i++;
	}
	to[i] = '\0';

	return i;
}

int SynchConsole::copyStringToMachine(char* from, int to, unsigned size)
{
	unsigned i=0;

	while(i < size && from[i] != '\0' && from[i] != '\n'){
		machine->WriteMem(to+i, 1, from[i]);
		i++;
	}
	machine->WriteMem(to+i, 1, '\0');

	return i;
}

#endif // CHANGED
