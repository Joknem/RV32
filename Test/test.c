#include "check.h"

// void test_rv32i_instructions() {
//     int a = 10;
//     int b = 5;
//     int c;

//     // 算术指令
//     asm volatile ("add %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // ADD
//     CHECK(c == 15);
//     asm volatile ("sub %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // SUB
//     CHECK(c == 5);

//     // 逻辑指令
//     asm volatile ("and %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // AND
//     CHECK(c == 0);
//     asm volatile ("or %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // OR
//     CHECK(c == 15);
//     asm volatile ("xor %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // XOR
//     CHECK(c == 15);

//     // 移位指令
//     asm volatile ("sll %0, %1, %2" : "=r"(c) : "r"(a), "r"(1)); // SLL
//     CHECK(c == 20);
//     asm volatile ("srl %0, %1, %2" : "=r"(c) : "r"(a), "r"(1)); // SRL
//     CHECK(c == 5);
//     asm volatile ("sra %0, %1, %2" : "=r"(c) : "r"(a), "r"(1)); // SRA
//     CHECK(c == 5);

//     // 比较指令
//     asm volatile ("slt %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // SLT
//     CHECK(c == 1);
//     asm volatile ("sltu %0, %1, %2" : "=r"(c) : "r"(a), "r"(b)); // SLTU
//     CHECK(c == 1);
// }

int main() {
    // test_rv32i_instructions();
    int a = 10;
    int b = 5;
    int c = a + b;
    return c;
}