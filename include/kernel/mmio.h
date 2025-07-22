#ifndef MMIO_H
#define MMIO_H

#include <stddef.h>
#include <stdint.h>

extern void delay(uint32_t count);

void mmio_write(uint32_t reg, uint32_t data);
uint32_t mmio_read(uint32_t reg);

enum system
{
    F_CORE  = 400000000U,       // default BCM2835 Clock speed (400MHz)
    F_CPU   = 1000000000U,      // default ARM CPU frequency (1GHz)
    FUARTCLK = 48000000U,       // default value (https://www.raspberrypi.com/documentation/computers/legacy_config_txt.html#init_uart_clock)
};

enum Peripherals
{
    // Base address of Peripherals in address space
    PERIPHERAL_BASE = 0x20000000U,
    // peripheral offsets
    GPIO_OFFSET = 0x200000U,
    UART_OFFSET = 0x201000U,
    AUX_OFFSET  = 0x215000U,
    // periphaeral base addresses
    GPIO_BASE   = (PERIPHERAL_BASE + GPIO_OFFSET),
    UART_BASE   = (PERIPHERAL_BASE + UART_OFFSET),
    AUX_BASE    = (PERIPHERAL_BASE + AUX_OFFSET),

};

enum UART
{
    UART_DR        = (UART_BASE + 0x00),
    UART_RSRECR    = (UART_BASE + 0x04),
    UART_FR        = (UART_BASE + 0x18),
    UART_ILRP      = (UART_BASE + 0x20),
    UART_IBRD      = (UART_BASE + 0x24),
    UART_FBRD      = (UART_BASE + 0x28),
    UART_LCRH      = (UART_BASE + 0x2c),
    UART_CR        = (UART_BASE + 0x30),
    UART_IFLS      = (UART_BASE + 0x34),
    UART_IMSC      = (UART_BASE + 0x38),
    UART_RIS       = (UART_BASE + 0x3c),
    UART_MIS       = (UART_BASE + 0x40),
    UART_ICR       = (UART_BASE + 0x44),
    UART_DMACR     = (UART_BASE + 0x48),
    UART_ITCR      = (UART_BASE + 0x80),
    UART_ITIP      = (UART_BASE + 0x84),
    UART_ITOP      = (UART_BASE + 0x88),
    UART_TDR       = (UART_BASE + 0x8c),
};

enum Auxiliaries
{
    AUX_IRQ         = (AUX_BASE + 0x00),
    AUX_ENABLES     = (AUX_BASE + 0x04),
    AUX_MU_IO       = (AUX_BASE + 0x40),
    AUX_MU_IER      = (AUX_BASE + 0x44),
    AUX_MU_IIR      = (AUX_BASE + 0x48),
    AUX_MU_LCR      = (AUX_BASE + 0x4c),
    AUX_MU_MCR      = (AUX_BASE + 0x50),
    AUX_MU_LSR      = (AUX_BASE + 0x54),
    AUX_MU_MSR      = (AUX_BASE + 0x58),
    AUX_SCRATCH     = (AUX_BASE + 0x5c),
    AUX_MU_CNTL     = (AUX_BASE + 0x60),
    AUX_MU_STAT     = (AUX_BASE + 0x64),
    AUX_MU_BAUD     = (AUX_BASE + 0x68),

    AUX_SPI0_CNTL0  = (AUX_BASE + 0x80),
    AUX_SPI0_CNTL1  = (AUX_BASE + 0x84),
    AUX_SPI0_STAT   = (AUX_BASE + 0x88),
    AUX_SPI0_IO     = (AUX_BASE + 0x90),
    AUX_SPI0_PEEK   = (AUX_BASE + 0x94),

    AUX_SPI1_CNTL0  = (AUX_BASE + 0xc0),
    AUX_SPI1_CNTL1  = (AUX_BASE + 0xc4),
    AUX_SPI1_STAT   = (AUX_BASE + 0xc8),
    AUX_SPI1_IO     = (AUX_BASE + 0xd0),
    AUX_SPI1_PEEK   = (AUX_BASE + 0xd4),
};



enum GPIO
{
    GPFSEL0     = (GPIO_BASE + 0x00),
    GPFSEL1     = (GPIO_BASE + 0x04),
    GPFSEL2     = (GPIO_BASE + 0x08),
    GPFSEL3     = (GPIO_BASE + 0x0c),
    GPFSEL4     = (GPIO_BASE + 0x10),
    GPFSEL5     = (GPIO_BASE + 0x14),

    GPPUD       = (GPIO_BASE + 0x94),
    GPPUDCLK0   = (GPIO_BASE + 0x98),

};

#endif