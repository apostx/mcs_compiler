SRC_NAME=mcs
DEST_NAME=mcsc

SRC_DIR=src/
DEST_DIR=bin/

all: $(DEST_DIR)$(DEST_NAME)
	-

$(DEST_DIR)$(DEST_NAME): $(SRC_DIR)$(SRC_NAME).cc $(SRC_DIR)lex.yy.cc $(SRC_DIR)parse.cc $(SRC_DIR)Parser.h $(SRC_DIR)Parser.ih $(SRC_DIR)CodeGenerator.cc
	g++ -o $(DEST_DIR)$(DEST_NAME) $(SRC_DIR)$(SRC_NAME).cc $(SRC_DIR)parse.cc $(SRC_DIR)lex.yy.cc $(SRC_DIR)CodeGenerator.cc

$(SRC_DIR)parse.cc: $(SRC_DIR)$(SRC_NAME).y
	bisonc++ --target-directory $(SRC_DIR) $(SRC_DIR)$(SRC_NAME).y

$(SRC_DIR)lex.yy.cc: $(SRC_DIR)$(SRC_NAME).l
	flex -o $(SRC_DIR)lex.yy.cc $(SRC_DIR)$(SRC_NAME).l

clean:
	rm -rf $(DEST_DIR)$(DEST_NAME) $(SRC_DIR)lex.yy.cc $(SRC_DIR)Parserbase.h $(SRC_DIR)parse.cc
