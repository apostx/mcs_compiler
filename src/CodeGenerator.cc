#include "CodeGenerator.h"

const std::string CodeGenerator::STR_FORMAT_CONST_TITLE = "f_str";
const std::string CodeGenerator::INT_FORMAT_CONST_TITLE = "f_int";

int CodeGenerator::_jumpTitleCounter = 0;

std::string CodeGenerator::getCurrentJumpTitle() {
	std::ostringstream title;
        title << "t_" << CodeGenerator::_jumpTitleCounter ;
        return title.str();
}

std::string CodeGenerator::getNextJumpTitle() {
	++CodeGenerator::_jumpTitleCounter ;

	return CodeGenerator::getCurrentJumpTitle();
}

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
	
	code << "endl:\tdb\t`\\n`,0" << std::endl;
	code << CodeGenerator::STR_FORMAT_CONST_TITLE << ":\tdb\t`%s`,0" << std::endl;
	code << CodeGenerator::INT_FORMAT_CONST_TITLE << ":\tdb\t`%i`,0" << std::endl;

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

	code << "\tmov\teax, endl" << std::endl;
	code << CodeGenerator::printStr();

	code << "\tmov\tebx, 0" << std::endl;
	code << "\tmov\teax, 1" << std::endl;
	code << "\tint\t0x80" << std::endl;

	return code.str();
}

std::string CodeGenerator::assignment(VariableDescriptor const varDescriptor) {
	return "\tmov\t[" + varDescriptor.identifier + "], eax\n";
}

std::string CodeGenerator::moveVarToEAX(VariableDescriptor const varDescriptor) {
	return "\tmov\teax, [" + varDescriptor.identifier + "]\n";
}

std::string CodeGenerator::moveAddressToEAX(VariableDescriptor const varDescriptor) {
	return "\tmov\teax, " + varDescriptor.identifier + "\n";
}

std::string CodeGenerator::neg(CommandDescriptor exp) {
	std::ostringstream code;

	code << exp.code;
	code << "\tneg\teax" << std::endl;

	return code.str();
}

std::string CodeGenerator::not_(CommandDescriptor exp) {
	std::ostringstream code;

	code << exp.code;
	code << "\tmov\tedx, 0" << std::endl;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tsete\tal" << std::endl;
	code << "\tmovzx\teax, al" << std::endl;

	return code.str();
}

std::string CodeGenerator::add(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::ostringstream code;

	code << initExpression(exp1, exp2);
	code << "\tadd\teax, ebx" << std::endl;

	return code.str();
}

std::string CodeGenerator::sub(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::ostringstream code;

	code << initExpression(exp1, exp2);
	code << "\tsub\teax, ebx" << std::endl;

	return code.str();
}

std::string CodeGenerator::mul(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::ostringstream code;

	code << initExpression(exp1, exp2);
	code << "\timul\tebx" << std::endl;

	return code.str();
}

std::string CodeGenerator::div(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::ostringstream code;

	code << initExpression(exp1, exp2);
	code << "\tmov\tedx, 0" << std::endl;
	code << "\tidiv\tebx" << std::endl;

	return code.str();
}

std::string CodeGenerator::mod(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::ostringstream code;

	code << initExpression(exp1, exp2);
	code << "\tmov\tedx, 0" << std::endl;
	code << "\tidiv\tebx" << std::endl;
	code << "\tmov\teax, edx" << std::endl;
	return code.str();
}

std::string CodeGenerator::equal(CommandDescriptor exp1, CommandDescriptor exp2) {
	return CodeGenerator::compare(exp1, exp2, "sete");
}

std::string CodeGenerator::notEqual(CommandDescriptor exp1, CommandDescriptor exp2) {
	return CodeGenerator::compare(exp1, exp2, "setne");
}

std::string CodeGenerator::less(CommandDescriptor exp1, CommandDescriptor exp2) {
	return CodeGenerator::compare(exp1, exp2, "setl");
}

std::string CodeGenerator::lessEqual(CommandDescriptor exp1, CommandDescriptor exp2) {
	return CodeGenerator::compare(exp1, exp2, "setle");
}

std::string CodeGenerator::greater(CommandDescriptor exp1, CommandDescriptor exp2) {
	return CodeGenerator::compare(exp1, exp2, "setg");
}

std::string CodeGenerator::greaterEqual(CommandDescriptor exp1, CommandDescriptor exp2) {
	return CodeGenerator::compare(exp1, exp2, "setge");
}

std::string CodeGenerator::compare(CommandDescriptor exp1, CommandDescriptor exp2, std::string cmd) {
	std::ostringstream code;

	code << initExpression(exp1, exp2);
	code << "\tmov\tedx, 0" << std::endl;
	code << "\tcmp\teax, ebx" << std::endl;
	code << "\t" << cmd << "\tal" << std::endl;
	code << "\tmovzx\teax, al" << std::endl;

	return code.str();
}

std::string CodeGenerator::initExpression(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::ostringstream code;

	code << exp1.code;
	code << "\tpush\teax" << std::endl;
	code << exp2.code;
	code << "\tmov\tebx, eax" << std::endl;
	code << "\tpop\teax" << std::endl;

	return code.str();
}

std::string CodeGenerator::printInt() {
	return print(&CodeGenerator::INT_FORMAT_CONST_TITLE);
}

std::string CodeGenerator::printStr() {
	return print(&CodeGenerator::STR_FORMAT_CONST_TITLE);
}

std::string CodeGenerator::print(std::string const *formatConstTitle) {
	std::ostringstream code;

	code << "\tpush\tdword eax" << std::endl;
	code << "\tpush\tdword " << *formatConstTitle << std::endl;
	code << "\tcall\tprintf" << std::endl;
	code << "\tadd\tesp, 8" << std::endl;

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

std::string CodeGenerator::while_(CommandDescriptor condition, CommandDescriptor commands) {
	std::string startTitle = CodeGenerator::getNextJumpTitle();
	std::string endTitle = CodeGenerator::getNextJumpTitle();

	std::ostringstream code;

	code << startTitle << ":" << std::endl;
	code << condition.code;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tje near\t" << endTitle << std::endl;
	code << commands.code;
	code << "\tjmp\t" << startTitle << std::endl;
	code << endTitle << ":" << std::endl;

	return code.str();
}

std::string CodeGenerator::if_(CommandDescriptor condition, CommandDescriptor commands) {
	std::string endTitle = CodeGenerator::getNextJumpTitle();	

	std::ostringstream code;

	code << condition.code;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tje near\t" << endTitle << std::endl;
	code << commands.code;
	code << endTitle << ":" << std::endl;

	return code.str();
}

std::string CodeGenerator::ifElse(CommandDescriptor condition, CommandDescriptor ifCommands, CommandDescriptor elseCommands) {
	std::string elseTitle = CodeGenerator::getNextJumpTitle();
	std::string endTitle = CodeGenerator::getNextJumpTitle();

	std::ostringstream code;

	code << condition.code;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tje near\t" << elseTitle << std::endl;
	code << ifCommands.code;
	code << "\tjmp\t" << endTitle << std::endl;
	code << elseTitle << ":" << std::endl;
	code << elseCommands.code;
	code << endTitle << ":" << std::endl;

	return code.str();
}

std::string CodeGenerator::and_(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::string endTitle = CodeGenerator::getNextJumpTitle();

	std::ostringstream code;

	code << exp1.code;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tje near\t" << endTitle << std::endl;
	code << exp2.code;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tje near\t" << endTitle << std::endl;
	code << "\tmov\teax, 1" << std::endl;
	code << endTitle << ":" << std::endl;

	return code.str();
}

std::string CodeGenerator::or_(CommandDescriptor exp1, CommandDescriptor exp2) {
	std::string trueTitle = CodeGenerator::getNextJumpTitle();
	std::string endTitle = CodeGenerator::getNextJumpTitle();	

	std::ostringstream code;

	code << exp1.code;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tjne near\t" << trueTitle << std::endl;
	code << exp2.code;
	code << "\tcmp\teax, 0" << std::endl;
	code << "\tjne near\t" << trueTitle << std::endl;
	code << "\tjmp\t" << endTitle << std::endl;
	code << trueTitle << ":" << std::endl;
	code << "\tmov\teax, 1" << std::endl;
	code << endTitle << ":" << std::endl;

	return code.str();
}
