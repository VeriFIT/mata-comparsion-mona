#include <iostream>
#include <fstream>
#include <filesystem>
#include <unordered_map>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>

extern "C" {
#include "DFA/dfa.h"
}
#include "mata2mona.h"

unsigned get_aut_num(std::string aut_string) {
    if (aut_string.compare(0, 3, "aut") == 0) {
        return std::stoul(aut_string.substr(3));
    } else {
        std::cerr << "Expecting autN, something else was found" << std::endl;
        exit(-1);
    }
}

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "ERROR: Program expects exactly one argument, try '--help' for help" << std::endl;
        return -1;
    }

    std::string arg = std::string(argv[1]);

    if (arg == "-h" || arg == "--help") {
        std::cout << "Usage: Cemptiness-checker input.emp" << std::endl;
        return 0;
    }

    std::filesystem::path path_to_input(arg);
    std::filesystem::path path_to_automata = std::filesystem::absolute(path_to_input).parent_path()/"gen_aut";

    std::ifstream input(path_to_input);
    if (!input.is_open()) {
        std::cerr << "ERROR: could not open file " << path_to_input << std::endl;
        return -1;
    }

    std::string line;
    std::unordered_map<unsigned, DFA*> num_to_aut;
    while(std::getline(input, line)) {
        line.erase(std::remove(line.begin(), line.end(),'('), line.end());
        line.erase(std::remove(line.begin(), line.end(), ')'), line.end());

        std::istringstream line_stream(line);
        std::string token;
        line_stream >> token;
        if (token == "load_automaton") {
            line_stream >> token;
            unsigned load_aut_num = get_aut_num(token);
            std::filesystem::path path_to_automaton = path_to_automata/(token + "_mona.mata");
            num_to_aut[load_aut_num] = mona_input(path_to_automaton);
        } else if (token == "is_empty") {
            line_stream >> token;
            unsigned res_aut_num = get_aut_num(token);
	    //dfaPrintVerbose(num_to_aut[res_aut_num]);
            if (MonaDFA_check_empty(num_to_aut[res_aut_num])) {
                std::cout << "EMPTY" << std::endl;
                return 0;
            } else {
                std::cout << "NOT EMPTY" << std::endl;
                return 0;
            }
        } else {
            unsigned res_aut_num = get_aut_num(token);
            line_stream >> token; //'='
            std::string operation;
            line_stream >> operation;

            std::vector<DFA*> operands;
            while (line_stream >> token) {
                operands.push_back(num_to_aut.at(get_aut_num(token)));
            }

            if (operands.size() == 0) {
                std::cerr << "No operand for some operation" << std::endl;
                return -1;
            }

            if (operation == "compl") {
                if (operands.size() != 1) {
                    std::cerr << "Complementing can be done with only one automaton" << std::endl;
                }
                // CHANGE THIS: get complement of mona automaton
		DFA *tmp=dfaCopy(operands[0]);
		dfaNegation(tmp);
                num_to_aut[res_aut_num] = tmp; 
            } else {
                if (operation == "union") {
                    num_to_aut[res_aut_num] = MonaDFA_product(operands,dfaOR);
                } else { //intersection
                    num_to_aut[res_aut_num] = MonaDFA_product(operands,dfaAND);
                }
            }
        }
    }
}
