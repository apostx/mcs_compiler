%lsp-needed

%token <text> IDENTIFIER
%token NUMBER
%token STRING

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
}

%%

start:
	{
		//epsilon
	}
|
	instructions
	{
		out << "start -> instructions" << std::endl;
	}
;

instructions:
	instruction
	{
		out << "instructions -> instruction" << std::endl;
	}
|
	instruction instructions
	{
		out << "instructions -> instruction instructions" << std::endl;
	}
;

instruction:
	VAR IDENTIFIER SEMICOLON
	{
		out << "instruction -> var IDENTIFIER; //IDENTIFIER: " << *$2 << std::endl;

		manageDeclaration($2);
	}
|
	VAR IDENTIFIER ASSIGN expression SEMICOLON
	{
		out << "instruction -> var IDENTIFIER = expression; //IDENTIFIER: " << *$2 << std::endl;

		manageDeclaration($2);
	}
|
	expression SEMICOLON
	{
		out << "instruction -> expression;" << std::endl;
	}
|
	WHILE OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block
	{
		out << "instruction -> while( expression ) block" << std::endl;
	}
|
	IF OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block %prec ENDIF
	{
		out << "instruction -> if( expression ) block" << std::endl;
	}
|
	IF OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block ELSE block
	{
		out << "instruction -> if( expression ) block ELSE block" << std::endl;
	}
|
	PRINT OPEN_PARENTHESIS expression CLOSE_PARENTHESIS SEMICOLON
	{
		out << "instruction -> print( expression );" << std::endl;
	}
|
	PRINT OPEN_PARENTHESIS STRING CLOSE_PARENTHESIS SEMICOLON
	{
		out << "instruction -> print( STRING );" << std::endl;
	}
;

block:
	OPEN_BRACE CLOSE_BRACE
	{
		out << "block -> {}" << std::endl;
	}
|
	instruction
	{
		out << "block -> instruction" << std::endl;
	}
|
	OPEN_BRACE instructions CLOSE_BRACE
	{
		out << "block -> { instructions }" << std::endl;
	}
;

expression:
	IDENTIFIER
	{
		out << "expression -> IDENTIFIER" << std::endl;

		checkVariableExists($1);
	}
|
	NUMBER
	{
		out << "expression -> NUMBER" << std::endl;
	}
|
	IDENTIFIER ASSIGN expression
	{
		out << "instruction -> IDENTIFIER = expression; //IDENTIFIER: " << *$1 << std::endl;

		checkVariableExists($1);
	}
|
	SUBSTRACT %prec MINUS expression 
	{
		out << "expression -> -expression" << std::endl;
	}
|
	NOT %prec PNOT expression
	{
		out << "expression -> !expression" << std::endl;
	}
|
	OPEN_PARENTHESIS expression CLOSE_PARENTHESIS
	{
		out << "expression -> ( expression )" << std::endl;
	}
|
	expression ADD expression
	{
		out << "expression -> expression + expression" << std::endl;
	}
|
	expression SUBSTRACT expression
	{
		out << "expression -> expression - expression" << std::endl;
	}
|
	expression MULTIPLIES expression
	{
		out << "expression -> expression * expression" << std::endl;
	}
|
	expression DIVIDES expression
	{
		out << "expression -> expression / expression" << std::endl;
	}
|
	expression MODULUS expression
	{
		out << "expression -> expression % expression" << std::endl;
	}
|
	expression EQUAL expression
	{
		out << "expression -> expression == expression" << std::endl;
	}
|
	expression NOT_EQUAL expression
	{
		out << "expression -> expression != expression" << std::endl;
	}
|
	expression LESS expression
	{
		out << "expression -> expression < expression" << std::endl;
	}
|
	expression GREATER expression
	{
		out << "expression -> expression > expression" << std::endl;
	}
|
	expression LESS_EQUAL expression
	{
		out << "expression -> expression <= expression" << std::endl;
	}
|
	expression GREATER_EQUAL expression
	{
		out << "expression -> expression >= expression" << std::endl;
	}
|
	expression AND expression
	{
		out << "expression -> expression && expression" << std::endl;
	}
|
	expression OR expression
	{
		out << "expression -> expression || expression" << std::endl;
	}
;
