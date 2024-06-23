.section .init
.global _start
.type _start, @function

_start:
.option push
.option pop
    la sp, _sp
#ifdef SIM
    li x26, 0x00
    li x27, 0x00
#endif
    //load data sections
    la a0, _data_lma
    la a1, _data
    la a2, _edata
    bgeu a1, a2, 2f

1:
    lw t0, (a0)
    sw t0, (a1)
    addi a0, a0, 4
    addi a1, a1, 4
    bltu a1, a2, 1b

2: //clear bss section
    la a0, __bss_start
    la a1, _end
    bgeu a0, a1, 2f

1:
    sw zero, (a0)
    addi a0, a0, 4
    bltu a0, a1, 1b

2:
    call main

#ifdef SIM
    li x26, 0x01
#endif

loop:
    j loop