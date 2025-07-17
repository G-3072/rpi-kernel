.section ".text.init"

.global _start

.org 0x8000

_start:
    //set stack pointer to 0x8000
    mov sp, #0x8000

    //clear bss
    ldr r4, =__bss_start
    ldr r5, =__bss_end
    mov r6, #0x0
    b addressCheck

zeroBSSLoop:
    str r6, [r4], #4    // write (word)0x0 from r6 to address in r4 and increment r4 by 4.

addressCheck:
    cmp r4, r5          // compare addresses in r4 and r5 (r4 - r5) and set status flags
    bcc zeroBSSLoop     // if carry flag is cleared (means underflow --> r4 < r5) loop 

    ldr r3, =kernel_main    // load kernel_main function address into r3
    blx r3                  // jump to address in r3

end:
    wfe
    b end