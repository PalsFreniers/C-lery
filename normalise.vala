public Token[] getTokensList(string code) {
	Token[] ret;
	var column = 0;
	var line = 0;
	var i = 0;
	var c = ' ';
	while (c != '\0') {
		var tokText = new StringBuilder();
		c = code[i];
		if(c == '\n') {
			line++;
			column = 0;
		}
		if(c.isalnum()) {
			tokText.append_c(c);
			i++;
			column++;
			c = code[i];
			while(c.isalnum() || c == '_') {
				tokText.append_c(c);
				i++;
				column++;
				c = code[i];
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c.isdigit()) {
			if(c == 0 && code[i + 1] == 'x') {
				tokText.append("0x");
				i += 2;
				c = code[i];
				while(c.isxdigit() || c == '_') {
					tokText.append_c(c);
					i++;
					c = code[i];
				}
			} else if(c == 0 && code[i + 1] == 'b') {
				tokText.append("0b");
				i += 2;
				c = code[i];
				while(c == '0' || c == '1' || c == '_') {
					tokText.append_c(c);
					i++;
					c = code[i];
				}
			} else {
				tokText.append_c(c);
				i++;
				c = code[i];
				while(c.isdigit() || c == '_') {
					tokText.append_c(c);
					i++;
					c = code[i];
				}
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '\"') {
			tokText.append_c(c);
			i++;
			c = code[i];
			while(c != '\"' && c !='\0') {
				if(c == '\\') {
					tokText.append_c('\\');
					i++;
					c = code[i];
					if(c == '\0') break;
					else tokText.append_c(c);
					i++;
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
					c = code[i];
				}
			}
			if(c == '\0') break;
			tokText.append_c(c);
			i++;
			c = code[i];
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c in "[](){}".data) {
			tokText.append_c(c);
			i++;
			c = code[i];
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '/') {
			i++;
			c = code[i];
			if(c == '=') {
				tokText.append("/=");
				i++;
			} else {
				tokText.append_c('/');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '*') {
			i++;
			c = code[i];
			if(c == '=') {
				tokText.append("*=");
				i++;
			} else {
				tokText.append_c('*');
				i++;
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '+') {
			i++;
			c = code[i];
			if(c == '=') {
				tokText.append("+=");
				i++;
			} else if(c == '+') {
				tokText.append("++");
				i++;
			} else {
				tokText.append_c('+');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '-') {
			i++;
			c = code[i];
			if(c == '=') {
				tokText.append("-=");
				i++;
			} else if(c == '-') {
				tokText.append("--");
				i++;
			} else if(c == '>') {
				tokText.append("->");
				i++;
			} else {
				tokText.append_c('-');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '%') {
			i++;
			c = code[i];
			if(c == '=') {
				tokText.append("%=");
				i++;
			} else {
				tokText.append_c('%');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '!') {
			i++;
			c = code[i];
			if(c == '=') {
				tokText.append("!=");
				i++;
			} else {
				tokText.append_c('!');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '=') {
			i++;
			c = code[i];
			if(c == '=') {
				tokText.append("==");
				i++;
			} else if(c == '>') {
				tokText.append("=>");
				i++;
			} else if(c == '<') {
				tokText.append("=<");
				i++;
			} else {
				tokText.append_c('=');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '<') {
			i++;
			c = code[i];
			if(c == '<') {
				i++;
				c = code[i];
				if(c == '=') {
					tokText.append("<<=");
					i++;
				} else tokText.append("<<");
			} else if(c == '=') {
				tokText.append("<=");
				i++;
			} else {
				tokText.append_c('<');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '>') {
			i++;
			c = code[i];
			if(c == '>') {
				i++;
				c = code[i];
				if(c == '=') {
					tokText.append(">>=");
					i++;
				} else tokText.append(">>");
			} else if(c == '=') {
				tokText.append(">=");
				i++;
			} else {
				tokText.append_c('>');
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == '.') {
			tokText.append_c(c);
			i++;
			c = code[i];
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == ',') {
			tokText.append_c(c);
			i++;
			c = code[i];
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == ';') {
			tokText.append_c(c);
			i++;
			c = code[i];
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		if(c == ':') {
			tokText.append_c(c);
			i++;
			c = code[i];
			if(c == ':') {
				tokText.append_c(c);
				i++;
				c = code[i];
			}
			if(!c.isspace()) tokText.append_c(' ');
			continue;
		}
		i++;	
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
