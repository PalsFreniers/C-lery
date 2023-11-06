public enum TokenType {
        UNDEFINED,
        IDENTIFIER, KEYWORD,
        INT_LITTERAL, FLOAT_LITTERAL, BOOL_LITTERAL, CHAR_LITTERAL, STRING_LITTERAL,
        BRACKET_OPEN, BRACKET_CLOSE, PARENTESIS_OPEN, PARENTESIS_CLOSE, SQUARE_BRACKET_OPEN, SQUARE_BRACKET_CLOSE,
        OPERATOR, SPECIAL, EOC; 

        public string to_string() {
                switch (this) {
                        case UNDEFINED:
                                return "Undefined";
                        case IDENTIFIER:
                                return "Identifier";
                        case KEYWORD:
                                return "Keyword";
                        case INT_LITTERAL:
                                return "Int Litteral";
                        case FLOAT_LITTERAL:
                                return "Float Litteral";
                        case BOOL_LITTERAL:
                                return "Boolean Litteral";
                        case CHAR_LITTERAL:
                                return "Character Litteral";
                        case STRING_LITTERAL:
                                return "String Litteral";
                        case OPERATOR:
                                return "Operator";
                        case BRACKET_OPEN:
                                return "{";
                        case BRACKET_CLOSE:
                                return "}";
                        case PARENTESIS_OPEN:
                                return "(";
                        case PARENTESIS_CLOSE:
                                return ")";
                        case SQUARE_BRACKET_OPEN:
                                return "[";
                        case SQUARE_BRACKET_CLOSE:
                                return "]";
                        case SPECIAL:
                                return "Special Symbol";
                        case EOC:
                                return "End of code";
                }
                return "unreachable";
        }
}

public enum TokenSpec {
        NO_SPEC,
        INT_HEX, INT_BIN, INT_DEC;

        public string to_string() {
                switch (this) {
                        case NO_SPEC:
                                return "no specifications";
                        case INT_HEX:
                                return "Hexadecimal";
                        case INT_BIN:
                                return "Binary";
                        case INT_DEC:
                                return "Decimal";
                }
                return "unreachable";
        }
}

public struct TokenInfo {
        int    line;
        int    column;
        string file;

        public TokenInfo(int line, int column, string file) {
                this.line = line;
                this.column = column;
                this.file = file;
        }
        
        public string to_string() {
                var sb = new StringBuilder();
                sb.append("[\n");
                sb.append(@"\tLine:   $(this.line)\n");
                sb.append(@"\tColumn: $(this.column)\n");
                sb.append(@"\tFile:   $(this.file)\n");
                sb.append("]\n");
                return sb.str;
        }
}

public struct Token {
        public string    text;
        public TokenType type;
        public TokenInfo info;
        public TokenSpec specs;

        public Token(string text, TokenType type, TokenInfo info) {
                this.info = info;
                this.type = type;
                this.text = text;
                this.specs = TokenSpec.NO_SPEC;
        }

        public string to_string() {
                var sb = new StringBuilder();
                sb.append("[\n");
                sb.append(@"\tToken: \"$(this.text)\"\n");
                sb.append(@"\tType:  $(this.type)\n");
                sb.append(@"\tSpecs: $(this.specs)\n");
                sb.append(@"\tInfo:\n$(this.info)\n");
                sb.append("]\n");
                return sb.str;
        }
}

public const string KEYWORDS[] = {
        "namespace",
        "define",
        "use",
        "class",
        "struct",
        "enum",
        "union",
        "type",
        "inline",
        "fn",
        "method",
        "property",
        "ref",
        "new",
        "var",
        "const",
        "return",
        "defer",
        "static",
        "set",
        "get",
        "default",
        // control structures
        "if",
        "else",
        "elif",
        "switch",
        "case",
        "goto",
        "break",
        "continue",
        "while",
        "for",
        "do",
        // types
        "i8",
        "i16",
        "i32",
        "i64",
        "u8",
        "u16",
        "u32",
        "u64",
        "f32",
        "f64",
        "f128",
        "bool",
        "char",
        "str",
        "va_list",
        "void",
};
