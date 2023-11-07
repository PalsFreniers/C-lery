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
                        } else if(code[i + 1] == '*') {
                                while(c != '*') {
                                        if(c == '\n') ret.append_c('\n');
                                        if(c == '*') if(code[i + 1] == '/') break;
                                        c = code[i];
                                        i++;
                                }
                        } else {
                                ret.append_c(c);
                        }
                } else {
                        ret.append_c(c);
                }
        }
        return ret.str;
}
