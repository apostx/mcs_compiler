#[M]inimal[C]ustom[S]cript compiler
Just for fun!

## Steps:
1. Lexical analysis (Missing)
2. Syntax analysis (Missing)
3. Semantic analysis (Missing)
4. Code generation (Missing)

## Development and testing environment:
* Debian 4.9.2-10
* gcc 4.9.2
* flex 2.5.39
* bisonc++ 4.09.02
* NASM 2.11.05

## Reference:
### Types:
##### Number:

```
15.75
```
  
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

### Operator precedence:

Operators are listed top to bottom, in descending precedence.

| Precedence  | Operator            | Description | Associativity |
| :---------: | :-----------------: | ------------- | :-------------: |
| 1 | ! ... <BR> - ... | Logical NOT <BR> Unary Negation | right-to-left <BR> right-to-left |
| 2 | ... * ... <BR> ... / ... <BR> ... % ... | Multiplication <BR> Division <BR> Remainder | left-to-right |
| 3 | ... + ... <BR> ... - ... | Addition <BR> Subtraction | left-to-right |
| 4 | ... < ... <BR> ... > ... <BR> ... <= ... <BR> ... >= ... | Less Than <BR> Greater Than <BR> Less Than Or Equal <BR> Greater Than Or Equal | left-to-right |
| 5 | ... == ... <BR> ... != ... | Equality <BR> Inequality | left-to-right |
| 6 | ... && ... | Logical AND | left-to-right |
| 7 | ... \|\| ... | Logical OR | left-to-right |
| 8 | ... = ... | Assignment | right-to-left |
