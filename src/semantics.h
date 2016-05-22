#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <string>

enum Type {
	INT,
	STR
};

struct CommandDescriptor {
	int line;
	std::string code;
	CommandDescriptor(int line, std::string code) : line(line), code(code) {}
};

struct VariableDescriptor {
	int line;
	std::string id_prefix;
	std::string identifier;

	VariableDescriptor() {}

	VariableDescriptor(int line, std::string id) {
		id_prefix = "v_";
		init(line, id);
	}

	void init(int line, std::string id) {
		this->line = line;
		identifier = id_prefix + id;
	}

};

struct ConstantDescriptor : VariableDescriptor  {
	Type type;
	std::string value;

	ConstantDescriptor() {}

	ConstantDescriptor(int line, std::string id, Type type, std::string value) {
		this->type = type;
		this->value = value;
		id_prefix = "c_";
		init(line, id);
	}
};

#endif //SEMANTICS_H
