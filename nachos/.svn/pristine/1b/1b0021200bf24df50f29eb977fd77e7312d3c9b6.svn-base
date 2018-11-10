// exception.cc
//      Entry point into the Nachos kernel from user programs.
//      There are two kinds of things that can cause control to
//      transfer back to here from user code:
//
//      syscall -- The user code explicitly requests to call a procedure
//      in the Nachos kernel.  Right now, the only function we support is
//      "Halt".
//
//      exceptions -- The user code does something that the CPU can't handle.
//      For instance, accessing memory that doesn't exist, arithmetic errors,
//      etc.
//
//      Interrupts (which can also cause control to transfer from user
//      code into the Nachos kernel) are handled elsewhere.
//
// For now, this only handles the Halt() system call.
// Everything else core dumps.
//
// Copyright (c) 1992-1993 The Regents of the University of California.
// All rights reserved.  See copyright.h for copyright notice and limitation
// of liability and disclaimer of warranty provisions.

#include "copyright.h"
#include "system.h"
#include "syscall.h"

#ifdef CHANGED
#include "userthread.h"
#include "synch.h"
#endif

//----------------------------------------------------------------------
// UpdatePC : Increments the Program Counter register in order to resume
// the user program immediately after the "syscall" instruction.
//----------------------------------------------------------------------
static void
UpdatePC ()
{
    int pc = machine->ReadRegister (PCReg);
    machine->WriteRegister (PrevPCReg, pc);
    pc = machine->ReadRegister (NextPCReg);
    machine->WriteRegister (PCReg, pc);
    pc += 4;
    machine->WriteRegister (NextPCReg, pc);
}


//----------------------------------------------------------------------
// ExceptionHandler
//      Entry point into the Nachos kernel.  Called when a user program
//      is executing, and either does a syscall, or generates an addressing
//      or arithmetic exception.
//
//      For system calls, the following is the calling convention:
//
//      system call code -- r2
//              arg1 -- r4
//              arg2 -- r5
//              arg3 -- r6
//              arg4 -- r7
//
//      The result of the system call, if any, must be put back into r2.
//
// And don't forget to increment the pc before returning. (Or else you'll
// loop making the same system call forever!
//
//      "which" is the kind of exception.  The list of possible exceptions
//      are in machine.h.
//----------------------------------------------------------------------

void
ExceptionHandler (ExceptionType which)
{
	int type = machine->ReadRegister (2);
	switch (which)
	{
	case SyscallException:
	{
		switch (type)
		{
		case SC_Halt:
		{
      //TO DO
      //If counterThread > 0
      //sleep
			DEBUG ('s', "Shutdown, initiated by user program.\n");
			interrupt->Halt ();
			break;
		}
		#ifdef CHANGED
    case SC_Exit:
    {
      int returnValue = machine->ReadRegister(4);
      if(returnValue == 0){
        interrupt->Halt();
      } else {
        printf("The user program failed\n");
        ASSERT(FALSE);
      }

    }
		case SC_PutChar:
		{
			DEBUG('s', "PutChar \n");
			int c = machine->ReadRegister(4);
			synchConsole->SynchPutChar(c);
			break;
		}
    case SC_PutString:
		{
			DEBUG('s', "PutString \n");
      char * buffer = new char[MAX_STRING_SIZE];


      //La chaine from commence au debut du registre 4
      //Il correspond au premier argument de la fonction copyString..;
			int from = machine->ReadRegister(4);

      int charRead = MAX_STRING_SIZE;

      while(charRead == MAX_STRING_SIZE){
        charRead = synchConsole->copyStringFromMachine(from, buffer,MAX_STRING_SIZE);
        synchConsole->SynchPutString(buffer);
        from = from+charRead;
      }

      delete buffer;
			break;
		}
    case SC_GetChar:
		{
			DEBUG('s', "GetChar \n");
			int c = synchConsole->SynchGetChar();
      machine->WriteRegister(2, c);

			break;
		}
    case SC_GetString:
		{
			DEBUG('s', "GetString \n");

      char * buffer = new char[MAX_STRING_SIZE];

      int s = machine->ReadRegister(4);
      int n = machine->ReadRegister(5);

      int charRead = MAX_STRING_SIZE;

      while(charRead == MAX_STRING_SIZE && n != 0){
          synchConsole->SynchGetString(buffer, MAX_STRING_SIZE);
          charRead = synchConsole->copyStringToMachine(buffer, s, MAX_STRING_SIZE);
          s += charRead;
          n -= charRead;
      }

      delete buffer;
      buffer = NULL;
			break;
		}
    case SC_PutInt:
    {
      DEBUG('s', "PutInt \n");
      int BUFFER_SIZE = 12; //12 : Nb of characters necessary to write an integer on 4o (10+sign+'\0')

      char * buffer = new char[BUFFER_SIZE];
      int num = machine->ReadRegister(4);
      snprintf(buffer, BUFFER_SIZE, "%d", num);
      synchConsole->SynchPutString(buffer);

      delete buffer;
      break;
    }
    case SC_GetInt:
    {
      DEBUG('s', "GetInt \n");
      int BUFFER_SIZE = 12; //12 : Nb of characters necessary to write an integer on 4o (10+sign+'\0')

      char * buffer = new char[BUFFER_SIZE];
      int addrNum = machine->ReadRegister(4);

      synchConsole->SynchGetString(buffer, BUFFER_SIZE-1);
      buffer[BUFFER_SIZE] = '\0';

      int n;
      sscanf(buffer, "%d", &n);

      machine->WriteMem(addrNum, 4, n);


      delete buffer;
      break;
    }
    case SC_ThreadCreate:
    {
      // Recuperer les arguments
      int f = machine->ReadRegister(4);
      int arg = machine->ReadRegister(5);
      do_ThreadCreate(f, arg);
      break;
    }
    case SC_ThreadExit:
    {
      int nb;
      currentThread->space->nbThreadsMutex->P();
      nb = currentThread->space->getNbThreadsRunning();
      if(nb == 0 ){
        interrupt->Halt();
      }
      currentThread->space->nbThreadsMutex->V();
      do_ThreadExit();

      break;
    }
		default:
		{
        printf("Unimplemented system call %d\n", type);
        ASSERT(FALSE);
		}
		}
    #endif // CHANGED

		// Do not forget to increment the pc before returning!
		UpdatePC ();
		break;
	}

	case PageFaultException:
		if (!type) {
			printf("NULL dereference at PC %x!\n", machine->registers[PCReg]);
			ASSERT (FALSE);
		} else {
			printf ("Page Fault at address %x at PC %x\n", type, machine->registers[PCReg]);
			ASSERT (FALSE);	// For now
		}

	default:
		printf ("Unexpected user mode exception %d %d at PC %x\n", which, type, machine->registers[PCReg]);
		ASSERT (FALSE);
	}
}
