SRC=main.vala
NAME=brocoli

all: $(NAME)

$(NAME): $(SRC)
	valac $(SRC) -X -w -X -fsanitize=address -o $(NAME) 
