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
        "lambda",
        "property",
        "ref",
        "new",
        "var",
        "const",
        "return",
        "defer",
        "self",
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

public enum TokenType {
        UNDEFINED,
        IDENTIFIER,
        KW_NAMESPACE, KW_DEFINE, KW_USE, KW_CLASS, KW_STRUCT, KW_ENUM, KW_UNION, KW_TYPE, KW_INLINE, KW_FUNCTION, KW_METHOD,
        KW_LAMBDA, KW_PROPERTY, KW_REF, KW_NEW, KW_VAR, KW_CONST, KW_RETURN, KW_DEFER, KW_SELF, KW_SET, KW_GET, KW_DEFAULT,
        KW_IF, KW_ELSE, KW_ELIF, KW_SWITCH, KW_CASE, KW_GOTO, KW_BREAK, KW_CONTINUE, KW_WHILE, KW_FOR, KW_DO,
        TYPE_INT8, TYPE_INT16, TYPE_INT32, TYPE_INT64, TYPE_UINT8, TYPE_UINT16, TYPE_UINT32, TYPE_UINT64, TYPE_F32,
        TYPE_F64, TYPE_F128, TYPE_BOOL, TYPE_CHAR, TYPE_STR, TYPE_VA_LIST, TYPE_VOID,
        LITTERAL_INT8, LITTERAL_INT16, LITTERAL_INT32, LITTERAL_INT64, LITTERAL_UINT8, LITTERAL_UINT16, LITTERAL_UINT32, LITTERAL_UINT64,
        LITTERAL_F32, LITTERAL_F64, LITTERAL_F128, LITTERAL_BOOL, LITTERAL_CHAR, LITTERAL_STR,
        BRACKET_OPEN, BRACKET_CLOSE, PARENTESIS_OPEN, PARENTESIS_CLOSE, SQUARE_BRACKET_OPEN, SQUARE_BRACKET_CLOSE,
        OPERATOR_DIVIDE, OPERATOR_DIVIDE_EQ, OPERATOR_MULT, OPERATOR_MULT_EQ, OPERATOR_PLUS, OPERATOR_PLUS_EQ, OPERATOR_INC,
        OPERATOR_MINUS, OPERATOR_MINUS_EQ, OPERATOR_DEC, OPERATOR_MOD, OPERATOR_MOD_EQ, OPERATOR_NOT, OPERATOR_NOT_EQ, OPERATOR_EQU,
        OPERATOR_ASSIGN, OPERATOR_GEQU, OPERATOR_LEQU, OPRATOR_LESS, OPERATOR_SHL, OPERATOR_SHL_EQU, OPERATOR_GREATER, OPERATOR_SHR,
        OPERATOR_SHR_EQU, OPERATOR_ACCESS, OPERATOR_NAME_ACCESS,
        SPECIAL_RETURN_TYPE, SPECIAL_STRING_CAT, SPECIAL_COMA, SPECIAL_SEMICOLON, 
        EOC,
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

        public Token(string text, TokenType type, TokenInfo info) {
                this.info = info;
                this.type = type;
                this.text = text;
        }

        public string to_string() {
                var sb = new StringBuilder();
                sb.append("[\n");
                sb.append(@"\tToken: \"$(this.text)\"\n");
//                 sb.append(@"\tType:  $(this.type)\n");
                sb.append(@"\tInfo:\n$(this.info)\n");
                sb.append("]\n");
                return sb.str;
        }
}

