public TokenType getBracketType(char c) {
        switch (c) {
        case '{':
                return TokenType.BRACKET_OPEN;
        case '}':
                return TokenType.BRACKET_CLOSE;
        case '(':
                return TokenType.PARENTESIS_OPEN;
        case ')':
                return TokenType.PARENTESIS_CLOSE;
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


