%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
%}


DIGIT		[0-9]
CHAR		[a-zA-Z_]
IDENTIFIER	{CHAR}({CHAR}|{DIGIT})*
WS			[ \t\n]

%%

var		std::cout << yytext << std::endl;
print	std::cout << yytext << std::endl;
while	std::cout << yytext << std::endl;
if		std::cout << yytext << std::endl;
else	std::cout << yytext << std::endl;

"+"		std::cout << yytext << std::endl;
"-"		std::cout << yytext << std::endl;
"*"		std::cout << yytext << std::endl;
"/"		std::cout << yytext << std::endl;
"%"		std::cout << yytext << std::endl;
"="		std::cout << yytext << std::endl;
"!"		std::cout << yytext << std::endl;
"!="	std::cout << yytext << std::endl;
"=="	std::cout << yytext << std::endl;
"<"		std::cout << yytext << std::endl;
">"		std::cout << yytext << std::endl;
"<="	std::cout << yytext << std::endl;
">="	std::cout << yytext << std::endl;
"&&"	std::cout << yytext << std::endl;
"||"	std::cout << yytext << std::endl;

"{"		std::cout << yytext << std::endl;
"}"		std::cout << yytext << std::endl;
"("		std::cout << yytext << std::endl;
")"		std::cout << yytext << std::endl;
";"		std::cout << yytext << std::endl;

{IDENTIFIER}			std::cout << "IDENTIFIER: " << yytext << std::endl;
{DIGIT}+(\.{DIGIT}+)?	std::cout << "NUMBER: " << yytext << std::endl;
["]([^"]*)["]			std::cout << "STRING: " << yytext << std::endl;

{WS}+	// whitespaces

[/]{2}[^\n]*[\n]	//comment

.|{DIGIT}+{IDENTIFIER}	{
							std::cerr << lineno() << ": Lexical error: Invalid token" << std::endl;
							exit(1);
						}

%%
