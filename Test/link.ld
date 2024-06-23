OUTPUT_ARCH("riscv")
OUTPUT_FORMAT("elf32-littleriscv")
ENTRY(_start)
MEMORY{
    ROM (rx) : ORIGIN = 0x00000000, LENGTH = 0x00001000
    RAM (rwx) : ORIGIN = 0x10000000, LENGTH = 0x00001000
}

SECTIONS
{
    __stack_size = DEFINED(__stack_size) ? __stack_size : 0x400;
    .init : {KEEP (*(SORT_NONE(.init)))} > ROM
    .text : {
        *(.text .text.*)
        } > ROM
    . = ALIGN(4);
    PROVIDE(__etext = .);
    PROVIDE(_etext = .);
    PROVIDE(etext = .);

    .lalign : {
        . = ALIGN(4);
        PROVIDE(_data_lma = .);
    } > ROM AT > ROM

    .dalign : {
        . = ALIGN(4);
        PROVIDE(_data = .);
    } > RAM AT > ROM

    .data : { 
        *(.data .data.*)
        *(.rdata)
        *(.rodata rodata.*)
        } > RAM AT > ROM
    . = ALIGN(4);
    PROVIDE(_edata = .);
    PROVIDE(edata = .);

    PROVIDE(__bss_start = .);
    .bss : {
        *(.bss .bss.*)
        *(.sbss*)
        *(COMMON)
        . = ALIGN(4);
    } > RAM AT > RAM
    . = ALIGN(8);
    PROVIDE(_end = .);
    PROVIDE(end = .);

    .stack ORIGIN(RAM) + LENGTH(RAM) - __stack_size : {
        PROVIDE(__heap_end = .);
        . = __stack_size;
        PROVIDE(_sp = .);
    } > RAM AT > RAM
}

