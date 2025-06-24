BinaryToDecimal:
    call CrLf
    mov edx, OFFSET askBinary
    call WriteString
    mov edx, OFFSET binInput
    call ReadString

    xor eax, eax
    mov esi, OFFSET binInput
bitLoop1:
    mov bl, [esi]
    cmp bl, 0
    je showDecimal
    shl eax, 1
    cmp bl, '1'
    jne skipInc1
    inc eax
skipInc1:
    inc esi
    jmp bitLoop1
showDecimal:
    mov number, eax
    call CrLf
    mov edx, OFFSET outputLabel1
    call WriteString
    mov edx, OFFSET binInput
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    mov edx, OFFSET isLabel
    call WriteString
    mov eax, number
    call WriteDec
    mov edx, OFFSET suffixD
    call WriteString
    call CrLf
    call CrLf
    jmp menu
