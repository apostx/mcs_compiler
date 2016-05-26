%baseclass-preinclude "preinclude.h"
%lsp-needed

%token <text> IDENTIFIER
%token <text> NUMBER
%token <text> STRING

%token VAR
%token PRINT
%token WHILE
%token IF
%nonassoc ENDIF
%nonassoc ELSE

%token OPEN_BRACE
%token CLOSE_BRACE
%token OPEN_PARENTHESIS
%token CLOSE_PARENTHESIS
%token SEMICOLON
%token NOT

%right ASSIGN
%left OR
%left AND
%left EQUAL NOT_EQUAL
%left LESS GREATER LESS_EQUAL GREATER_EQUAL
%left ADD SUBSTRACT
%left MULTIPLIES DIVIDES MODULUS
%right MINUS PNOT

%union
{
	std::string *text;
	CommandDescriptor *command;
}

%type <command> instructions;
%type <command> instruction;
%type <command> block;
%type <command> expression;

%%

start:
	{
		//epsilon
	}
|
	instructions
	{
		out << CodeGenerator::generate(symbolTable, constantTable, &$1->code);

		delete $1;
	}
;

instructions:
	instruction
	{
		$$ = new CommandDescriptor(d_loc__.first_line, $1->code);

		delete $1;
	}
|
	instruction instructions
	{
		$$ = new CommandDescriptor(d_loc__.first_line, $1->code + $2->code);

		delete $1;
		delete $2;
	}
;

instruction:
	VAR IDENTIFIER SEMICOLON
	{
		manageDeclaration($2);

		$$ = new CommandDescriptor(d_loc__.first_line, "");

		delete $2;
	}
|
	VAR IDENTIFIER ASSIGN expression SEMICOLON
	{
		VariableDescriptor varDescriptor = manageDeclaration($2);

		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$4->code + CodeGenerator::assignment(varDescriptor)
		);

		delete $2;
		delete $4;
	}
|
	expression SEMICOLON
	{
		$$ = $1;
	}
|
	WHILE OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$3->code + CodeGenerator::while_(*$3, *$5)
		);

		delete $3;
		delete $5;
	}
|
	IF OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block %prec ENDIF
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$3->code + CodeGenerator::if_(*$3, *$5)
		);

		delete $3;
		delete $5;
	}
|
	IF OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block ELSE block
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$3->code + CodeGenerator::ifElse(*$3, *$5, *$7)
		);

		delete $3;
		delete $5;
		delete $7;
	}
|
	PRINT OPEN_PARENTHESIS expression CLOSE_PARENTHESIS SEMICOLON
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$3->code + CodeGenerator::printInt()
		);

		delete $3;
	}
|
	PRINT OPEN_PARENTHESIS STRING CLOSE_PARENTHESIS SEMICOLON
	{
		ConstantDescriptor strDescriptor = manageConstant($3, STR);

		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::moveAddressToEAX(strDescriptor) + CodeGenerator::printStr()
		);

		delete $3;
	}
;

block:
	OPEN_BRACE CLOSE_BRACE
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
	}
|
	instruction
	{
		$$ = $1;
	}
|
	OPEN_BRACE instructions CLOSE_BRACE
	{
		$$ = $2;
	}
;

expression:
	IDENTIFIER
	{
		VariableDescriptor variableDescriptor = manageVariable($1);

		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::moveVarToEAX(variableDescriptor)
		);

		delete $1;
	}
|
	NUMBER
	{
		ConstantDescriptor constantDescriptor = manageConstant($1, INT);

		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::moveVarToEAX(constantDescriptor )
		);

		delete $1;
	}
|
	IDENTIFIER ASSIGN expression
	{
		VariableDescriptor varDescriptor = manageVariable($1);

		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$3->code + CodeGenerator::assignment(varDescriptor)
		);

		delete $3;
	}
|
	SUBSTRACT %prec MINUS expression 
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::neg(*$2)
		);

		delete $2;
	}
|
	NOT %prec PNOT expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::not_(*$2)
		);

		delete $2;
	}
|
	OPEN_PARENTHESIS expression CLOSE_PARENTHESIS
	{
		$$ = $2;
	}
|
	expression ADD expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::add(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression SUBSTRACT expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::sub(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression MULTIPLIES expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::mul(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression DIVIDES expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::div(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression MODULUS expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::mod(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression EQUAL expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::equal(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression NOT_EQUAL expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::notEqual(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression LESS expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::less(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression GREATER expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::greater(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression LESS_EQUAL expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::lessEqual(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression GREATER_EQUAL expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			CodeGenerator::greaterEqual(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression AND expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$3->code + CodeGenerator::and_(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
|
	expression OR expression
	{
		$$ = new CommandDescriptor(
			d_loc__.first_line,
			$3->code + CodeGenerator::or_(*$1, *$3)
		);

		delete $1;
		delete $3;
	}
;
