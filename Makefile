SRC_NAME=mcs
DEST_NAME=mcsc

SRC_DIR=src/
DEST_DIR=bin/

all: $(DEST_DIR)$(DEST_NAME)
	-

$(DEST_DIR)$(DEST_NAME): $(SRC_DIR)$(SRC_NAME).cc $(SRC_DIR)lex.yy.cc
	g++ -o $(DEST_DIR)$(DEST_NAME) $(SRC_DIR)$(SRC_NAME).cc $(SRC_DIR)lex.yy.cc

$(SRC_DIR)lex.yy.cc: $(SRC_DIR)$(SRC_NAME).l
	flex -o $(SRC_DIR)lex.yy.cc $(SRC_DIR)$(SRC_NAME).l

clean:
	rm -f $(DEST_DIR)$(DEST_NAME) $(SRC_DIR)lex.yy.cc
