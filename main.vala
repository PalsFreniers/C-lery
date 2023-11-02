enum LexTokenType {
	NONE,
	IDENTIFIER,
	KEYWORD,
	BRACKET_OPEN, BRACKET_CLOSE, PARENTESES_OPEN, PARENTESES_CLOSE, SQUARE_OPEN, SQUARE_CLOSE,
	SEMICOLON, COLON, COMA,
	OPERATOR,
	STRING_LITTERAL, INT_LITTERAL, FLOAT_LITTERAL,
}

struct Token {
	public Token(string text, LexTokenType type) {
		this.text = text;
		this.type = type;
	}

	public LexTokenType type;
	public string text;
}

string normaliseCode(string code) {
	var ret = "";
	for (var i = 0; i < code.length; i++) {
		var c = code[i];
		if(c.isspace()) {
			ret.concat(" ");
			while(c.isspace()) {
				c = code[i];
				i++;
			}
			continue;
		}
	}

	return ret;
}

void main() {
	var code = " var     c   =    \' c   \'; \n    string: str;\n";
	print(@"$(normaliseCode(code))");
}
