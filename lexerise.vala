public LexerFunction?   entry = null;
public LexerFunction[]  functions;

// UNDEFINED,
// IDENTIFIER, KEYWORD,
// INT_LITTERAL, FLOAT_LITTERAL, BOOL_LITTERAL, CHAR_LITTERAL, STRING_LITTERAL,
// BRACKET_OPEN, BRACKET_CLOSE, PARENTESIS_OPEN, PARENTSIS_CLOSE, SQUARE_BRACKET_OPEN, SQUARE_BRACKET_CLOSE,
// OPERATOR, SPECIAL, EOC; 

LexerVariable[] getParameters(Token[] code, ref int parentesisIndex) {
        var _log = new Logger("Lexer Parameters");
        var tok = code[parentesisIndex];
        if(tok.type != TokenType.PARENTESIS_OPEN) _log.TokenError(tok.info, "Functions can only have alphanumeric symboles and \'_\' in their identifiers");
        parentesisIndex++;
        tok = code[parentesisIndex];
        LexerVariable[] ret = {};
        while(tok.type != TokenType.PARENTESIS_CLOSE) {
                var vari = new LexerVariable();
                vari.isReference = false;
                if(tok.type == TokenType.KEYWORD && tok.text == "ref") {
                        vari.isReference = true;
                        parentesisIndex++;
                        tok = code[parentesisIndex];
                }
                if(tok.type != TokenType.IDENTIFIER) _log.TokenError(tok.info, @"Illegal parameter name $(tok.text)");
                vari.name = tok.text;
                parentesisIndex++;
                tok = code[parentesisIndex];
                if(tok.type != TokenType.SPECIAL && tok.text != ":") _log.TokenError(tok.info, "Missing parameter type oprator");
                parentesisIndex++;
                tok = code[parentesisIndex];
                // TODO : implement custom types
                if(tok.type != TokenType.KEYWORD) {
                        _log.warn("Custom type are not implemented yet");
                        _log.TokenError(tok.info, @"Unable to find type: $(tok.text)");
                }
                vari.typeName = tok.text;
                parentesisIndex++;
                tok = code[parentesisIndex];
                if(tok.type == TokenType.SPECIAL && tok.text == ",") {
                        parentesisIndex++;
                        tok = code[parentesisIndex];
                } else if(tok.type != TokenType.PARENTESIS_CLOSE) _log.TokenError(tok.info, "Missing coma between parameter or closed parentesis at the end of parameters");
                ret += vari; 
        }
        return ret;
}

public void lexeriseBase(Token[] code) {
        var i = 0;
        var _log = new Logger("Lexer");
        var tok = code[i];
        LexerFunction[] LocalFunction = {};
        while (tok.type != TokenType.EOC) {
                tok = code[i];
                switch(tok.type) {
                        case TokenType.UNDEFINED:
                                _log.TokenError(tok.info, "During tokenisation part |unreachable|");
                        case TokenType.KEYWORD:
                                switch(tok.text) {
                                        case "fn":
                                                var fn = new LexerFunction();
                                                i++;
                                                tok = code[i];
                                                if(tok.type != TokenType.IDENTIFIER) _log.TokenError(tok.info, @"Illegal function name: $(tok.text) is not allowed as function name");
                                                foreach (var func in LocalFunction) if(func.name == tok.text) _log.TokenError(tok.info, @"function $(func.name) already exist");
                                                fn.name = tok.text;
                                                i++;
                                                tok = code[i];
                                                if(tok.type != TokenType.PARENTESIS_OPEN) _log.TokenError(tok.info, "Functions can only have alphanumeric symboles and \'_\' in their identifiers");
                                                fn.parameters = getParameters(code, ref i);
                                                tok = code[i];
                                                if(tok.type != TokenType.PARENTESIS_CLOSE) _log.TokenError(tok.info, @"Unknown Identifier in parameters of function $(fn.name)");
                                                i++;
                                                tok = code[i];
                                                if(tok.type != TokenType.SPECIAL && tok.text != "->") _log.TokenError(tok.info, @"Missing return code operator before return type name");
                                                i++;
                                                tok = code[i];
                                                // TODO : check for custom types;
                                                if(tok.type != TokenType.KEYWORD) {
                                                        _log.warn("Custom type are not implemented yet");
                                                        _log.TokenError(tok.info, @"Unable to find type: $(tok.text)");
                                                }
                                                fn.returnType = tok.text;
                                                i++;
                                                tok = code[i];
                                                if(tok.type != TokenType.BRACKET_OPEN) _log.TokenError(tok.info, @"Unkown Token $(tok.text) before function $(fn.name) block start");
                                                Token[] body = {tok};
                                                i++;
                                                tok = code[i];
                                                var nest = 0;
                                                while(tok.type != BRACKET_CLOSE) {
                                                        if(tok.type == TokenType.BRACKET_OPEN) {
                                                                nest++;
                                                                body += tok;
                                                        } else if(tok.type == TokenType.BRACKET_CLOSE && nest != 0) {
                                                                nest--;
                                                                body += tok;
                                                                i++;
                                                                tok = code[i];
                                                                continue;
                                                        } else if(tok.type == TokenType.EOC) _log.TokenError(tok.info, "Unclosed Block at en of file");
                                                        body += tok;
                                                        i++;
                                                        tok = code[i];
                                                }
                                                if(tok.type != TokenType.BRACKET_CLOSE) _log.TokenError(tok.info, "During lexing phase |unreachable|");
                                                body += tok;
                                                fn.body = body;
                                                if(fn.name == "entry") entry = fn;
                                                else LocalFunction += fn;
                                                break;
                                }
                                break;
                }
                i++;
        }
        functions = LocalFunction;
}

string getCType(string typeName) {
        // TODO : implement non standards types
        switch (typeName) {
                case "i8":
                        return "char";
                case "i16":
                        return "short int";
                case "i32":
                        return "int";
                case "i64":
                        return "long long int";
                case "u8":
                        return "unsigned char";
                case "u16":
                        return "unsigned short int";
                case "u32":
                        return "unsigned int";
                case "u64":
                        return "unsigned long long int";
                case "f32":
                        return "float";
                case "f64":
                        return "double";
                case "f128":
                        return "long double";
                case "bool":
                        return "char";
                case "char":
                        return "char";
                case "str":
                        return "char *";
                case "va_list":
                        return "va_list";
                case "void":
                        return "void";
                default:
                        return "undefined type";
        }
}

string convertBodyToC(Token[] body) {
        var _log = new Logger("C functions Converter");
        var i = 0;
        var tok = body[i];
        var nest = 0;
        var sb = new StringBuilder();
        while(i < body.length) {
                switch(tok.type) {
                        case TokenType.BRACKET_OPEN:
                                nest++;
                                sb.append("{\n");
                                break;
                        case TokenType.BRACKET_CLOSE:
                                sb.append("}\n");
                                break;
                        case TokenType.KEYWORD:
                        case TokenType.IDENTIFIER:
                        case TokenType.OPERATOR:
                        case TokenType.SPECIAL:
                                if(tok.text == "!" || tok.text == "->" || tok.text == ":" || tok.text == ",") _log.TokenError(tok.info, @"Illegal statement $(tok.text)");
                                if(tok.text == ";") sb.append(";\n");
                        default:
                                _log.TokenError(tok.info, @"Illegal statement $(tok.text)");
                }
                i++;
                tok = body[i];
        }
        return sb.str;
}

public void writeC(string filePath) {
        var _log = new Logger("C writer");
        var fs = FileStream.open(filePath, "w");
        if(fs == null) _log.error(@"unable to create file : $(filePath)");
        fs.printf("/* C-Lery Program compiled */\n#include <stdio.h>\n#include <stdarg.h>\n\n");
        foreach (var fn in functions) {
               if(fn.body.length <= 2) continue; 
               fs.printf(@"// function $(fn.name) returning $(fn.returnType)\n");
               fs.printf(@"$(getCType(fn.returnType)) $(fn.name)(");
               foreach (var p in fn.parameters) {
                       fs.printf(@"$(getCType(p.typeName)) $(p.name)");
                       if(p != fn.parameters[fn.parameters.length - 1]) fs.printf(", ");
               }
               fs.printf(")\n");
               fs.printf(@"$(convertBodyToC(fn.body))");
        }
}
