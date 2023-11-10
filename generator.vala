public string generateCRT0() {
        var sb = new StringBuilder();
        sb.append("section .text\n");
        sb.append("global _start\n");
        sb.append("_start:\n");
        sb.append("    mov rax, 1\n");
//         sb.append("    call _entry\n");
        sb.append("    mov rdi, rax\n");
        sb.append("    mov rax, 60\n");
        sb.append("    syscall\n");
        return sb.str;
}

public void generateAsm(string file) {
        var fs = FileStream.open(file + ".S", "w");
        if(fs == null) return;
        fs.printf(generateCRT0());        
}
