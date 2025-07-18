#ifndef PERIPHERALS_H
#define PERIPHERALS_H

#include <stdint.h>

enum Peripherals
{
    // Base address of Peripherals in address space
    PERIPHERAL_BASE = 0x20000000U,
    // peripheral offsets
    GPIO_OFFSET = 0x200000U,
    UART_OFFSET = 0x201000U,
    // periphaeral base addresses
    GPIO_BASE = (PERIPHERAL_BASE + GPIO_OFFSET),
    UART_BASE = (PERIPHERAL_BASE + UART_OFFSET),

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

enum MUART
{
    MUART_ = 0,
};

enum GPIO
{
    GPPUD       = (GPIO_BASE + 0x94),
    GPPUDCLK0   = (GPIO_BASE + 0x98),
};

#endif