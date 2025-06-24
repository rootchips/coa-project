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
outputLabel2 BYTE "The binary of ", 0
outputLabel3 BYTE "The hexadecimal of ", 0
outputLabel4 BYTE "The BCD of ", 0
suffixD BYTE "d", 0
suffixB BYTE "b", 0
suffixH BYTE "h", 0
suffixBCD BYTE "bcd", 0
isLabel BYTE " is ", 0

binInput BYTE 16 DUP(0)
resultStr BYTE 16 DUP(0)
bcdStr BYTE 64 DUP(0)
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
    cmp ecx, 2
    je DecimalToBinary
    cmp ecx, 3
    je BinaryToHex
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
    mov ecx, SIZEOF binInput
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

DecimalToBinary:
validateDecimal:
    call CrLf
    mov edx, OFFSET askDecimal
    call WriteString
    call ReadInt
    cmp eax, 0
    jl validateDecimal
    cmp eax, 255
    jg validateDecimal
    mov number, eax
    mov ecx, eax

    mov edi, OFFSET resultStr
    add edi, 8
    mov BYTE PTR [edi], 0
    dec edi

binaryLoop:
    mov eax, ecx
    and eax, 1
    add al, '0'
    mov [edi], al
    dec edi
    shr ecx, 1
    cmp ecx, 0
    jne binaryLoop
    inc edi

    call CrLf
    mov edx, OFFSET outputLabel2
    call WriteString
    mov eax, number
    call WriteDec
    mov edx, OFFSET suffixD
    call WriteString
    mov edx, OFFSET isLabel
    call WriteString
    mov edx, edi
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    call CrLf
    call CrLf
    jmp menu

BinaryToHex:
validateBinary2:
    call CrLf
    mov edx, OFFSET askHex
    call WriteString
    mov edx, OFFSET binInput
    mov ecx, SIZEOF binInput
    call ReadString
    cmp eax, 8
    jne validateBinary2
    mov binInput[eax], 0

    xor eax, eax
    mov esi, OFFSET binInput
bitLoop2:
    mov bl, [esi]
    cmp bl, 0
    je showHex
    shl eax, 1
    cmp bl, '1'
    jne skipInc2
    inc eax
skipInc2:
    inc esi
    jmp bitLoop2
showHex:
    mov number, eax
    call CrLf
    mov edx, OFFSET outputLabel3
    call WriteString
    mov edx, OFFSET binInput
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    mov edx, OFFSET isLabel
    call WriteString
    mov eax, number
    call WriteHexB
    mov edx, OFFSET suffixH
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
    mov ecx, SIZEOF binInput
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
    mov ecx, number
    mov edi, OFFSET bcdStr
    add edi, 63
    mov BYTE PTR [edi], 0
    dec edi

digitToBCD:
    xor edx, edx
    mov eax, ecx
    mov ebx, 10
    div ebx
    mov ecx, eax
    mov al, dl
    mov ah, 0
    add al, '0'
    sub al, '0'
    movzx eax, al
    mov ebx, 4
    mov esi, edi
    add esi, -4
    mov edi, esi
    mov ecx, 4
generateBits:
    shl eax, 1
    jc bitIs1
    mov BYTE PTR [esi], '0'
    jmp nextBit
bitIs1:
    mov BYTE PTR [esi], '1'
nextBit:
    inc esi
    loop generateBits
    dec edi
    cmp ecx, 0
    jne digitToBCD

outputBCD:
    call CrLf
    mov edx, OFFSET outputLabel4
    call WriteString
    mov edx, OFFSET binInput
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    mov edx, OFFSET isLabel
    call WriteString
    mov esi, edi
    inc esi
printLoop:
    mov al, [esi]
    cmp al, 0
    je doneBCD
    call WriteChar
    inc esi
    mov al, [esi]
    cmp al, 0
    je doneBCD
    call WriteChar
    inc esi
    mov al, [esi]
    cmp al, 0
    je doneBCD
    call WriteChar
    inc esi
    mov al, [esi]
    cmp al, 0
    je doneBCD
    call WriteChar
    mov al, ' '
    call WriteChar
    inc esi
    jmp printLoop

doneBCD:
    mov edx, OFFSET suffixBCD
    call WriteString
    call CrLf
    call CrLf
    jmp menu

ExitProgram:
    call CrLf
    mov edx, OFFSET byeMsg
    call WriteString
    call CrLf
    exit

main ENDP
END main
