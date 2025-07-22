TOOLCHAIN = arm-none-eabi
CC = ${TOOLCHAIN}-gcc
OBJCOPY = ${TOOLCHAIN}-objcopy
GDB = ${TOOLCHAIN}-gdb

CFLAGS = -Wall -Werror -nostdlib -nostartfiles -ffrestanding
LDFLAGS = --warn --fatal-warnings -lgcc

BUILD_DIR ?= build

SERIAL_ARG =

ifeq (${BUILD}, release)
	CFLAGS += -O2
	BUILD_DIR = build/release
else
	CFLAGS += -O2 -g
	BUILD_DIR = build/debug
endif

ifeq (${STDIO}, mini)
	SERIAL_ARG = -serial null -serial mon:stdio
else
	SERIAL_ARG = -serial mon:stdio -serial null
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
	rm -rf $(BUILD_DIR)

run: all
	qemu-system-arm -M raspi0 -m 512 ${SERIAL_ARG} -kernel ${BUILD_DIR}/kernel.elf -nographic

rundbg: all
	qemu-system-arm -M raspi0 -m 512 ${SERIAL_ARG} -kernel ${BUILD_DIR}/kernel.elf -nographic -s -S
# file targets

${BUILD_DIR}/%.o: ${KERNEL_SRC}/%.c
	mkdir -p $(@D)
	${CC} -c $< -o $@ -I${KER_HEAD} ${CFLAGS} 
${BUILD_DIR}/%.o: ${COMMON_SRC}/%.c
	mkdir -p $(@D)
	${CC} -c $< -o $@ ${CFLAGS}
${BUILD_DIR}/%.o: ${KERNEL_SRC}/%.S
	mkdir -p $(@D)
	${CC} -c $< -o $@ ${CFLAGS}
${BUILD_DIR}/%.o: ${COMMON_SRC}/%.S
	mkdir -p $(@D)
	${CC} -c $< -o $@ -I${KER_HEAD} ${CFLAGS}