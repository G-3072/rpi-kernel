ARMGNU = arm-none-eabi

CFLAGS = -mcpu=arm1176jzf-s -fpic -nostdlib -ffreestanding -ffunction-sections -fdata-sections -Wall
LDFLAGS = -Wl,--gc-sections -nostdlib -ffreestanding -O2

IMG_NAME = kernel.img

BUILD_DIR = build

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
	${ARMGNU}-gcc  -T linker.ld -o ${BUILD_DIR}/kernel.elf ${OBJECTS} ${LDFLAGS}
	${ARMGNU}-objcopy ${BUILD_DIR}/kernel.elf -O binary ${BUILD_DIR}/${IMG_NAME}

${BUILD_DIR}/%.o: ${KER_SRC}/%.c
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ ${CFLAGS} 
${BUILD_DIR}/%.o: ${COMMON_SRC}/%.c
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ ${CFLAGS}
${BUILD_DIR}/%.o: ${KER_SRC}/%.S
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ ${CFLAGS}
${BUILD_DIR}/%.o: ${COMMON_SRC}/%.S
	mkdir -p $(@D)
	${ARMGNU}-gcc -c $< -o $@ ${CFLAGS}

clean:
	rm -rf ${BUILD_DIR}

run: all
	qemu-system-arm -m 512 -M raspi0 -serial stdio -kernel build/kernel.img