#include <stdint.h>
#include <mmio.h>

void uart_init(void);
void uart_putc(unsigned char c);
void uart_puts(const char* str);

unsigned char uart_getc(void);

void kernel_main(uint32_t r0, uint32_t r1, uint32_t atags)
{
    uart_init();

    uart_puts("Hello wolrd!\r\n");
    while(1){
        
    }
}

void uart_init(void)
{
    mmio_write(UART_CR, 0x0);
    mmio_write(UART_ICR, 0x7FF);
    mmio_write(UART_IBRD, 26);
    mmio_write(UART_FBRD, 3);
    mmio_write(UART_LCRH, ((1 << 4) | (1 << 5) | (1 << 6)));
    mmio_write(UART_IMSC, ((1 << 1) | (1 << 4) | (1 << 5) | (1 << 6) | (1 << 7) | (1 << 8) | (1 << 9) | (1 << 10)));
    mmio_write(UART_CR, ((1 << 0) | (1 << 8) | (1 << 9)));

    mmio_write(GPFSEL1, ~(7<<12));
    mmio_write(GPFSEL1, (1<<13));
}

void uart_putc(unsigned char c)
{
    while(mmio_read(UART_FR) & (1<<5));
    mmio_write(UART_DR, c);
}

void uart_puts(const char* str)
{
    for (size_t i = 0; str[i] != '\0'; i++){
        uart_putc((unsigned char)str[i]);
    }
}

unsigned char uart_getc(void){
    while(mmio_read(UART_FR) & (1<<4));
    return mmio_read(UART_DR);
}
