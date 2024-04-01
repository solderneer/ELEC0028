    .section .text
    .global _start
_start:
    # Load immediate values into registers
    lui x2, 0x10000 # Load upper immediate into x2
    addi x2, x2, 1 # Add 10 to x2, resulting in 0x10000001
    sw x2, -4(x0) # Store result (expect 0x10000001) to CPUOut

    # A few more useful values
    addi x3, x0, 20 # Load 20 into x3
    addi x4, x0, 10 # Load 10 into x4
    addi x5, x0, -5 # Load -5 into x4

    # Perform some arithmetic
    add x6, x3, x4 # x6 = x3 + x4
    sw x6, -4(x0) # Store result (expect 30) to CPUOut
    sub x6, x3, x5 # x6 = x3 - x5
    sw x6, -4(x0) # Store result (expect 25) to CPUOut
    or x6, x3, x4 # x6 = x3 | x4
    sw x6, -4(x0) # Store result (expect 30, 0b11110) to CPUOut
    and x6, x3, x4 # x6 = x3 & x4
    sw x6, -4(x0) # Store result (expect 0, 0b00000) to CPUOut
    slt x6, x3, x4 # x6 = (x3 < x4) ? 1 : 0
    sw x6, -4(x0) # Store result (expect 0) to CPUOut
    slt x6, x4, x3 # x6 = (x4 < x3) ? 1 : 0
    sw x6, -4(x0) # Store result (expect 1) to CPUOut

    # Perform remaining immediate operations
    ori x6, x3, 10 # x6 = x3 | 0x01010
    sw x6, -4(x0) # Store result (expect 30, 0b11110) to CPUOut
    andi x6, x3, 10 # x6 = x3 & 0x01010
    sw x6, -4(x0) # Store result (expect 0, 0b00000) to CPUOut

    # Load value from CPUOut
    lw x6, -4(x0) # Load value from CPUIn
    sw x6, -4(x0) # Store result (expect CPUIn) to CPUOut

    # Branching
    addi x6, x0, 20 # x6 = 20
    beq x6, x0, 8 # Expect it to not branch
    sw x6, -4(x0) # Store result (expect 20) to CPUOut
    beq x6, x6, 8 # Expect it to branch
    sw x0, -4(x0) # Store result (do not! expect 0) to CPUOut

    # jumping
    jal x1, 8 # Jump and skip store
    sw x0, -4(x0) # Store result (do not! expect 0) to CPUOut
    sw x1, -4(x0) # Store result (expect PC @ line 46) to CPUOut, check if linked properly
    jalr x1, 16(x1) # Jump and skip store
    sw x0, -4(x0) # Store result (do not! expect 0) to CPUOut
    sw x1, -4(x0) # Store result (expect PC @ line 49) to CPUOut, check if linked properly

    beq x0, x0, 0 # loop
