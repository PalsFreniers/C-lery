public enum SyntaxType {
        NUMBER_LITTERAL,
        BINARY_OPERATOR,
        PARENTHESIZED_EXPRESSION,
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

public class ParenthesisNode : ExpressionNode {
        public Token openP;
        public ExpressionNode expr;
        public Token closeP;
        public ParenthesisNode(Token openParenthesis, ExpressionNode expr, Token closeParenthesis) {
                this.type = SyntaxType.PARENTHESIZED_EXPRESSION;
                this.openP = openParenthesis;
                this.expr = expr;
                this.closeP = closeParenthesis;
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

        public Token? match(TokenType type) {
                if(peek(0).type == type)
                        return next();
                return null;
        }

        public SyntaxTree parse() {
                var expr = parseRank1Expression();
                var eoc = match(TokenType.EOC);
                if(eoc == null) _log.TokenError(peek(0).info, @"Unexpected token $(peek(0).type)");
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
                        var right = parseRank3Expression();
                        expr = new BinaryOperationNode(expr, operator, right);
                        current = peek(0);
                }
                return expr;
        }

        public ExpressionNode parseRank3Expression() {
                ExpressionNode expr;
                var current = peek(0);

                switch (current.type) {
                        case TokenType.PARENTESIS_OPEN:
                                var openP = next();
                                expr = parseRank1Expression();
                                var closeP = next();
                                if(closeP.type != TokenType.PARENTESIS_CLOSE) _log.TokenError(closeP.info, @"expected Closed parenthesis but got $(closeP.type)");
                                expr = new ParenthesisNode(openP, expr, closeP);
                                break;
                        case TokenType.LITTERAL_FLOAT:
                        case TokenType.LITTERAL_UINT:
                                expr = parsePrimayExpression();
                                break;
                        default:
                                _log.TokenError(current.info, "Bad Token");
                }
                return expr;
        }

        private ExpressionNode parsePrimayExpression() {
                var number = match(TokenType.LITTERAL_UINT);
                if(number == null) number = match(TokenType.LITTERAL_FLOAT);
                if(number == null) this._log.TokenError(peek(0).info, @"Unexpected TokenType $(peek(0))");
                return new NumberLitteralNode(number);
        }
}
