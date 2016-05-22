#ifndef __CODEGEN_H_
#define __CODEGEN_H_

#include <string>
#include <sstream>
#include <map>
#include "semantics.h"

class CodeGenerator {
	public:
		static std::string generate(std::map<std::string,VariableDescriptor> symbolTable, std::map<std::string,ConstantDescriptor> constantTable, std::string const *sourceCode);
		static std::string externs();
		static std::string definition(std::map<std::string,ConstantDescriptor> constantTable);
		static std::string declaration(std::map<std::string,VariableDescriptor> symbolTable);
		static std::string code(std::string const *sourceCode);
		static std::string convertStringToNASMStyle(std::string const *str);
};

#endif
