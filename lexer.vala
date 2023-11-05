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

public class LexerToken {
        public Token[] token;
}


public class LexerVariable : LexerToken {
        public string typeName;
        public string name;
}

public class LexerFunction : LexerToken {
        public LexerVariable[] parameters;
        public LexerToken[] body;
        public string returnType;
        public string name;
}

public class LexerType : LexerToken {
        public LexerFunction[] methods;
        public string previous;
        public string name;
        public int size;
        public bool isBase;
}

public class LexerContainer : LexerToken {
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

public class LexerLibrary : LexerContainer {
        public bool isCLib;
}

public class LexerNamespace : LexerContainer {
}
