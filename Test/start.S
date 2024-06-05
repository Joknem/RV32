.section .text
.global _start
.global main

_start:
    la sp, _stack_top
    call main

loop:
    j loop