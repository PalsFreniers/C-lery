int run(string []av) {
        SpawnFlags flags = 0;
        string PWD = Environment.get_current_dir();

        flags = SEARCH_PATH | CHILD_INHERITS_STDIN;
        try {
                int status;
                Process.spawn_sync(PWD, av, Environ.get(), flags, null, null, null, out status);
                return status;
        } catch (Error e) {
                print("%s\n", e.message);
        }
        return 1;
}

void main(string[] args) {
        if(args.length != 2) return;
        string content;
        size_t size;
        try {
                var file = args[1];
                var exist = FileUtils.get_contents(file, out content, out size);
                if(!exist) return;
                var noComm = removeComments(content);
                var tokenList = getTokensList(noComm, file);
                foreach(var t in tokenList) {
                        print(@"$(t)\n");
                }
//                 var parser = new Parser(tokenList);
//                 var parseTree = parser.parse();
//                 generateAsm(file, parseTree);
//                 run({"nasm", "-felf64", "-o", file + ".o", file + ".S"});
//                 run({"ld", "-o", file.split(".lery")[0], file + ".o"});
        } catch (Error e) {
                print ("%s\n", e.message);
        }
}
