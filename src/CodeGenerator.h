#ifndef __CODEGEN_H_
#define __CODEGEN_H_

#include <string>
#include <sstream>
#include <map>
#include "semantics.h"

class CodeGenerator {
	private:
		static const std::string STR_FORMAT_CONST_TITLE;
		static const std::string INT_FORMAT_CONST_TITLE;

		static int _jumpTitleCounter ;

		static std::string getCurrentJumpTitle();
		static std::string getNextJumpTitle();

	public:
		static std::string generate(std::map<std::string,VariableDescriptor> symbolTable, std::map<std::string,ConstantDescriptor> constantTable, std::string const *sourceCode);
		static std::string externs();
		static std::string definition(std::map<std::string,ConstantDescriptor> constantTable);
		static std::string declaration(std::map<std::string,VariableDescriptor> symbolTable);
		static std::string code(std::string const *sourceCode);
		static std::string assignment(VariableDescriptor const varDescriptor);
		static std::string moveVarToEAX(VariableDescriptor const varDescriptor);
		static std::string moveAddressToEAX(VariableDescriptor const varDescriptor);
		static std::string neg(CommandDescriptor exp);
		static std::string not_(CommandDescriptor exp);
		static std::string add(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string sub(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string mul(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string div(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string mod(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string equal(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string notEqual(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string less(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string lessEqual(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string greater(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string greaterEqual(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string compare(CommandDescriptor exp1, CommandDescriptor exp2, std::string cmd);
		static std::string initExpression(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string printInt();
		static std::string printStr();
		static std::string print(std::string const *formatConstTitle);
		static std::string convertStringToNASMStyle(std::string const *str);
		static std::string while_(CommandDescriptor condition, CommandDescriptor commands);
		static std::string if_(CommandDescriptor condition, CommandDescriptor commands);
		static std::string ifElse(CommandDescriptor condition, CommandDescriptor ifCommands, CommandDescriptor elseCommands);
		static std::string and_(CommandDescriptor exp1, CommandDescriptor exp2);
		static std::string or_(CommandDescriptor exp1, CommandDescriptor exp2);
};

#endif
