#include <iostream>
#include <fstream>
#include <string>
#include <FlexLexer.h>
#include <cstdlib>

using namespace std;

void input_handler(ifstream& in, int argc, char* argv[]);

int main(int argc, char* argv[]) {
	ifstream in;
	input_handler(in, argc, argv);
	yyFlexLexer fl(&in, &cout);
	fl.yylex();
	return 0;
}

void input_handler(ifstream& in, int argc, char* argv[]) {
	if (argc < 2) {
		cerr << "Missing parameter: Source file path." << endl;
		exit(1);
	}

	in.open(argv[1]);

	if (!in) {
		cerr << "Opening file failed: " << argv[1] << endl;
		exit(1);
	}
}
