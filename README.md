#[M]inimal [C]ustom [S]cript compiler
Just for fun!

## Steps:
1. [Lexical analysis](../../releases/tag/v0.1)
2. [Syntax analysis](../../releases/tag/v0.2) ([diff](../../compare/v0.1...v0.2))
3. [Semantic analysis](../../releases/tag/v0.3) ([diff](../../compare/v0.2...v0.3))
4. Code generation (Missing)

## Development and testing environment:
* Debian 4.9.2-10
* gcc 4.9.2
* flex 2.5.39
* bisonc++ 4.09.02
* NASM 2.11.05

## Reference:
### Types:
##### Integer

Example: 1987

### Declaration:

```
var varname [= value1 ... [= valueN]];
```

### Loops:
##### while:

```
while( condition ) {
    ...
}
```

### Conditional statements:
##### if...else statement:

```
if( condition ) {
    ...
} else {
    ...
}
```

### Functions:
##### print:

```
void print(string);

void print(integer);
```

Variables can not contain string type. <br />
The language can not support string operations. <br />
Text of a string has to be between double quotes. <br />
String can contain escaped characters. <br />
Example: "Hello World!\n"

### Operator precedence:

Operators are listed top to bottom, in descending precedence.

| Precedence  | Operator            | Description | Associativity |
| :---------: | :-----------------: | ------------- | :-------------: |
| 1 | ! ... <BR> - ... | Logical NOT <BR> Unary Negation | right-to-left |
| 2 | ... * ... <BR> ... / ... <BR> ... % ... | Multiplication <BR> Division <BR> Remainder | left-to-right |
| 3 | ... + ... <BR> ... - ... | Addition <BR> Subtraction | left-to-right |
| 4 | ... < ... <BR> ... > ... <BR> ... <= ... <BR> ... >= ... | Less Than <BR> Greater Than <BR> Less Than Or Equal <BR> Greater Than Or Equal | left-to-right |
| 5 | ... == ... <BR> ... != ... | Equality <BR> Inequality | left-to-right |
| 6 | ... && ... | Logical AND | left-to-right |
| 7 | ... \|\| ... | Logical OR | left-to-right |
| 8 | ... = ... | Assignment | right-to-left |
