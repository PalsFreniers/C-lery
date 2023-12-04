string genParams(bool isCall, int nb) {
        switch (nb) {
                case 0:
                        return "";
                case 1:
                        return isCall ? "args" : "int32 count, str *args";
                case 2:
                        return isCall ? "args, envs" : "int32 count, str *args, str *envs";
                default:
                        new Logger("CRT0").error("Error entry can only have two or less parameter");
        }
}

public string generateCRT0(Type rtype, int args) {
        var sb = new StringBuilder();
        sb.append(@"int main($(genParams(false, args))) {\n");
        if(rtype == Type.VOID) {
                sb.append(@"        entry($(genParams(true, args)));\n");
                sb.append("        return 0;\n");
        } else {
                sb.append(@"        return entry($(genParams(true, args)));\n");
        }
        sb.append("}\n");
        return sb.str;
}

public string setTypes() {
        var sb = new StringBuilder();
        sb.append("typedef signed char int8;\n");
        sb.append("typedef signed short int int16;\n");
        sb.append("typedef signed int int32;\n");
        sb.append("typedef signed long long int int64;\n");
        sb.append("typedef unsigned char uint8;\n");
        sb.append("typedef unsigned short int uint16;\n");
        sb.append("typedef unsigned int uint32;\n");
        sb.append("typedef unsigned long long int uint64;\n");
        sb.append("typedef float float32;\n");
        sb.append("typedef double float64;\n");
        sb.append("typedef long double float128;\n");
        sb.append("typedef char *str;\n");
        sb.append("typedef unsigned char bool;\n");
        return sb.str;
}

public void generateC(string file) {
        var _log = new Logger("generator");
        var fs = FileStream.open(file + ".c", "w");
        if(fs == null) return;
        if(entryFunction == null) _log.error("missing entry function");
        fs.printf(@"$(setTypes())\n\n\n");

        fs.printf(@"$(entryFunction.getRType().getCType()) $(entryFunction.getName())(");
        var i = 1;
        foreach (var p in entryFunction.getParams()) {
                if(p.getType() != Type.STR) _log.error("entry function can only have 2 str paramemters");
                fs.printf(@"$(p.getType().getCType()) $(p.getName())");
                if(i != entryFunction.getParams().length) fs.printf(@", ");
                i++;
        }
        fs.printf(@");\n\n");

        foreach (var func in freeFunctions) {
                fs.printf(@"$(func.getRType().getCType()) $(func.getName())(");
                i = 1;
                foreach (var p in func.getParams()) {
                        fs.printf(@"$(p.getType().getCType()) $(p.getName())");
                        if(i != func.getParams().length) fs.printf(@", ");
                        i++;
                }
                fs.printf(@");\n\n");
        }

        fs.printf(generateCRT0(entryFunction.getRType(), entryFunction.getParams().length));

        fs.printf(@"$(entryFunction.getRType().getCType()) $(entryFunction.getName())(");
        i = 1;
        foreach (var p in entryFunction.getParams()) {
                if(p.getType() != Type.STR) _log.error("entry function can only have 2 str paramemters");
                fs.printf(@"$(p.getType().getCType()) $(p.getName())");
                if(i != entryFunction.getParams().length) fs.printf(@", ");
                i++;
        }
        fs.printf(@") {\n        ;\n}\n");

        foreach (var func in freeFunctions) {
                fs.printf(@"$(func.getRType().getCType()) $(func.getName())(");
                i = 1;
                foreach (var p in func.getParams()) {
                        fs.printf(@"$(p.getType().getCType()) $(p.getName())");
                        if(i != func.getParams().length) fs.printf(@", ");
                        i++;
                }
                fs.printf(@") {\n        ;\n}\n");
        }
}
