    .section .text
    .global _start
_start:
    addi x1, x0, 50
    lw x2, -4(x0)
    sub x3, x1, x2
    sw x3, -4(x0)
    beq x0, x0, 0