RISCV_TOOLCHAIN ?= /opt/nanoV

CC = $(RISCV_TOOLCHAIN)/bin/riscv32-unknown-elf-gcc
AS = $(RISCV_TOOLCHAIN)/bin/riscv32-unknown-elf-as
AR = $(RISCV_TOOLCHAIN)/bin/riscv32-unknown-elf-ar

all: nanoV.a start.o

clean:
	rm *.o *.a

%.o: %.c 
	$(CC) -O2 -march=rv32e -mabi=ilp32e -nostdlib -nostartfiles -ffreestanding -ffunction-sections -fdata-sections -lc -c $< -o $@

%.o: %.s
	$(AS) -march=rv32em -mabi=ilp32e $< -o $@

nanoV.a: uart.o mul.o peripheral.o runtime.o soft-spi.o isqrt.o
	$(AR) rcs $@ $^ $(RISCV_TOOLCHAIN)/lib/gcc/riscv32-unknown-elf/*/libgcc.a

