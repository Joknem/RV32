.section .text
.global _start
.global main

_start:
    lui sp, %hi(_stack_start)
    addi sp, sp, %lo(_stack_start)
    jal zero, main

loop:
    j loop