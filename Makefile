CC = arm-none-eabi-gcc

CFLAGS = -mcpu=arm1176jzf-s -fpic -ffreestanding
LFLAGS = -ffreestanding -O1 -nostdlib

KER_SRC = src/kernel
COMMON_SRC = src/common
KER_INC = include/kernel
COMMON_INC = include/common
OBJ_DIR = build
BIN_DIR = bin

OBJECTS = ${wildcard ${OBJ_DIR}/*.o}

all: startup.o kernel.o
	${CC} -T cortex-A72.ld -o ${BIN_DIR}/kernel.elf ${LFLAGS} ${OBJECTS}
	arm-none-eabi-objcopy ${BIN_DIR}/kernel.elf -O ${BIN_DIR}/kernel.img

startup.o: ${KER_SRC}/startup.S
	${CC} -c ${KER_SRC}/startup.S -o ${OBJ_DIR}/startup.o ${CFLAGS}

kernel.o: ${KER_SRC}/kernel.c
	${CC} -c ${KER_SRC}/kernel.c -o ${OBJ_DIR}/kernel.o ${CFLAGS}

# clean:
