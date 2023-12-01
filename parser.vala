public Function[] freeFunctions;
public Function?   entryFunction;

public class Node {
        Token[] content;
        public void addToken(Token tok) {
                this.content += tok;
        }
}

public enum Type {
        INT8, INT16, INT32, INT64,
        UINT8, UINT16, UINT32, UINT64,
        FLOAT32, FLOAT64, FLOAT128,
        BOOL, CHAR, STR, VOID, 
}

public class Parameter : Node {
        string name;
        Type type;

        public void setName(string name) {
                this.name = name;
        }

        public string getName() {
                return this.name;
        }

        public void setType(Type type) {
                this.type = type;
        }
}

public class Function : Node {
        string name;
        string space;
        Type rtype;
        Parameter[] param;

        public Function(string space) {
                this.space = space;
        }

        public void add_param(Parameter param) {
                this.param += param;
        }

        public Parameter[] getParams() {
                return this.param;
        }

        public void setName(string name) {
                this.name = name;
        }

        public string getName() {
                return this.name;
        }

        public void setRType(Type type) {
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

Type? getType(TokenType typ) {
        switch (typ) {
        case TokenType.TYPE_INT8:
                return Type.INT8; 
        case TokenType.TYPE_INT16:
                return Type.INT16; 
        case TokenType.TYPE_INT32:
                return Type.INT32; 
        case TokenType.TYPE_INT64:
                return Type.INT64; 
        case TokenType.TYPE_UINT8:
                return Type.UINT8; 
        case TokenType.TYPE_UINT16:
                return Type.UINT16; 
        case TokenType.TYPE_UINT32:
                return Type.UINT32; 
        case TokenType.TYPE_UINT64:
                return Type.UINT64; 
        case TokenType.TYPE_F32:
                return Type.FLOAT32;
        case TokenType.TYPE_F64:
                return Type.FLOAT64;
        case TokenType.TYPE_F128:
                return Type.FLOAT128;
        case TokenType.TYPE_BOOL:
                return Type.BOOL;
        case TokenType.TYPE_CHAR:
                return Type.CHAR;
        case TokenType.TYPE_STR:
                return Type.STR;
        case TokenType.TYPE_VOID:
                return Type.VOID;
        default:
                return null;
        }
}

Parameter parseParam(Logger _log, Token[] toks, ref int i, Parameter[] param) {
        var tok = toks[i];
        if(tok.type != TokenType.IDENTIFIER && is_allowed_identifier(tok.text)) _log.TokenError(tok.info, "parameters can only be unique identifiers"); 
        foreach(var p in param) {
                if(p.getName() == tok.text) _log.TokenError(tok.info, "parameters can only be unique identifiers");
        }
        var p = new Parameter();
        p.setName(tok.text);
        p.addToken(tok);
        i++;
        tok = toks[i];
        if(tok.type != TokenType.SPECIAL_VAR_TYPE) _log.TokenError(tok.info, "parameters need to have a type");
        p.addToken(tok);
        i++;
        tok = toks[i];
        var type = getType(tok.type);
        if(type == null) _log.TokenError(tok.info, "error invalid type");
        if(type == Type.VOID) _log.TokenError(tok.info, "Parameter can not be type void");
        p.setType(type);
        p.addToken(tok);
        i++;
        return p;
}

void parseFunc(Logger _log, Token[] toks, ref int i, string space) {
        var tok = toks[i];
        var fn = new Function(space);
        i++;
        tok = toks[i];
        if(tok.type != TokenType.IDENTIFIER && is_allowed_identifier(tok.text)) _log.TokenError(tok.info, "function can only be a unique identifier");
        fn.setName(tok.text);
        fn.addToken(tok);
        i++;
        if(tok.type != TokenType.PARENTESIS_OPEN) _log.TokenError(tok.info, "open parentesis is needed after function name");
        fn.addToken(tok);
        i++;
        tok = toks[i];
        while(tok.type != TokenType.PARENTESIS_CLOSE) {
                fn.add_param(parseParam(_log, toks, ref i, fn.getParams()));
                tok = toks[i];
                if(tok.type == TokenType.PARENTESIS_CLOSE) break;
                if(tok.type != TokenType.SPECIAL_COMA) _log.TokenError(tok.info, "parameters must be separated by comas");
                fn.addToken(tok);
                i++;
        }
        fn.addToken(tok);
        i++;
        tok = toks[i];
        if(tok.type != TokenType.SPECIAL_RETURN_TYPE) _log.TokenError(tok.info, "function must have a return value");
        fn.addToken(tok);
        i++;
        tok = toks[i];
        var type = getType(tok.type)
        if(type == null) _log.TokenError(tok.info, "return type invalid");
        fn.setRType(type);
        fn.addToken(tok);

}

public void parse(Token[] toks) {
        var _log = new Logger("Parser");
        var i = 0;
        var tok = toks[0];
        while(tok.type != TokenType.EOC) {
                if(tok.type == TokenType.KW_FUNCTION) {
                        parseFunc(_log, toks, ref i, "");
                } else {
                        _log.TokenError(tok.info, "can not parse data");
                }
        }
}
