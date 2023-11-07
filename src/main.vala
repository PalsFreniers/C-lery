/* TODO: usage */
int run(string[] av) {
        int status = 1;
        SpawnFlags flags = STDOUT_TO_DEV_NULL | STDERR_TO_DEV_NULL | SEARCH_PATH | CHILD_INHERITS_STDIN;
	try {
                Process.spawn_sync(Environment.get_current_dir(), av, Environ.get(), flags, null, null, null, out status);
        } catch(Error e) {
                print(@"$(e.message)");
        }
        return status;
}

int main (string[] args) {
        if(args.length != 2) {
                print("Error you did not provided any files\n");
                return 1;
        }
        string content;
        size_t size;
        try {
                FileUtils.get_contents(args[1], out content, out size);
                var noCommsToken = removeComments(content);

        } catch(Error e) {
                print(@"$(e.message)");
        }
        return 0;
}
