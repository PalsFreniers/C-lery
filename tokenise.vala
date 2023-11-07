public TokenType getNumberLitteralType(string number) {

}

public Token[] getTokensList(string code, string filename) {
        var _log = new Logger("Tokenizer");
        Token[] ret = {};
        var column = 1;
        var line = 1;
        var i = 0;
        var c = code[i];
        while (c != '\0') {
                c = code[i];
                if(c == '\n') {
                        line++;
                        column = 0;
                        i++;
                        continue;
                }
                if(c.isalpha() || c == '_') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        tokText.append_c(c);
                        c = code[i];
                        while(c.isalnum() || c == '_') {
                                tokText.append_c(c);
                                i++;
                                column++;
                                c = code[i];
                        }
                        string? text = tokText.str;
                        var type = TokenType.IDENTIFIER;
                        switch(text) {
                                case "namespace":
                                        type = TokenType.KW_NAMESPACE;
                                        break;
                                case "define":
                                        type = TokenType.KW_DEFINE;
                                        break;
                                case "use":
                                        type = TokenType.KW_USE;
                                        break;
                                case "class":
                                        type = TokenType.KW_CLASS;
                                        break;
                                case "struct":
                                        type = TokenType.KW_STRUCT;
                                        break;
                                case "enum":
                                        type = TokenType.KW_ENUM;
                                        break;
                                case "union":
                                        type = TokenType.KW_UNION;
                                        break;
                                case "type":
                                        type = TokenType.KW_TYPE;
                                        break;
                                case "inline":
                                        type = TokenType.KW_INLINE;
                                        break;
                                case "fn":
                                        type = TokenType.KW_FUNCTION;
                                        break;
                                case "method":
                                        type = TokenType.KW_METHOD;
                                        break;
                                case "lambda":
                                        type = TokenType.KW_LAMBDA;
                                        break;
                                case "property":
                                        type = TokenType.KW_PROPERTY;
                                        break;
                                case "ref":
                                        type = TokenType.KW_REF;
                                        break;
                                case "new":
                                        type = TokenType.KW_NEW;
                                        break;
                                case "var":
                                        type = TokenType.KW_VAR;
                                        break;
                                case "const":
                                        type = TokenType.KW_CONST;
                                        break;
                                case "return":
                                        type = TokenType.KW_RETURN;
                                        break;
                                case "defer":
                                        type = TokenType.KW_DEFER;
                                        break;
                                case "self":
                                        type = TokenType.KW_SELF;
                                        break;
                                case "set":
                                        type = TokenType.KW_SET;
                                        break;
                                case "get":
                                        type = TokenType.KW_GET;
                                        break;
                                case "default":
                                        type = TokenType.KW_DEFAULT;
                                        break;
                                case "if":
                                        type = TokenType.KW_IF;
                                        break;
                                case "else":
                                        type = TokenType.KW_ELSE;
                                        break;
                                case "elif":
                                        type = TokenType.KW_ELIF;
                                        break;
                                case "switch":
                                        type = TokenType.KW_SWITCH;
                                        break;
                                case "case":
                                        type = TokenType.KW_CASE;
                                        break;
                                case "goto":
                                        type = TokenType.KW_GOTO;
                                        break;
                                case "break":
                                        type = TokenType.KW_BREAK;
                                        break;
                                case "continue":
                                        type = TokenType.KW_CONTINUE;
                                        break;
                                case "while":
                                        type = TokenType.KW_WHILE;
                                        break;
                                case "for":
                                        type = TokenType.KW_FOR;
                                        break;
                                case "do":
                                        type = TokenType.KW_DO;
                                        break;
                                case "i8":
                                        type = TokenType.TYPE_INT8;
                                        break;
                                case "i16":
                                        type = TokenType.TYPE_INT16;
                                        break;
                                case "i32":
                                        type = TokenType.TYPE_INT32;
                                        break;
                                case "i64":
                                        type = TokenType.TYPE_INT64;
                                        break;
                                case "u8":
                                        type = TokenType.TYPE_UINT8;
                                        break;
                                case "u16":
                                        type = TokenType.TYPE_UINT16;
                                        break;
                                case "u32":
                                        type = TokenType.TYPE_UINT32;
                                        break;
                                case "u64":
                                        type = TokenType.TYPE_UINT64;
                                        break;
                                case "f32":
                                        type = TokenType.TYPE_F32;
                                        break;
                                case "f64":
                                        type = TokenType.TYPE_F64;
                                        break;
                                case "f128":
                                        type = TokenType.TYPE_F128;
                                        break;
                                case "bool":
                                        type = TokenType.TYPE_BOOL;
                                        break;
                                case "char":
                                        type = TokenType.TYPE_CHAR;
                                        break;
                                case "str":
                                        type = TokenType.TYPE_STR;
                                        break;
                                case "va_list":
                                        type = TokenType.TYPE_VA_LIST;
                                        break;
                                case "void":
                                        type = TokenType.TYPE_VOID;
                                        break;
                        }
                        if(type != TokenType.IDENTIFIER) text = null;
                        ret += Token(type, info, text);
                        continue;
                }
                if(c.isdigit()) {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        Token tok;
                        if(c == '0' && code[i] == 'x') {
                                tokText.append("0x");
                                i++;
                                column++;
                                c = code[i];
                                while(c.isxdigit() || c == '_') {
                                        if(c != '_') tokText.append_c(c);
                                        i++;
                                        column++;
                                        c = code[i];
                                }
                        } else if(c == '0' && code[i] == 'b') {
                                tokText.append("0b");
                                i++;
                                column++;
                                c = code[i];
                                while(c == '0' || c == '1' || c == '_') {
                                        if(c != '_') tokText.append_c(c);
                                        i++;
                                        column++;
                                        c = code[i];
                                }
                        } else {
                                tokText.append_c(c);
                                c = code[i];
                                while(c.isdigit() || c == '_') {
                                        if(c != '_') tokText.append_c(c);
                                        i++;
                                        column++;
                                        c = code[i];
                                        if(c == '.') {
                                                tokText.append_c(c);
                                                i++;
                                                column++;
                                                c = code[i];
                                        }
                                }
                        }
                        var type = getNumberLitteralType(tokText.str);
                        tok = Token(type, info, tokText.str);
                        ret += tok;
                        continue;
                }
                if(c == '\"') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        while(c != '\"' && c !='\0') {
                                if(c == '\\') {
                                        tokText.append_c('\\');
                                        i++;
                                        column++;
                                        c = code[i];
                                        if(c == '\0') break;
                                        else tokText.append_c(c);
                                        i++;
                                        column++;
                                        c = code[i];
                                } else if(c == '\n') {
                                        tokText.append_c('\\');
                                        tokText.append_c('n');
                                        line++;
                                        column = 0;
                                        i++;
                                        c = code[i];
                                } else {
                                        tokText.append_c(c);
                                        i++;
                                        column++;
                                        c = code[i];
                                }
                        }
                        if(c == '\0') break;
                        i++;
                        column++;
                        c = code[i];
                        ret += Token(tokText.str, TokenType.STRING_LITTERAL, info);
                        continue;
                }
                if(c == '\'') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '\'') _log.TokenError(info, "Error empty character does not exist!");
                        if(c == '\\') {
                                tokText.append_c(c);
                                i++;
                                column++;
                                c = code[i];
                        }
                        tokText.append_c(c);
                        i++;
                        column++;
                        c = code[i];
                        if(c != '\'') _log.TokenError(TokenInfo(line, column, filename), @"Expected simple quote but founded {$(c)}");
                        i++;
                        column++;
                        c = code[i];
                        ret += Token(tokText.str, TokenType.CHAR_LITTERAL, info);
                        continue;
                }
                if(c in "[](){}".data) {
                        var tokText = new StringBuilder();
                        tokText.append_c(c);
                        i++;
                        column++;
                        var type = TokenType.UNDEFINED;
                        switch (c) {
                                case '{':
                                        type = TokenType.BRACKET_OPEN;
                                        break;
                                case '}':
                                        type = TokenType.BRACKET_CLOSE;
                                        break;
                                case '(':
                                        type = TokenType.PARENTESIS_OPEN;
                                        break;
                                case ')':
                                        type = TokenType.PARENTESIS_CLOSE;
                                        break;
                                case '[':
                                        type = TokenType.SQUARE_BRACKET_OPEN;
                                        break;
                                case ']':
                                        type = TokenType.SQUARE_BRACKET_CLOSE;
                                        break;
                        }
                        var tok = Token(tokText.str, getBracketType(c), TokenInfo(line, column, filename));
                        if(tok.type == TokenType.UNDEFINED) _log.TokenError(tok.info, "Parsing error undefined bracket Type |unreachable|");
                        ret += tok;
                        c = code[i];
                        continue;
                }
                if(c == '/') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '=') {
                                tokText.append("/=");
                                i++;
                                column++;
                        } else {
                                tokText.append_c('/');
                        }
                        ret += Token(tokText.str, TokenType.OPERATOR, info);
                        continue;
                }
                if(c == '*') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '=') {
                                tokText.append("*=");
                                i++;
                                column++;
                        } else {
                                tokText.append_c('*');
                        }
                        ret += Token(tokText.str, TokenType.OPERATOR, info);
                        continue;
                }
                if(c == '+') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '=') {
                                tokText.append("+=");
                                i++;
                                column++;
                        } else if(c == '+') {
                                tokText.append("++");
                                i++;
                                column++;
                        } else {
                                tokText.append_c('+');
                        }
                        ret += Token(tokText.str, TokenType.OPERATOR, info);
                        continue;
                }
                if(c == '-') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        var type = TokenType.OPERATOR;
                        c = code[i];
                        if(c == '=') {
                                tokText.append("-=");
                                i++;
                                column++;
                        } else if(c == '-') {
                                tokText.append("--");
                                i++;
                                column++;
                        } else if(c == '>') {
                                tokText.append("->");
                                i++;
                                column++;
                                type = TokenType.SPECIAL;
                        } else {
                                tokText.append_c('-');
                        }
                        ret += Token(tokText.str, type, info);
                        continue;
                }
                if(c == '%') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '=') {
                                tokText.append("%=");
                                i++;
                        } else {
                                tokText.append_c('%');
                        }
                        ret += Token(tokText.str, TokenType.OPERATOR, info);
                        continue;
                }
                if(c == '!') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        var type = TokenType.OPERATOR;
                        c = code[i];
                        if(c == '=') {
                                tokText.append("!=");
                                i++;
                                column++;
                        } else if(c == '\"') {
                                tokText.append_c('!');
                                type = TokenType.SPECIAL;
                        } else {
                                tokText.append_c('!');
                        }
                        ret += Token(tokText.str, type, info);
                        continue;
                }
                if(c == '=') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '=') {
                                tokText.append("==");
                                i++;
                                column++;
                        } else if(c == '>') {
                                tokText.append("=>");
                                i++;
                                column++;
                        } else if(c == '<') {
                                tokText.append("=<");
                                i++;
                                column++;
                        } else {
                                tokText.append_c('=');
                        }
                        ret += Token(tokText.str, TokenType.OPERATOR, info);
                        continue;
                }
                if(c == '<') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '<') {
                                i++;
                                column++;
                                c = code[i];
                                if(c == '=') {
                                        tokText.append("<<=");
                                        i++;
                                        column++;
                                } else tokText.append("<<");
                        } else if(c == '=') {
                                tokText.append("<=");
                                i++;
                                column++;
                        } else {
                                tokText.append_c('<');
                        }
                        ret += Token(tokText.str, TokenType.OPERATOR, info);
                        continue;
                }
                if(c == '>') {
                        var tokText = new StringBuilder();
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        c = code[i];
                        if(c == '>') {
                                i++;
                                column++;
                                c = code[i];
                                if(c == '=') {
                                        tokText.append(">>=");
                                        i++;
                                        column++;
                                } else tokText.append(">>");
                        } else if(c == '=') {
                                tokText.append(">=");
                                i++;
                                column++;
                        } else {
                                tokText.append_c('>');
                        }
                        ret += Token(tokText.str, TokenType.OPERATOR, info);
                        continue;
                }
                if(c == '.') {
                        var tokText = new StringBuilder();
                        tokText.append_c(c);
                        i++;
                        column++;
                        ret += Token(tokText.str, TokenType.OPERATOR, TokenInfo(line, column, filename));
                        continue;
                }
                if(c == ',') {
                        var tokText = new StringBuilder();
                        tokText.append_c(c);
                        i++;
                        column++;
                        ret += Token(tokText.str, TokenType.SPECIAL, TokenInfo(line, column, filename));
                        continue;
                }
                if(c == ';') {
                        var tokText = new StringBuilder();
                        tokText.append_c(c);
                        i++;
                        column++;
                        ret += Token(tokText.str, TokenType.SPECIAL, TokenInfo(line, column, filename));
                        continue;
                }
                if(c == ':') {
                        var tokText = new StringBuilder();
                        tokText.append_c(c);
                        i++;
                        column++;
                        var info = TokenInfo(line, column, filename);
                        var type = TokenType.SPECIAL;
                        c = code[i];
                        if(c == ':') {
                                tokText.append_c(c);
                                i++;
                                column++;
                                c = code[i];
                                type = TokenType.OPERATOR;
                        }
                        ret += Token(tokText.str, type, info);
                        continue;
                }
                i++; 
                column++;
        }
        ret += Token("", TokenType.EOC, TokenInfo(-1, -1, "null"));
        return ret;
}


