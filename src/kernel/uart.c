#include <uart.h>
#include <mmio.h>

#define F_CORE      400000000U      // default BCM2835 Clock speed (400MHz)
#define F_CPU       1000000000U     // default ARM CPU frequency (1GHz)
#define FUARTCLK    48000000U       // default value (https://www.raspberrypi.com/documentation/computers/legacy_config_txt.html#init_uart_clock)
/**
 * @brief function to initialize UART. disables GPIO14 & 15 bc UART Pins.
 * execution according to BCM2835-ARM-Peripherals document.
 *  - gpio: s. 101
 *  - uart: s. 185
 * 
 */
void uart_init(void){
    
    mmio_write(UART0_CR, 0x0);  // disables UART so it can be configured

    mmio_write(GPPUD, 0x0); // disable GPIO Pull-Ups/Downs
    delay(150);

    mmio_write(GPPUDCLK0, (1<<14)|(1<<15)); // select pins 14 & 15
    delay(150);

    mmio_write(GPPUDCLK0, 0x0);

    mmio_write(UART0_ICR, 0x7FF);   // clears all intterupts

    uart_setBaudrate(115200);

    mmio_write(UART0_LCRH, (1<<4)|(1<<5)|(1<<6));    // set to 8bit transmit and enable FIFO transmit buffer

    mmio_write(UART0_IMSC, (1<<1)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9)|(1<<10));   // enabele interruppts

    mmio_write(UART0_CR, (1 << 0) | (1 << 8) | (1 << 9));   // turn UART back on
}

void uart_putc(unsigned char c){
    while(mmio_read(UART0_FR) & (1<<5));
    mmio_write(UART0_DR, c);
}

unsigned char uart_getc(void){
    while(mmio_read(UART0_FR) & (1<<4));
    return mmio_read(UART0_DR);
}

void uart_puts(const char* str){
    for (size_t i = 0; str[i] != '\0'; i++){
        uart_putc((unsigned char)str[i]);
    }
}

void uart_setBaudrate(uint32_t baudrate){
    uint32_t ibrd_val = (uint32_t)(FUARTCLK/(16*baudrate));
    mmio_write(UART0_IBRD, ibrd_val);

    uint32_t fbrd_val;
    float divisor = (FUARTCLK/(16*(float)baudrate));
    divisor -= ibrd_val;
    fbrd_val = (uint32_t)(divisor * 64 + 0.5f);
    mmio_write(UART0_FBRD, fbrd_val);
}
