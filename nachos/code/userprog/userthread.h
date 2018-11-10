#ifdef CHANGED
#ifndef USERTHREAD_H
#define USERTHREAD_H

#include "thread.h"
#include "syscall.h"

struct ftion{
  int f;
  int arg;
};

extern  int do_ThreadCreate(int f, int arg);
static void StartUserThread(void *schmurtz);
extern void do_ThreadExit(void);

#endif // USERTHREAD_H
#endif // CHANGED
