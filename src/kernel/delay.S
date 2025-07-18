
// basic delay function count passed in r0
.global delay

delay:
    subs r0, r0, #1     // subtract one from r0 and update ALU Flags
    bne delay         // jump back to start if count != 0
    bx lr               // return to to address stored in Link register