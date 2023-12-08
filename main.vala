// int run(string []av) {
//         SpawnFlags flags = 0;
//         string PWD = Environment.get_current_dir();
// 
//         flags = SEARCH_PATH | CHILD_INHERITS_STDIN;
//         try {
//                 int status;
//                 Process.spawn_sync(PWD, av, Environ.get(), flags, null, null, null, out status);
//                 return status;
//         } catch (Error e) {
//                 print("%s\n", e.message);
//         }
//         return 1;
// }

void main(string[] args) {
        if(args.length != 2) return;
        string content;
        size_t size;
        try {
                var file = args[1];
                var exist = FileUtils.get_contents(file, out content, out size);
                if(!exist) return;
                var noComm = removeComments(content);
                var tokenList = getTokensList(noComm, file);
                var a = new Parser(tokenList).parse();
                printNode(a.root);
                print("\n\n\n%d", evalNode(a.root));
//                 generateC(file);
//                 run({"nasm", "-felf64", "-o", file + ".o", file + ".S"});
//                 run({"ld", "-o", file.split(".lery")[0], file + ".o"});
        } catch (Error e) {
                print ("%s\n", e.message);
        }
}

int evalNode(ExpressionNode node) {
        switch (node.type) {
                case SyntaxType.NUMBER_LITTERAL:
                        var n = node as NumberLitteralNode;
                        return int.parse(n.numberToken.text);
                case SyntaxType.BINARY_OPERATOR:
                        var n = node as BinaryOperationNode;
                        var left = evalNode(n.left);
                        var right = evalNode(n.right);
                        switch (n.operation.type) {
                                case TokenType.OPERATOR_PLUS:
                                        return left + right;
                                case TokenType.OPERATOR_MINUS:
                                        return left - right;
                                case TokenType.OPERATOR_MULT:
                                        return left * right;
                                case TokenType.OPERATOR_DIVIDE:
                                        return left / right;
                                default:
                                        return 0;
                        }
                default:
                        return 0;
        }
}

void printNode(ExpressionNode node) {
        switch (node.type) {
                case SyntaxType.NUMBER_LITTERAL:
                        NumberLitteralNode n = node as NumberLitteralNode;
                        print("Number {\n");
                        print(@"$(n.numberToken)\n");
                        print("}\n");
                        return;
                case SyntaxType.BINARY_OPERATOR:
                        BinaryOperationNode n = node as BinaryOperationNode;
                        print("operation {\n");
                        print("left : {\n");
                        printNode(n.left);
                        print("}\n");
                        print(@"Operator = $(n.operation)\n");
                        print("right : {\n");
                        printNode(n.right);
                        print("}\n");
                        print("}\n");
                        return;
        }
}
