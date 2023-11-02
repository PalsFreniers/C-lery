SRC=main.vala
NAME=brocoly

all: $(NAME)

$(NAME): $(SRC)
	valac $(SRC) -X -w -X -fsanitize=address -o $(NAME) 
