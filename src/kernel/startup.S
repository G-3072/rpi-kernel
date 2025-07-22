.section ".text.init"
.global _start

_start:
// set stack pointer to 0x8000
    mov sp, #0x8000

// zero out bss section
    ldr r4, =__bss_start
    ldr r5, =__bss_end
    mov r6, #0
    mov r7, #0
    mov r8, #0
    mov r9, #0
    b zeroBSS2

zeroBSS1:
    stmia r4!, {r5-r8}

zeroBSS2:
    cmp r4, r5
    bcc zeroBSS1

// call main function
    ldr r3, =kernel_main
    blx r3

// endless loop
end:
    wfe
    b end


.global delay

delay:
    subs r0, r0, #1     // subtract one from r0 and update ALU Flags
    bne delay         // jump back to start if count != 0
    bx lr               // return to to address stored in Link register