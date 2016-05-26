%option noyywrap c++ yylineno

%{
#include "Parserbase.h"
%}

DIGIT		[0-9]
CHAR		[a-zA-Z_]
IDENTIFIER	{CHAR}({CHAR}|{DIGIT})*
WS		[ \t\n]

%%

var	return Parser::VAR;
print	return Parser::PRINT;
while	return Parser::WHILE;
if	return Parser::IF;
else	return Parser::ELSE;

"+"	return Parser::ADD;
"-"	return Parser::SUBSTRACT;
"*"	return Parser::MULTIPLIES;
"/"	return Parser::DIVIDES;
"%"	return Parser::MODULUS;
"="	return Parser::ASSIGN;
"!"	return Parser::NOT;
"!="	return Parser::NOT_EQUAL;
"=="	return Parser::EQUAL;
"<"	return Parser::LESS;
">"	return Parser::GREATER;
"<="	return Parser::LESS_EQUAL;
">="	return Parser::GREATER_EQUAL;
"&&"	return Parser::AND;
"||"	return Parser::OR;

"{"	return Parser::OPEN_BRACE;
"}"	return Parser::CLOSE_BRACE;
"("	return Parser::OPEN_PARENTHESIS;
")"	return Parser::CLOSE_PARENTHESIS;
";"	return Parser::SEMICOLON;

{IDENTIFIER}		return Parser::IDENTIFIER;
{DIGIT}|([1-9]{DIGIT}*)	return Parser::NUMBER;
\"(\\.|[^\\"])*\"	return Parser::STRING;

{WS}+	// whitespaces

[/]{2}[^\n]*[\n]	//comment

.|{DIGIT}+{IDENTIFIER}	{
				std::cerr << lineno() << ": Lexical error: Invalid token" << std::endl;
				exit(1);
			}

%%
