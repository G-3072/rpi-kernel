#ifndef PERIPHERALS_H
#define PERIPHERALS_H

#include <stdint.h>

enum Peripherals
{
    // Base address of Peripherals in address space
    PERIPHERAL_BASE = 0x20000000U,
    // peripheral offsets
    GPIO_OFFSET = 0x200000U,
    UART0_OFFSET = 0x201000U,
    // periphaeral base addresses
    GPIO_BASE = (PERIPHERAL_BASE + GPIO_OFFSET),
    UART0_BASE = (PERIPHERAL_BASE + UART0_OFFSET),

};

enum UART
{
    UART0_DR        = (UART0_BASE + 0x00),
    UART0_RSRECR    = (UART0_BASE + 0x04),
    UART0_FR        = (UART0_BASE + 0x18),
    UART0_ILRP      = (UART0_BASE + 0x20),
    UART0_IBRD      = (UART0_BASE + 0x24),
    UART0_FBRD      = (UART0_BASE + 0x28),
    UART0_LCRH      = (UART0_BASE + 0x2c),
    UART0_CR        = (UART0_BASE + 0x30),
    UART0_IFLS      = (UART0_BASE + 0x34),
    UART0_IMSC      = (UART0_BASE + 0x38),
    UART0_RIS       = (UART0_BASE + 0x3c),
    UART0_MIS       = (UART0_BASE + 0x40),
    UART0_ICR       = (UART0_BASE + 0x44),
    UART0_DMACR     = (UART0_BASE + 0x48),
    UART0_ITCR      = (UART0_BASE + 0x80),
    UART0_ITIP      = (UART0_BASE + 0x84),
    UART0_ITOP      = (UART0_BASE + 0x88),
    UART0_TDR       = (UART0_BASE + 0x8c),
};

enum GPIO
{
    GPPUD       = (GPIO_BASE + 0x94),
    GPPUDCLK0   = (GPIO_BASE + 0x98),
};

#endif