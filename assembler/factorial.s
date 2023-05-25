; Calculates the factorial of a number stored in register x1
li x2, 1          ; Initialize x2 to 1 (factorial result)
Loop:
beq x1, x0, End   ; Exit loop if x1 is 0
mul x2, x2, x1    ; Multiply x2 by x1
addi x1, x1, -1   ; Decrement x1 by 1
j Loop            ; Jump back to the Loop label
End:
; Factorial result is stored in register x2
