TOOLCHAIN = arm-none-eabi
CC = ${TOOLCHAIN}-gcc
OBJCOPY = ${TOOLCHAIN}-objcopy
GDB = ${TOOLCHAIN}-gdb

CFLAGS = -mcpu=arm1176jzf-s -Wall -Werror -nostdlib -nostartfiles -ffreestanding
ASMFLAGS = -mcpu=arm1176jzf-s -Wall -Werror
LDFLAGS = -lgcc -ffreestanding -nostdlib

BUILD_DIR ?= build

SERIAL_ARG ?= -serial mon:stdio -serial null

ifeq (${BUILD}, release)
	CFLAGS += -O2
	BUILD_DIR = build/release
else ifeq (${BUILD}, debug)
	CFLAGS += -O0 -g
	BUILD_DIR = build/debug
else
	CFLAGS += -O2
	BUILD_DIR = build/release
endif

ifeq (${STDIO}, mini)
	SERIAL_ARG = -serial null -serial stdio
else ifeq (${STDIO}, pl011)
	SERIAL_ARG = -serial stdio -serial null
else
	SERIAL_ARG = -serial stdio -serial null
endif

KERNEL_SRC = src/kernel
COMMON_SRC = src/common

KERNEL_INC = include/kernel
COMMON_INC = include/common

HEADERS = ${wildcard ${KERNEL_INC}/*.h} ${wildcard ${COMMON_INC}/*.h}

KERNEL_C_SOURCES = ${wildcard ${KERNEL_SRC}/*.c}
COMMON_C_SOURCES = ${wildcard ${COMMON_SRC}/*.c}

KERNEL_ASM_SOURCES = ${wildcard ${KERNEL_SRC}/*.S}
COMMON_ASM_SOURCES = ${wildcard ${COMMON_SRC}/*.S}

OBJECT_FILES = 	${patsubst ${KERNEL_SRC}/%.c, ${BUILD_DIR}/%.o, ${KERNEL_C_SOURCES}} \
				${patsubst ${COMMON_SRC}/%.c, ${BUILD_DIR}/%.o, ${COMMON_C_SOURCES}} \
				${patsubst ${KERNEL_SRC}/%.S, ${BUILD_DIR}/%.o, ${KERNEL_ASM_SOURCES}} \
				${patsubst ${COMMON_SRC}/%.S, ${BUILD_DIR}/%.o, ${COMMON_ASM_SOURCES}} 

# special targets:
all: ${OBJECT_FILES} ${HEADERS}
	${CC} -T boot/linker.ld -o ${BUILD_DIR}/kernel.elf ${OBJECT_FILES} ${LDFLAGS}
	${OBJCOPY} ${BUILD_DIR}/kernel.elf -O binary ${BUILD_DIR}/kernel.img

clean:
	rm -rf build/**

run: all
	qemu-system-arm -M raspi0 -m 512 ${SERIAL_ARG} -kernel ${BUILD_DIR}/kernel.elf -display none

rundbg: all
	qemu-system-arm -M raspi0 -m 512 ${SERIAL_ARG} -kernel ${BUILD_DIR}/kernel.elf -s -S

# file targets
${BUILD_DIR}/%.o: ${KERNEL_SRC}/%.c
	mkdir -p $(@D)
	${CC} ${CFLAGS} -I${KERNEL_INC} -c $< -o $@ 

${BUILD_DIR}/%.o: ${COMMON_SRC}/%.c
	mkdir -p $(@D)
	${CC} ${CFLAGS} -I${COMMON_INC} -I${KERNEL_INC} -c $< -o $@ 

${BUILD_DIR}/%.o: ${KERNEL_SRC}/%.S
	mkdir -p $(@D)
	${CC} ${ASMFLAGS} -c $< -o $@

${BUILD_DIR}/%.o: ${COMMON_SRC}/%.S
	mkdir -p $(@D)
	${CC} ${ASMFLAGS} -c $< -o $@