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
