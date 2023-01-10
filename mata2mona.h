DFA *mona_input (std::filesystem::path filename);
int MonaDFA_check_empty(DFA *aut);
DFA *MonaDFA_product(std::vector<DFA*> operands, dfaProductType mode);
