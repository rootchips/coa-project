; SECR/SCSR2033 - COMPUTER ORGANIZATION & ARCHITECTURE
; PROJECT TITLE - CONVERSION BETWEEN INFORMATION SYSTEMS
; GROUP - 4

INCLUDE Irvine32.inc

.data
menuTitle BYTE ">>> Please select the conversion type:", 0
menu1 BYTE "1. Binary to Decimal", 0
menu2 BYTE "2. Decimal to Binary", 0
menu3 BYTE "3. Binary to Hex", 0
menu4 BYTE "4. Binary to BCD", 0
menu5 BYTE "5. Exit", 0
menuLine BYTE "--------------------------------------------------", 0
askChoice BYTE "Enter your choice: ", 0
askBinary BYTE "Please Enter 8-bit binary digits (e.g., 11110000): ", 0
askDecimal BYTE "Please Enter a decimal integer less than 256: ", 0
askHex BYTE "Please Enter 8-bit binary digits for HEX conversion: ", 0
askBCD BYTE "Please Enter 8-bit binary digits for BCD conversion: ", 0
byeMsg BYTE "Bye.", 0

outputLabel1 BYTE "The decimal integer of ", 0
outputLabel4 BYTE "The BCD of ", 0
suffixD BYTE "d", 0
suffixB BYTE "b", 0
suffixBCD BYTE "bcd", 0
isLabel BYTE " is ", 0

binInput BYTE 16 DUP(0)
bcdResult BYTE 64 DUP(0)
number DWORD ?

.code
main PROC
menu:
    call CrLf
    mov edx, OFFSET menuTitle
    call WriteString
    call CrLf
    mov edx, OFFSET menu1
    call WriteString
    call CrLf
    mov edx, OFFSET menu2
    call WriteString
    call CrLf
    mov edx, OFFSET menu3
    call WriteString
    call CrLf
    mov edx, OFFSET menu4
    call WriteString
    call CrLf
    mov edx, OFFSET menu5
    call WriteString
    call CrLf
    mov edx, OFFSET menuLine
    call WriteString
    call CrLf

    mov edx, OFFSET askChoice
    call WriteString
    call ReadInt
    mov ecx, eax

    cmp ecx, 1
    je BinaryToDecimal
    cmp ecx, 4
    je BinaryToBCD
    cmp ecx, 5
    je ExitProgram
    jmp menu

BinaryToDecimal:
validateBinary1:
    call CrLf
    mov edx, OFFSET askBinary
    call WriteString
    mov edx, OFFSET binInput
    call ReadString
    cmp eax, 8
    jne validateBinary1
    mov binInput[eax], 0

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

BinaryToBCD:
validateBinary3:
    call CrLf
    mov edx, OFFSET askBCD
    call WriteString
    mov edx, OFFSET binInput
    call ReadString
    cmp eax, 8
    jne validateBinary3
    mov binInput[eax], 0

    xor eax, eax
    mov esi, OFFSET binInput
bitLoop3:
    mov bl, [esi]
    cmp bl, 0
    je convertToBCD
    shl eax, 1
    cmp bl, '1'
    jne skipInc3
    inc eax
skipInc3:
    inc esi
    jmp bitLoop3

convertToBCD:
    mov number, eax
    call CrLf
    mov edx, OFFSET outputLabel4
    call WriteString
    mov edx, OFFSET binInput
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    mov edx, OFFSET isLabel
    call WriteString

    ; Now print each decimal digit as 4-bit BCD
    mov eax, number
    mov ecx, 100        ; divisor
    mov esi, OFFSET bcdResult

printBCDGroup:
    cmp ecx, 0
    je doneBCD
    xor edx, edx
    div ecx            ; divide eax by ecx
    add al, '0'
    call PrintDigitAsBCD
    mov eax, edx       ; remainder
    cmp ecx, 100
    je mov ecx, 10
    cmp ecx, 10
    je mov ecx, 1
    jmp printBCDGroup

doneBCD:
    mov edx, OFFSET suffixBCD
    call WriteString
    call CrLf
    call CrLf
    jmp menu

PrintDigitAsBCD PROC
    ; AL contains digit char '0' to '9'
    sub al, '0'         ; convert to actual digit 0-9
    mov bl, al
    mov ecx, 4
    mov esi, OFFSET bcdResult

    ; prepare 4-bit string from MSB to LSB
    push eax
    mov edi, 0
print4:
    shl bl, 1
    jc oneBit
    mov BYTE PTR [esi + edi], '0'
    jmp nextBit
oneBit:
    mov BYTE PTR [esi + edi], '1'
nextBit:
    inc edi
    loop print4
    mov BYTE PTR [esi + edi], ' '  ; space
    inc edi
    mov BYTE PTR [esi + edi], 0
    pop eax

    mov edx, OFFSET bcdResult
    call WriteString
    ret
PrintDigitAsBCD ENDP

ExitProgram:
    call CrLf
    mov edx, OFFSET byeMsg
    call WriteString
    call CrLf
    exit

main ENDP
END main
