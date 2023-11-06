const string resetColor = "\033[39m";

public class Logger {
        private string name;
        public  string errorColor {private get; set;}
        public  string warnColor  {private get; set;}
        public  string infoColor  {private get; set;}
        public  string debugColor {private get; set;}

        public Logger(string name = "noName") {
                this.name = name;
                this.errorColor = "\033[31m";
                this.warnColor  = "\033[33m";
                this.infoColor  = "\033[32m";
                this.debugColor = "\033[34m";
        }

        [NoReturn]
        public void TokenError(TokenInfo info, string fmt, ...) {
                var lst = va_list();
                stderr.printf(@"$(this.errorColor)[$(this.name) ERROR]$(resetColor)   $(info.file):$(info.line):$(info.column) -> ");
                stderr.vprintf(fmt, lst);
                stderr.printf("\n");
                Process.exit(1);
        }

        public void TokenWarn(TokenInfo info, string fmt, ...) {
                var lst = va_list();
                stderr.printf(@"$(this.warnColor)[$(this.name) WARNING]$(resetColor) $(info.file):$(info.line):$(info.column) -> ");
                stderr.vprintf(fmt, lst);
                stderr.printf("\n");
        }

        public void TokenInfo(TokenInfo info, string fmt, ...) {
                var lst = va_list();
                stdout.printf(@"$(this.infoColor)[$(this.name) INFO]$(resetColor)    $(info.file):$(info.line):$(info.column) -> ");
                stdout.vprintf(fmt, lst);
                stdout.printf("\n");
        }

        public void TokenDebug(TokenInfo info, string fmt, ...) {
                var lst = va_list();
                stdout.printf(@"$(this.debugColor)[$(this.name) DEBUG]$(resetColor)   $(info.file):$(info.line):$(info.column) -> ");
                stdout.vprintf(fmt, lst);
                stdout.printf("\n");
        }

        [NoReturn]
        public void error(string fmt, ...) {
                var lst = va_list();
                stderr.printf(@"$(this.errorColor)[$(this.name) ERROR]$(resetColor)   -> ");
                stderr.vprintf(fmt, lst);
                stderr.printf("\n");
                Process.exit(1);
        }

        public void warn(string fmt, ...) {
                var lst = va_list();
                stderr.printf(@"$(this.warnColor)[$(this.name) WARNING]$(resetColor) -> ");
                stderr.vprintf(fmt, lst);
                stderr.printf("\n");
        }

        public void info(string fmt, ...) {
                var lst = va_list();
                stdout.printf(@"$(this.infoColor)[$(this.name) INFO]$(resetColor)    -> ");
                stdout.vprintf(fmt, lst);
                stdout.printf("\n");
        }

        public void debug(string fmt, ...) {
                var lst = va_list();
                stdout.printf(@"$(debugColor)[$(this.name) DEBUG]$(resetColor)   -> ");
                stdout.vprintf(fmt, lst);
                stdout.printf("\n");
        }
}
