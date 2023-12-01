public Function[] freeFunctions;
public Function?   entryFunction;

public class Node {
        Token[] content;
        public void addToken(Token tok) {
                this.content += tok;
        }
}

public class Parameter : Node {
        string name;
        string type;
}

public class Function : Node {
        string name;
        string space;
        string rtype;
        Parameter[] param;

        public Function(string space) {
                this.space = space;
        }
        
        public void add_param(Parameter param) {
                this.param += param;
        }

        public void setName(string name) {
                this.name = name;
        }

        public string getName() {
                return this.name;
        }

        public void setRType(string type) {
                this.rtype = type;
        }
}

public bool is_allowed_identifier(string str) {
        if(str == "entry" && entryFunction != null) return false;
        foreach(var func in freeFunctions) {
                if(str == func.getName()) return false;
        }
        return true;
}

public void parse(Token[] toks) {
        var _log = new Logger("Parser");
        var i = 0;
        var current_space = "";
        var tok = toks[0];
        while(tok.type != TokenType.EOC) {
                if(tok.type == TokenType.KW_FUNCTION) {
                        var fn = new Function(current_space);
                        fn.addToken(tok);
                        i++;
                        tok = toks[i];
                        if(tok.type != TokenType.IDENTIFIER) _log.TokenError(tok.info, "function name should be an idenifier");
                        if(!is_allowed_identifier(tok.text)) _log.TokenError(tok.info, "name %s is already used", tok.text);
                        fn.setName(tok.text);
                        fn.addToken(tok);
                        i++;
                        tok = toks[i];
                        if(tok.type != TokenType.PARENTESIS_OPEN) _log.TokenError(tok.info, "parentesis are needed after function name");
                        fn.addToken(tok);
                        i++;
                        tok = toks[i];
                        if(tok.type != TokenType.PARENTESIS_CLOSE) _log.TokenError(tok.info, "WIP pramameters are nto allowed");
                        fn.addToken(tok);
                        i++;
                        tok = toks[i];

                }
        }
}
