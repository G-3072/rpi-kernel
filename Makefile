ARMGNU = arm-none-eabi

CFLAGS = -mcpu=arm1176jzf-s -fpic -nostdlib -ffreestanding #-ffunction-sections -fdata-sections -Wall
LDFLAGS = -nostdlib -ffreestanding -O0 #-Wl,--gc-sections

IMG_NAME = kernel.img

BUILD_DIR = build
BIN_DIR = bin

KER_SRC = src/kernel
COMMON_SRC =src/common

KER_HEAD = include/kernel
COMMON_HEAD = include/common

HEADERS = ${wildcard ${KER_HEAD}/*.h} ${wildcard ${COMMON_HEAD}/*.h}

KER_C_SOURCES		= ${wildcard ${KER_SRC}/*.c}
COMMON_C_SOURCES	= ${wildcard ${COMMON_SRC}/*.c}
KER_ASM_SOURCES 	= ${wildcard ${KER_SRC}/*.S}
COMMON_ASM_SOURCES 	= ${wildcard ${COMMON_SRC}/*.S}

OBJECTS = 	${patsubst ${KER_SRC}/%.c, ${BUILD_DIR}/%.o, ${KER_C_SOURCES}} \
			${patsubst ${COMMON_SRC}/%.c, ${BUILD_DIR}/%.o, ${COMMON_C_SOURCES}} \
			${patsubst ${KER_SRC}/%.S, ${BUILD_DIR}/%.o, ${KER_ASM_SOURCES}} \
			${patsubst ${COMMON_SRC}/%.S, ${BUILD_DIR}/%.o, ${COMMON_ASM_SOURCES}} \

all: ${OBJECTS} ${HEADERS}
	mkdir -p ${BIN_DIR}
	${ARMGNU}-gcc  -T linker.ld -o ${BIN_DIR}/kernel.elf ${OBJECTS} ${LDFLAGS} -lgcc
	${ARMGNU}-objcopy ${BIN_DIR}/kernel.elf -O binary ${BIN_DIR}/${IMG_NAME}

${BUILD_DIR}/%.o: ${KER_SRC}/%.c
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ -I${KER_HEAD} ${CFLAGS} 
${BUILD_DIR}/%.o: ${COMMON_SRC}/%.c
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ ${CFLAGS}
${BUILD_DIR}/%.o: ${KER_SRC}/%.S
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ ${CFLAGS}
${BUILD_DIR}/%.o: ${COMMON_SRC}/%.S
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ -I${KER_HEAD} ${CFLAGS}

clean:
	rm -rf ${BUILD_DIR}
	rm -rf ${BIN_DIR}

run: all
	qemu-system-arm -m 512 -M raspi0 -serial stdio -kernel bin/kernel.img