typedef signed char int8;
typedef signed short int int16;
typedef signed int int32;
typedef signed long long int int64;
typedef unsigned char uint8;
typedef unsigned short int uint16;
typedef unsigned int uint32;
typedef unsigned long long int uint64;
typedef float float32;
typedef double float64;
typedef long double float128;
typedef char *str;
typedef unsigned char bool;



void entry(str args, str env);

uint64 test(char p1);

int main(int32 count, str *args, str *envs) {
        entry(args, envs);
        return 0;
}
void entry(str args, str env) {
        ;
}
uint64 test(char p1) {
        ;
}
