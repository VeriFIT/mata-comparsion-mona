CC=gcc
CPP=g++
CFLAGS=-m32 
CPPFLAGS=-std=c++17

BDDOBJ=BDD/bdd_cache.o  BDD/bdd_double.o  BDD/bdd_dump.o  BDD/bdd_external.o  BDD/bdd_manager.o  BDD/bdd.o  BDD/bdd_trace.o  BDD/hash.o

DFAOBJ=DFA/analyze.o  DFA/basic.o  DFA/dfa.o  DFA/external.o  DFA/makebasic.o  DFA/minimize.o  DFA/prefix.o  DFA/printdfa.o  DFA/product.o  DFA/project.o  DFA/quotient.o

MemOBJ=Mem/dlmalloc.o  Mem/mem.o

BDD/%.o: BDD/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

DFA/%.o: DFA/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

Mem/%.o: Mem/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

main: mata2mona.o main.o $(BDDOBJ) $(DFAOBJ) $(MemOBJ)
	$(CPP)  $(CFLAGS) $(CPPFLAGS) -o main mata2mona.o main.o $(BDDOBJ) $(DFAOBJ) $(MemOBJ)

main.o: main.cc 
	$(CPP)  $(CFLAGS) $(CPPFLAGS) -c main.cc

m2m: m2m.cc mata2mona.o $(BDDOBJ) $(DFAOBJ) $(MemOBJ)
	$(CPP)  $(CFLAGS) $(CPPFLAGS) -c m2m.cc
	$(CPP)  $(CFLAGS) $(CPPFLAGS) -o m2m mata2mona.o m2m.o $(BDDOBJ) $(DFAOBJ) $(MemOBJ)

mata2mona.o: mata2mona.cc
	$(CPP) $(CFLAGS) $(CPPFLAGS) -c -o mata2mona.o mata2mona.cc

clean:
	rm $(BDDOBJ) $(DFAOBJ) $(MemOBJ) mata2mona.o main m2m
