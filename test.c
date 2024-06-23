int main(){
    int a = 10;
    int b = 5;
    int c;
    // 算术指令
    asm volatile ("add %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // ADD
    asm volatile ("add %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // ADD
    }