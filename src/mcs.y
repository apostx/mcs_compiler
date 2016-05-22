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
		std::string code = "\n";

		out << CodeGenerator::generate(symbolTable, constantTable, &code);

		//delete $1;
	}
;

instructions:
	instruction
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
	}
|
	instruction instructions
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $2;
	}
;

instruction:
	VAR IDENTIFIER SEMICOLON
	{
		manageDeclaration($2);

		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $2;
	}
|
	VAR IDENTIFIER ASSIGN expression SEMICOLON
	{
		manageDeclaration($2);

		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $2;
		//delete $4;
	}
|
	expression SEMICOLON
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
	}
|
	WHILE OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $3;
		//delete $5;
	}
|
	IF OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block %prec ENDIF
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $3;
		//delete $5;
	}
|
	IF OPEN_PARENTHESIS expression CLOSE_PARENTHESIS block ELSE block
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $3;
		//delete $5;
		//delete $7;
	}
|
	PRINT OPEN_PARENTHESIS expression CLOSE_PARENTHESIS SEMICOLON
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $3;
	}
|
	PRINT OPEN_PARENTHESIS STRING CLOSE_PARENTHESIS SEMICOLON
	{
		ConstantDescriptor variable = manageConstant($3, STR);

		
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		

		//delete $3;
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
		VariableDescriptor variable = manageVariable($1);

		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
	}
|
	NUMBER
	{
		ConstantDescriptor variable = manageConstant($1, INT);

		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
	}
|
	IDENTIFIER ASSIGN expression
	{
		VariableDescriptor variable = manageVariable($1);

		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $3;
	}
|
	SUBSTRACT %prec MINUS expression 
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $2;
	}
|
	NOT %prec PNOT expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $2;
	}
|
	OPEN_PARENTHESIS expression CLOSE_PARENTHESIS
	{
		$$ = $2;
	}
|
	expression ADD expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression SUBSTRACT expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression MULTIPLIES expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression DIVIDES expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression MODULUS expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression EQUAL expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression NOT_EQUAL expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression LESS expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression GREATER expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression LESS_EQUAL expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression GREATER_EQUAL expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression AND expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
|
	expression OR expression
	{
		$$ = new CommandDescriptor(d_loc__.first_line, "");
		//delete $1;
		//delete $3;
	}
;
