#ifndef UART_H
#define UART_H

#include <stddef.h>

#include <peripherals.h>

void uart_init(void);
void uart_putc(unsigned char c);
unsigned char uart_getc(void);
void uart_puts(const char* str);

#endif