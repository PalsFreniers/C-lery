typedef signed int i32;
typedef unsigned long long int u64;
typedef char *str;

extern u64 write(i32 fd, str s, u64 len);

u64 fn_strlen(str s) {
        u64 i = 0;
        while(s[i] != 0) i++;
        return i;
}

typedef struct class_data {
        str value;
} class_data;

struct class_data method_init_class_data() {
        return (struct class_data) {
                .value = "test",
        };
}

void method_destruct_class_data() {}

struct class_data method_copy_class_data(struct class_data *copy) {
        return *copy;
}

void method_print_class_data(struct class_data *self) {
        write(1, self->value, fn_strlen(self->value));
}

void fn_print(str s) {
        write(1, s, fn_strlen(s));
}

i32 namespace_random_fn_rng() {
        i32 ret = 1;
        ret = ret ^ ((ret << 5) ^ (ret >> 12));
        return ret;
}

typedef struct namespace_random_struct_Point {
        i32 x;
        i32 y;
} namespace_random_struct_Point;

typedef union namespace_random_union_pnt {
        namespace_random_struct_Point u1;
        u64 u2;
} namespace_random_union_pnt;

i32 entry() {
        class_data i = method_init_class_data();
        fn_print("test");
        i.value = "new test";
        method_print_class_data(&i);
        i32 rand = namespace_random_fn_rng();
        namespace_random_struct_Point point = (namespace_random_struct_Point) {
                .x = rand,
                .y = 12
        };
        namespace_random_union_pnt p;
        p.u1 = point;
        p.u2 = 0x0000000A0000000B;
        method_destruct_class_data(i);
        return p.u1.x;
}

int main(int argc, char **args, char **envs) {
        return entry();
}
