#include "CodeGenerator.h"

std::string CodeGenerator::generate(std::map<std::string,VariableDescriptor> symbolTable, std::map<std::string,ConstantDescriptor> constantTable, std::string const *sourceCode) {
	std::ostringstream code;

	code << CodeGenerator::externs() << std::endl;
	code << CodeGenerator::definition(constantTable) << std::endl;
	code << CodeGenerator::declaration(symbolTable) << std::endl;
	code << CodeGenerator::code(sourceCode) << std::endl;

	return code.str();
}

std::string CodeGenerator::externs() {
	return "\textern printf\n";
}

std::string CodeGenerator::definition(std::map<std::string,ConstantDescriptor> constantTable) {
	std::ostringstream code;

	code << "\tSECTION .data" << std::endl;

	for (std::map<std::string,ConstantDescriptor>::iterator it = constantTable.begin(); it != constantTable.end(); ++it) {
		code << it->second.identifier << ":\t";

		switch(it->second.type) {
			case INT:
				code << "dd\t" << it->second.value;
				break;
			case STR:
				code << "db\t" << CodeGenerator::convertStringToNASMStyle(&(it->second.value)) << ",0";
				break;
		}

		code << std::endl;
	}

	code << std::endl;

	return code.str();
}

std::string CodeGenerator::declaration(std::map<std::string,VariableDescriptor> symbolTable) {
	std::ostringstream code;

	code << "\tSECTION .bss" << std::endl;

	for (std::map<std::string,VariableDescriptor>::iterator it = symbolTable.begin(); it != symbolTable.end(); ++it) {
		code << it->second.identifier << ":\t resd 1" << std::endl;
	}

	code << std::endl;

	return code.str();
}

std::string CodeGenerator::code(std::string const *sourceCode) {
	std::ostringstream code;

	code << "\tSECTION .text" << std::endl;
	code << "\tglobal main" << std::endl;
	code << "main:" << std::endl;
	code << *sourceCode << std::endl;
	code << std::endl;

	return code.str();
}

std::string CodeGenerator::convertStringToNASMStyle(std::string const *str) {
	std::ostringstream sst;

	sst << '`';

	int length = str->size() - 1;
	bool isEscape = false;
	for (int i = 1; i < length ; i++) {
		switch(str->at(i)) {
			case '\\':
				isEscape = !isEscape;
				break;

			case '`':
				if (!isEscape)
					sst << '\\';	

			default:
				isEscape = false;
		}

		sst << str->at(i);
	}

	sst << '`';

	return sst.str();
}
