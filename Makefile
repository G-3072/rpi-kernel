CC = arm-none-eabi-gcc

CFLAGS = -mcpu=arm1176jzf-s -fpic -ffreestanding
LFLAGS = -ffreestanding -O1 -nostdlib

KER_SRC = src/kernel
COMMON_SRC = src/common
KER_HEAD = include/kernel
COMMON_HEAD = include/common
BUILD_DIR = build
BIN_DIR = bin

all: startup.o kernel.o
	${CC} -I include  