# CS335-Project (Compiler Design)
### Instructor: Dr. Swarnendu Biswas
## JAVA to x86_64 Compilation Toolchain

Project was completed in 4 milestones:

- Milestone 1: Parser
- Milestone 2: Symbol Table, 3 Address Code
- Milestone 3: Runtime Support
- Milestone 4: x86_64 code gen

### Supported Features:

Thankfully, we managed to support all the basic features 

- Primitive data types
- Multidimensional arrays. 

- Arithmetic operators: +, -, *, /, %, ++, –
- Preincrement, predecrement, postincrement, and postdecrement
- Relational operators: ==, !=, >, <, >=, <=
- Bitwise operators: &, |, ˆ, ˜, ≪, ≫, ≫
- Logical operators: &&, ||, !
- Assignment operators: =, +=, -=, *=, /=, &=
- Ternary operator

- Control flow vila if-else, for, and while
- Methods and method calls, including both static and non-static methods
- Support for recursion
- Support the library function println() for only printing integer
- Support for classes and objects

Whoaaa! we got some optional features:

- Support for array initializer

### How to run:

- cd src
- make build (be patient, its not gcc)
- make run input=inputfile.java
- make runasm
- ./a.out

assembly, 3AC , symbol tables and ast tree will be generated in output folder

You can go through the readme of individual milestones in milestoneX/doc


### Contributors

- [Aarchie](https://github.com/aarchie-r) 
- [Harshit](https://github.com/tiwariharshit2725)
- [Me](https://github.com/uditpd3000) 

PS: Coding in 6 sems << Coding in this project
