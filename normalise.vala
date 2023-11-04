public TokenType getBracketType(char c) {
        switch (c) {
        case '{':
                return TokenType.BRACKET_OPEN;
        case '}':
                return TokenType.BRACKET_CLOSE;
        case '(':
                return TokenType.PARENTESIS_OPEN;
        case ')':
                return TokenType.PARENTSIS_CLOSE;
        case '[':
                return TokenType.SQUARE_BRACKET_OPEN;
        case ']':
                return TokenType.SQUARE_BRACKET_CLOSE;
        default:
                return TokenType.UNDEFINED;                
        }
}

public Token[] getTokensList(string code, string filename) {
        var _log = new Logger("Tokenizer");
        Token[] ret = {};
        var column = 1;
        var line = 1;
        var i = 0;
        var c = ' ';
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
                        var text = tokText.str;
                        var type = (text in KEYWORDS) ? TokenType.KEYWORD : TokenType.IDENTIFIER;
                        ret += Token(tokText.str, type, info);
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
                                tok = Token(tokText.str, TokenType.INT_LITTERAL, info);
                                tok.specs = TokenSpec.INT_HEX;
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
                                tok = Token(tokText.str, TokenType.INT_LITTERAL, info);
                                tok.specs = TokenSpec.INT_BIN;
                        } else {
                                var type = TokenType.INT_LITTERAL;
                                tokText.append_c(c);
                                c = code[i];
                                while(c.isdigit() || c == '_') {
                                        if(c != '_') tokText.append_c(c);
                                        i++;
                                        column++;
                                        c = code[i];
                                        if(c == '.') {
                                                tokText.append_c(c);
                                                type = TokenType.FLOAT_LITTERAL;
                                                i++;
                                                column++;
                                                c = code[i];
                                        }
                                }
                                tok = Token(tokText.str, type, info);
                                if(type == TokenType.INT_LITTERAL) tok.specs = TokenSpec.INT_DEC;
                        }
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
                }
                if(c in "[](){}".data) {
                        var tokText = new StringBuilder();
                        tokText.append_c(c);
                        i++;
                        column++;
                        var tok = Token(tokText.str, getBracketType(c), TokenInfo(line, column, filename));
                        if(tok.type == TokenType.UNDEFINED) {
                                _log.error("Parsing error undefined bracket define");
                        }
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
        return ret;
}

public string normaliseSpace(string code) {
        var spaced = false;
        var ret = new StringBuilder();
        foreach(var ch in code.data) {
                char c = (char)ch;
                if(c.isspace() && !spaced) {
                        ret.append_c(' ');
                        spaced = true;
                }
                if(!c.isspace()) {
                        ret.append_c(c);
                        spaced = false;
                }
        }
        return ret.str;
}

public string removeComments(string code) {
        var ret = new StringBuilder();
        for (var i = 0; i < code.length; i++) {
                var c = code[i];
                if(c == '/') {
                        if(code[i + 1] == '/') {
                                while(c != '\n') {
                                        c = code[i];
                                        i++;
                                }
                                i -=2;
                        } else {
                                ret.append_c(c);
                        }
                } else {
                        ret.append_c(c);
                }
        }
        return ret.str;
}
