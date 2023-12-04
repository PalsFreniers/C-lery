public class Parser {
        Token[] toks;
        int pos;

        public Parser(Token[] toks) {
                this.toks = toks;
                this.pos = 0;
        }

        public Token peek(int offset = 1) {
                var index = this.pos + offset;
                if(index >= this.toks.length)
                        return this.toks[this.toks.length - 1];
                return this.toks[index];
        }
}
