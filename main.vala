void main() {
	string content;
	size_t size;
	try {
		var exist = FileUtils.get_contents("test/test.lery", out content, out size);
		if(!exist) return;
		var noComm = removeComments(content);
		var normalised = normaliseTokens(noComm);
		var spaceNormalised = normaliseSpace(normalised);
		print(@"$(spaceNormalised)\n");
// 		print(@"$(normalised)\n");
	} catch (Error e) {
		print ("%s\n", e.message);
	}
}
