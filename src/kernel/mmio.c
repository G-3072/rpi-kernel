#include <mmio.h>

inline void mmio_write(uint32_t reg, uint32_t data){
    *(volatile uint32_t *)reg = data;
}

inline uint32_t mmio_read(uint32_t reg){
    return *(volatile uint32_t *)reg;
}

inline void delay(int32_t cnt){
    asm volatile(
        "__delay_%=: subs %[cnt], %[cnt], #1; bne __delay_%="
        : "=r" (cnt) : [cnt]"0"(cnt) : "cc"
    );
}