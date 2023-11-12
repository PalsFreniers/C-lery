public Node[] program;

public enum NodeTypes {
        FUNCTION,
}

public class Node {
        public TokenInfo start;
        public NodeTypes type;

        public Node(NodeTypes type, TokenInfo start) {
                this.type = type;
                this.start = start;
        }
}

public void parse(Token[] toks) {
        var _log = new Logger("Parser");
        var i = 0;
        var tok = toks[0];
        while(tok != TokenType.EOC) {
                
        }
}
