MEMORY
{
    RAM (rwx)   :   ORIGIN = 0x00000000, LENGTH = 448M
}

ENTRY(_start)

SECTIONS
{
    . = 0x8000;
    __start = .;
    __text_start = .;
    .text :
    {
        KEEP(*(.text.init));
        *(.text)
    }
    . = ALIGN(4096);
    text_end = .;

    __rodata_start = .;
    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096);
    __rodata_end = .;

    __data_start = .;
    .data :
    {
        *(.data)
    }
    . = ALIGN(4096);
    __data_end = .;

    __bss_start = .;
    .bss :
    {
        *(.bss)
    }
    . = ALIGN(4096);
    __bss_end = .;
    __end = .;
}