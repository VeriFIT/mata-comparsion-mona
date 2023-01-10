#include <iostream>
#include <filesystem>
#include <vector>
extern "C" {
#include "DFA/dfa.h"
}
#include "mata2mona.h"


int main (int argc, char **argv) {
	if (argc<3) {
		std::cout << "mata2mona input output\n";
		exit(1);
	}
	DFA *aut=mona_input(argv[1]);
	dfaPrintVerbose(aut);
	char *vars[1];
	char orders[1];
	dfaExport(aut,argv[2],0, vars,orders);
}
