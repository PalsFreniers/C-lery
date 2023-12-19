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
                print("\n\n\n%f", evalNode(a.root));
//                 generateC(file);
//                 run({"nasm", "-felf64", "-o", file + ".o", file + ".S"});
//                 run({"ld", "-o", file.split(".lery")[0], file + ".o"});
        } catch (Error e) {
                print ("%s\n", e.message);
        }
}

double evalNode(ExpressionNode node) {
        switch (node.type) {
                case SyntaxType.NUMBER_LITTERAL:
                        var n = node as NumberLitteralNode;
                        if(n.numberToken.type == TokenType.LITTERAL_UINT) {
                                if(n.numberToken.text.length > 2) {
                                        if(n.numberToken.text.has_prefix("0x")) return uint64.parse(n.numberToken.text[2:], 16);
                                        if(n.numberToken.text.has_prefix("0b")) return uint64.parse(n.numberToken.text[2:], 2);
                                }
                                return uint64.parse(n.numberToken.text);
                        }
                        else if(n.numberToken.type == TokenType.LITTERAL_FLOAT) return double.parse(n.numberToken.text);
                        else return 0;
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
                case SyntaxType.PARENTHESIZED_EXPRESSION:
                        var n = node as ParenthesisNode;
                        return evalNode(n.expr);
                default:
                        return 0;
        }
}

void printNode(ExpressionNode node, string tab = "") {
        switch (node.type) {
                case SyntaxType.NUMBER_LITTERAL:
                        var n = node as NumberLitteralNode;
                        print(@"$(tab)|___$(n.numberToken.text)\n");
                        return;
                case SyntaxType.BINARY_OPERATOR:
                        var n = node as BinaryOperationNode;
                        print(@"$(tab)|---$(n.operation.type)\n");
                        printNode(n.left, tab + "|   ");
                        printNode(n.right, tab + "|   ");
                        return;
                case SyntaxType.PARENTHESIZED_EXPRESSION:
                        var n = node as ParenthesisNode;
                        print(@"$(tab)|---$(n.openP.type)\n");
                        printNode(n.expr, tab + "|   ");
                        print(@"$(tab)|___$(n.closeP.type)\n");
                        return;
        }
}
