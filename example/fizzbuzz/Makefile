NAME=fizzbuzz
COMPILER=../../bin/mcsc

all: $(NAME)

$(NAME): $(NAME).mcs
	$(COMPILER) $(NAME).mcs 1> $(NAME).asm
	nasm -f elf $(NAME).asm
	gcc -o $(NAME) $(NAME).o

clean:
	rm -f $(NAME) $(NAME).o $(NAME).asm

run: $(NAME)
	./$(NAME)

