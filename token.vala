public struct TokenInfo {
	int line;
	int column;
	string file;

	public TokenInfo(int line, int column, string file) {
		this.line = line;
		this.column = column;
		this.file = file;
	}
}

public struct Token {
	string    text;
	TokenType type;
	TokenInfo info;

	public Token(string text, TokenInfo info) {
		this.info = info;
		this.text = text;
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
	"ref"
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
	"void",
};
