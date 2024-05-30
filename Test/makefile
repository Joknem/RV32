SHELL := /usr/bin/zsh
CC_PREFIX = riscv64-unknown-linux-gnu-
C_SOURCE := $(shell find . -name *.c)
# ASM_SOURCE := $(shell find . -name *.s)
ASM_SOURCE += $(shell find . -name *.S)
ASM_OBJECT := $(patsubst %.s,%.o, $(patsubst %.S,%.o,$(ASM_SOURCE)))
C_OBJECT := $(patsubst %.c,%.o,$(C_SOURCE))
CC := $(CC_PREFIX)gcc
C_FLAGS := -nostdlib -march=rv32i -mabi=ilp32 -c
LD_FLAGS := -m elf32lriscv -T link.ld
COPY_FLAGS := -O binary
DUMP_FLAGS := -D -j .text
FINAL := main.elf
BIN := main.bin


all: $(C_OBJECT) $(ASM_OBJECT)
	@$(CC_PREFIX)ld $(LD_FLAGS) -o $(FINAL) $(ASM_OBJECT) $(C_OBJECT)
	@$(CC_PREFIX)objcopy $(COPY_FLAGS) $(FINAL) $(BIN)
	@$(CC_PREFIX)objdump $(DUMP_FLAGS) $(FINAL) > main.txt
	@rm *.o

$(ASM_OBJECT): $(ASM_SOURCE)
	@$(CC) $(C_FLAGS) $(C_FLAGS) $(ASM_SOURCE) 

$(C_OBJECT): $(C_SOURCE)
	@$(CC) $(C_FLAGS) $(C_SOURCE)

echo:
	@echo $(C_OBJECT) $(ASM_OBJECT)

readelf: $(FINAL)
	@$(CC_PREFIX)readelf -a $(FINAL) > all.txt

clean:
	rm -rf *.o
.PHONY:
	build dump all