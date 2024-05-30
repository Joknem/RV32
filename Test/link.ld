OUTPUT_ARCH("riscv")
OUTPUT_FORMAT("elf32-littleriscv")
ENTRY(_start)
MEMORY{
    ROM (rx) : ORIGIN = 0x00000000, LENGTH = 0x00010000
    RAM (rwx) : ORIGIN = 0x10000000, LENGTH = 0x00010000
}

SECTIONS
{
    .text : {*(.text)} > ROM
    .data : { *(.data) } > RAM AT > ROM
    .rodata : { 
        *(.rodata)
        } > ROM
    .bss : {
        __bss_start = .;
        *(.bss)
        *(COMMON)
        __bss_end = .;
    } > RAM
    _stack_start = ORIGIN(RAM) + LENGTH(RAM);
    . += 0x8000;
    stack_top = .;
    _end = .;
}

