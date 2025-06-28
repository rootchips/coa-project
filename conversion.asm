INCLUDE Irvine32.inc

.data
menuTitle BYTE ">>> Please select the conversion type:", 0
menu1 BYTE "1. Binary to Decimal", 0
menu2 BYTE "2. Decimal to Binary", 0
menu3 BYTE "3. Binary to Hex", 0
menu4 BYTE "4. Decimal to Hex", 0
menu5 BYTE "5. Exit", 0
menuLine BYTE "--------------------------------------------------", 0
askChoice BYTE "Enter your choice: ", 0
askBinary BYTE "Please Enter 8-bit binary digits (e.g., 11110000): ", 0
askDecimal BYTE "Please Enter a decimal integer less than 256: ", 0
askHex BYTE "Please Enter 8-bit binary digits for HEX conversion: ", 0
askDecToHex BYTE "Please Enter a decimal integer less than 256 for HEX conversion: ", 0

byeMsg BYTE "Bye.", 0

outputLabel1 BYTE "The decimal integer of ", 0
outputLabel2 BYTE "The binary of ", 0
outputLabel3 BYTE "The hexadecimal of ", 0
outputLabel4 BYTE "The hexadecimal of ", 0
suffixD BYTE "d", 0
suffixB BYTE "b", 0
suffixH BYTE "h", 0
isLabel BYTE " is ", 0

invalidInput BYTE "Invalid input. Please enter a number between 1 and 5.", 0

binInput BYTE 16 DUP(0)
resultStr BYTE 16 DUP(0)
number DWORD ?

.code
main PROC
    call DisplayMenu

menu:
    mov edx, OFFSET askChoice
    call WriteString
    call ReadInt
    cmp eax, 1
    jl invalidMenu
    cmp eax, 5
    jg invalidMenu
    jmp processChoice

invalidMenu:
    mov edx, OFFSET invalidInput
    call WriteString
    call CrLf
    jmp menu

processChoice:
    mov ecx, eax
    cmp ecx, 1
    je BinaryToDecimal
    cmp ecx, 2
    je DecimalToBinary
    cmp ecx, 3
    je BinaryToHex
    cmp ecx, 4
    je DecimalToHex
    cmp ecx, 5
    je ExitProgram
    jmp menu

DisplayMenu PROC
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
    ret
DisplayMenu ENDP

; ====== Binary to Decimal ======
BinaryToDecimal:
    call CrLf
    mov edx, OFFSET askBinary
    call WriteString
    mov edx, OFFSET binInput
    mov ecx, SIZEOF binInput
    call ReadString
    cmp eax, 8
    jne BinaryToDecimal
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
    call WaitMsg         ; Wait for key press
    call Clrscr          ; Clear screen after showing results
    call DisplayMenu
    jmp menu

; ====== Decimal to Binary ======
DecimalToBinary:
    call CrLf
    mov edx, OFFSET askDecimal
    call WriteString
    call ReadInt
    cmp eax, 0
    jl DecimalToBinary
    cmp eax, 255
    jg DecimalToBinary
    mov number, eax
    mov ecx, eax

    mov edi, OFFSET resultStr + 8
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
    call WaitMsg         ; Wait for key press
    call Clrscr          ; Clear screen after showing results
    call DisplayMenu
    jmp menu

; ====== Binary to Hex ======
BinaryToHex:
    call CrLf
    mov edx, OFFSET askHex
    call WriteString
    mov edx, OFFSET binInput
    mov ecx, SIZEOF binInput
    call ReadString
    cmp eax, 8
    jne BinaryToHex
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
    call WaitMsg         ; Wait for key press
    call Clrscr          ; Clear screen after showing results
    call DisplayMenu
    jmp menu

; ====== Decimal to Hex ======
DecimalToHex:
    call CrLf
    mov edx, OFFSET askDecToHex
    call WriteString
    call ReadInt
    cmp eax, 0
    jl DecimalToHex
    cmp eax, 255
    jg DecimalToHex
    mov number, eax

    call CrLf
    mov edx, OFFSET outputLabel4
    call WriteString
    mov eax, number
    call WriteDec
    mov edx, OFFSET suffixD
    call WriteString
    mov edx, OFFSET isLabel
    call WriteString
    mov eax, number
    call WriteHexB
    mov edx, OFFSET suffixH
    call WriteString
    call CrLf
    call WaitMsg         ; Wait for key press
    call Clrscr          ; Clear screen after showing results
    call DisplayMenu
    jmp menu

; ====== Exit Program ======
ExitProgram:
    call CrLf
    mov edx, OFFSET byeMsg
    call WriteString
    call CrLf
    exit

main ENDP
END main
