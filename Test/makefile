SHELL := /usr/bin/zsh
CC_PREFIX = riscv64-unknown-linux-gnu-
C_SOURCE := $(shell find . -name *.c)
# ASM_SOURCE := $(shell find . -name *.s)
ASM_SOURCE += $(shell find . -name *.S)
ASM_OBJECT := $(patsubst %.s,%.o, $(patsubst %.S,%.o,$(ASM_SOURCE)))
C_OBJECT := $(patsubst %.c,%.o,$(C_SOURCE))
CC := $(CC_PREFIX)gcc
C_FLAGS := -nostdlib -march=rv32i -mabi=ilp32 -c
C_FLAGS += -DSIM
LD_FLAGS := -m elf32lriscv -T link.ld
DUMP_FLAGS := -D -j .text -j .init
GEN_MEMFILE := python3 compile_c.py main.txt
DUMP_TXT := main.txt
ELF_TXT := all.txt
FINAL := main.elf


all: readelf
	@$(GEN_MEMFILE)
	@rm *.o

$(ASM_OBJECT): $(ASM_SOURCE)
	@$(CC) $(C_FLAGS) $(C_FLAGS) $(ASM_SOURCE) 

$(C_OBJECT): $(C_SOURCE)
	@$(CC) $(C_FLAGS) $(C_SOURCE)

$(FINAL): $(C_OBJECT) $(ASM_OBJECT)
	@$(CC_PREFIX)ld $(LD_FLAGS) -o $(FINAL) $(ASM_OBJECT) $(C_OBJECT)
	@echo "compile finished!"
	@$(CC_PREFIX)objdump $(DUMP_FLAGS) $(FINAL) > $(DUMP_TXT)
	@echo "objdump finished!"

echo:
	@echo $(C_OBJECT) $(ASM_OBJECT)

readelf: $(FINAL)
	@$(CC_PREFIX)readelf -a $(FINAL) > all.txt

clean:
	rm $(FINAL)
	rm -rf *.txt 
.PHONY:
	all, echo, readelf, clean<|endoftext|>