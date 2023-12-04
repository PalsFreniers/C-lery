public enum UniformLiteral {
        INT, STR, CHAR, BOOL, FLOAT, NONE,
}

public enum TokenType {
        UNDEFINED,
        IDENTIFIER,
        KW_NAMESPACE, KW_DEFINE, KW_USE, KW_CLASS, KW_STRUCT, KW_ENUM, KW_UNION, KW_TYPE, KW_INLINE, KW_FUNCTION, KW_METHOD,
        KW_LAMBDA, KW_PROPERTY, KW_REF, KW_NEW, KW_VAR, KW_CONST, KW_RETURN, KW_DEFER, KW_SELF, KW_SET, KW_GET, KW_DEFAULT,
        KW_IF, KW_ASM, KW_ELSE, KW_ELIF, KW_SWITCH, KW_CASE, KW_GOTO, KW_BREAK, KW_CONTINUE, KW_WHILE, KW_FOR, KW_DO, KW_POLYMORPH,
        TYPE_INT8, TYPE_INT16, TYPE_INT32, TYPE_INT64, TYPE_UINT8, TYPE_UINT16, TYPE_UINT32, TYPE_UINT64, TYPE_F32,
        TYPE_F64, TYPE_F128, TYPE_BOOL, TYPE_CHAR, TYPE_STR, TYPE_VA_LIST, TYPE_VOID,
        LITTERAL_UINT, LITTERAL_FLOAT, LITTERAL_BOOL, LITTERAL_CHAR, LITTERAL_STR,
        BRACKET_OPEN, BRACKET_CLOSE, PARENTESIS_OPEN, PARENTESIS_CLOSE, SQUARE_BRACKET_OPEN, SQUARE_BRACKET_CLOSE,
        CHEVRON_OPEN, CHEVRON_CLOSE,
        OPERATOR_DIVIDE, OPERATOR_DIVIDE_EQ, OPERATOR_MULT, OPERATOR_MULT_EQ, OPERATOR_PLUS, OPERATOR_PLUS_EQ, OPERATOR_INC,
        OPERATOR_MINUS, OPERATOR_MINUS_EQ, OPERATOR_DEC, OPERATOR_MOD, OPERATOR_MOD_EQ, OPERATOR_NOT, OPERATOR_AND,
        OPERATOR_BAND, OPERATOR_BAND_EQ, OPERATOR_BNOT, OPERATOR_BNOT_EQ, OPERATOR_OR, OPERATOR_BOR, OPERATOR_BOR_EQ,
        OPERATOR_XOR, OPERATOR_BXOR, OPERATOR_BXOR_EQ, OPERATOR_NOT_EQ,OPERATOR_EQU, OPERATOR_ASSIGN, OPERATOR_GEQU,
        OPERATOR_LEQU, OPRATOR_LESS, OPERATOR_SHL, OPERATOR_SHL_EQU, OPERATOR_GREATER, OPERATOR_SHR, OPERATOR_SHR_EQU,
        OPERATOR_ACCESS, OPERATOR_NAME_ACCESS, OPERATOR_CAST,
        SPECIAL_RETURN_TYPE, SPECIAL_STRING_CAT, SPECIAL_COMA, SPECIAL_SEMICOLON, SPECIAL_VAR_TYPE,
        EOC;

        public UniformLiteral getUniformLitteral() {
                switch (this) {
                case LITTERAL_FLOAT:
                        return UniformLiteral.FLOAT;
                case LITTERAL_UINT:
                        return UniformLiteral.INT;
                case LITTERAL_STR:
                        return UniformLiteral.STR;
                case LITTERAL_CHAR:
                        return UniformLiteral.CHAR;
                case LITTERAL_BOOL:
                        return UniformLiteral.BOOL;
                default:
                        return UniformLiteral.NONE;
                }
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
        public string?   text;
        public TokenType type;
        public TokenInfo info;

        public Token(TokenType type, TokenInfo info, string? text = null) {
                this.info = info;
                this.type = type;
                this.text = text;
        }

        public string to_string() {
                var sb = new StringBuilder();
                sb.append("[\n");
                if(this.text != null) sb.append(@"\tToken: \"$(this.text)\"\n");
//                 sb.append(@"\tType:  $(this.type)\n");
                sb.append(@"\tInfo:\n$(this.info)\n");
                sb.append("]\n");
                return sb.str;
        }
}

