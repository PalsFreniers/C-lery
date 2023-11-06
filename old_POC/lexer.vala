public enum BaseTypes {
        INT, UNSIGNED, FLOAT, BOOLEAN, CHAR, STRING, VOID;

        public string to_string() {
                switch(this) {
                        case INT:
                                return "Integer";
                        case UNSIGNED:
                                return "Unsigned";
                        case FLOAT:
                                return "Float";
                        case BOOLEAN:
                                return "Boolean";
                        case CHAR:
                                return "Character";
                        case STRING:
                                return "String";
                        case VOID:
                                return "Void";
                }
                return "unreachable";
        }
}

public class LexerVariable {
        public bool isReference;
        public string typeName;
        public string name;
}

public class LexerFunction {
        public LexerVariable[] parameters;
        public string returnType;
        public Token[] body;
        public string name;
}

public class LexerType {
        public LexerFunction[] methods;
        public string previous;
        public string name;
        public int size;
}

public class LexerNamespace {
        public string[] namespaces;
        public string[] functions;
        public string[] classes;
        public string[] structs;
        public string[] globals;
        public string[] unions;
        public string[] types;
        public string[] enums;
        public string name;
}
