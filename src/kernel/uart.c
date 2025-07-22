#include <uart.h>
#include <mmio.h>
#include <stddef.h>

void uart_init(void)
{
    mmio_write(GPFSEL1, ~(0x3F<<12));       //clear function select bits
    mmio_write(GPFSEL1, (1<<12)|(1<<15));    // set pin14&15 to function ALT5 --> TXD1 & RXD1
    
    mmio_write(UART_CR, 0x0);  // disables UART so it can be configured

    mmio_write(GPPUD, 0x0); // disable GPIO Pull-Ups/Downs
    delay(150);

    mmio_write(GPPUDCLK0, (1<<14)|(1<<15)); // select pins 14 & 15
    delay(150);

    mmio_write(GPPUDCLK0, 0x0);

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
