void main(string[] args) {
        string content;
        size_t size;
        try {
//                 var _log = new Logger("Master");
                var file = "../test/Hello_World.lery";
                var exist = FileUtils.get_contents(file, out content, out size);
                if(!exist) return;
                var noComm = removeComments(content);
                var tokenList = getTokensList(noComm, file);
                lexeriseBase(tokenList);
                writeC("test.c");
        } catch (Error e) {
                print ("%s\n", e.message);
        }
}
