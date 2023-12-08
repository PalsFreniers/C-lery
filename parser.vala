public enum SyntaxType {
        NUMBER_LITTERAL,
        BINARY_OPERATOR,
}

public class SyntaxNode {
       public SyntaxType type; 
}

public class ExpressionNode : SyntaxNode {

}

public class NumberLitteralNode : ExpressionNode {
        public Token numberToken;

        public NumberLitteralNode(Token tok) {
                this.type = SyntaxType.NUMBER_LITTERAL;
                this.numberToken = tok;
        }
}

public class BinaryOperationNode : ExpressionNode {
        public Token operation;
        public ExpressionNode left;
        public ExpressionNode right;

        public BinaryOperationNode(ExpressionNode left, Token tok, ExpressionNode right) {
                this.type = SyntaxType.BINARY_OPERATOR;
                this.operation = tok;
                this.left = left;
                this.right = right;
        }
}

public class SyntaxTree {
        public ExpressionNode root;
        public Token EOC;

        public SyntaxTree(ExpressionNode root, Token endOfCode) {
                this.root = root;
                this.EOC = endOfCode;
        }
}

public class Parser {
        Token[] toks;
        Logger _log;
        int pos;

        public Parser(Token[] toks) {
                this.toks = toks;
                this.pos = 0;
                this._log = new Logger("Parser");
        }

        public Token peek(int offset = 1) {
                var index = this.pos + offset;
                if(index >= this.toks.length)
                        return this.toks[this.toks.length - 1];
                return this.toks[index];
        }

        public Token next() {
                var ret = this.toks[this.pos];
                this.pos++;
                return ret;
        } 

        public Token match(TokenType type) {
                if(peek(0).type == type)
                        return next();
                this._log.TokenError(peek(0).info, "Unexpected token");
        }

        public SyntaxTree parse() {
                var expr = parseRank1Expression();
                var eoc = match(TokenType.EOC);
                var tree = new SyntaxTree(expr, eoc);
                return tree;
        }

        public ExpressionNode parseRank1Expression() {
                var expr = parseRank2Expression();
                var current = peek(0);

                while(current.type == TokenType.OPERATOR_PLUS  ||
                      current.type == TokenType.OPERATOR_MINUS) {
                        var operator = next();
                        var right = parseRank2Expression();
                        expr = new BinaryOperationNode(expr, operator, right);
                        current = peek(0);
                }
                return expr;
        }

        public ExpressionNode parseRank2Expression() {
                var expr = parsePrimayExpression();
                var current = peek(0);

                while(current.type == TokenType.OPERATOR_MULT  ||
                      current.type == TokenType.OPERATOR_DIVIDE) {
                        var operator = next();
                        var right = parsePrimayExpression();
                        expr = new BinaryOperationNode(expr, operator, right);
                        current = peek(0);
                }
                return expr;
        }

        private ExpressionNode parsePrimayExpression() {
                var number = match(TokenType.LITTERAL_UINT);
                return new NumberLitteralNode(number);
        }
}
