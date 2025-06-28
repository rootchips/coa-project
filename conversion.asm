; SECR/SCSR2033 - COMPUTER ORGANIZATION & ARCHITECTURE
; PROJECT TITLE - CONVERSION BETWEEN INFORMATION SYSTEMS
; GROUP - 4

INCLUDE Irvine32.inc  ; Include Irvine32 library for input/output functions

.data
; Menu and prompt messages
menuTitle BYTE ">>> Please select the conversion type:", 0
menu1 BYTE "1. Binary to Decimal", 0
menu2 BYTE "2. Decimal to Binary", 0
menu3 BYTE "3. Binary to Hex", 0
menu4 BYTE "4. Binary to BCD", 0
menu5 BYTE "5. Exit", 0
menuLine BYTE "--------------------------------------------------", 0
askChoice BYTE "\nEnter your choice: ", 0
askBinary BYTE "Please Enter 8-bit binary digits (e.g., 11110000): ", 0
askDecimal BYTE "Please Enter a decimal integer less than 256: ", 0
askHex BYTE "Please Enter 8-bit binary digits for HEX conversion: ", 0
askBCD BYTE "Please Enter 8-bit binary digits for BCD conversion: ", 0
byeMsg BYTE "Bye.", 0

; Output labels
outputLabel1 BYTE "The decimal integer of ", 0
outputLabel2 BYTE "The binary of ", 0
outputLabel3 BYTE "The hexadecimal of ", 0
outputLabel4 BYTE "The BCD of ", 0
suffixB BYTE "b is ", 0
suffixD BYTE "d", 0
suffixH BYTE "h", 0

; Buffers and variables
binInput BYTE 9 DUP(0)     ; Buffer to store binary input string
resultStr BYTE 16 DUP(0)   ; Buffer to store binary output string
number DWORD ?             ; Variable to store numeric result

.code
main PROC

menu:
    call Clrscr                    ; Clear the screen
    mov edx, OFFSET menuLine       ; Display menu border
    call WriteString
    call CrLf
    mov edx, OFFSET menuTitle      ; Display menu title
    call WriteString
    call CrLf
    mov edx, OFFSET menu1          ; Display option 1
    call WriteString
    call CrLf
    mov edx, OFFSET menu2          ; Display option 2
    call WriteString
    call CrLf
    mov edx, OFFSET menu3          ; Display option 3
    call WriteString
    call CrLf
    mov edx, OFFSET menu4          ; Display option 4
    call WriteString
    call CrLf
    mov edx, OFFSET menu5          ; Display option 5
    call WriteString
    call CrLf
    mov edx, OFFSET menuLine       ; Display menu border again
    call WriteString
    call CrLf

    mov edx, OFFSET askChoice      ; Ask user for menu choice
    call WriteString
    call ReadInt                   ; Read user input as integer
    mov ecx, eax                   ; Store choice in ECX

    ; Branch to selected function
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
    jmp menu                       ; If invalid, show menu again


; Function 1: Binary to Decimal

BinaryToDecimal:
    call CrLf
    mov edx, OFFSET askBinary      ; Prompt for binary input
    call WriteString
    mov edx, OFFSET binInput
    call ReadString                ; Read binary string

    xor eax, eax                   ; Clear EAX for result
    mov esi, OFFSET binInput       ; Point to input string
bitLoop1:
    mov bl, [esi]                  ; Read character
    cmp bl, 0
    je showDecimal                 ; End of string
    shl eax, 1                     ; Shift left (multiply by 2)
    cmp bl, '1'
    jne skipInc1
    inc eax                        ; Add 1 if bit is '1'
skipInc1:
    inc esi
    jmp bitLoop1
showDecimal:
    mov number, eax                ; Store result
    call CrLf
    mov edx, OFFSET outputLabel1   ; Display result label
    call WriteString
    mov edx, OFFSET binInput       ; Show input
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    mov eax, number                ; Show decimal result
    call WriteDec
    mov edx, OFFSET suffixD
    call WriteString
    call CrLf
    call WaitMsg
    jmp menu

; Function 2: Decimal to Binary

DecimalToBinary:
    call CrLf
    mov edx, OFFSET askDecimal     ; Prompt for decimal input
    call WriteString
    call ReadInt                   ; Read decimal number
    mov ecx, eax
    mov number, eax                ; Store input

    mov edi, OFFSET resultStr
    add edi, 8                     ; Point to end of buffer
    mov BYTE PTR [edi], 0         ; Null-terminate
    dec edi
    mov eax, ecx
binaryLoop:
    and eax, 1                     ; Get lowest bit
    add al, '0'                    ; Convert to ASCII
    mov [edi], al
    dec edi
    shr ecx, 1                     ; Shift right
    cmp ecx, 0
    jne binaryLoop
    inc edi                        ; Point to start of result

    call CrLf
    mov edx, OFFSET outputLabel2   ; Display result label
    call WriteString
    mov eax, number
    call WriteDec                  ; Show decimal input
    mov edx, OFFSET suffixD
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    mov edx, edi                   ; Show binary result
    call WriteString
    call CrLf
    call WaitMsg
    jmp menu

; Function 3: Binary to Hexadecimal

BinaryToHex:
    call CrLf
    mov edx, OFFSET askHex         ; Prompt for binary input
    call WriteString
    mov edx, OFFSET binInput
    call ReadString

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
    call CrLf
    mov edx, OFFSET outputLabel3   ; Display result label
    call WriteString
    mov edx, OFFSET binInput
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    call WriteHex                  ; Show hexadecimal result
    mov edx, OFFSET suffixH
    call WriteString
    call CrLf
    call WaitMsg
    jmp menu

; Function 4: Binary to BCD

BinaryToBCD:
    call CrLf
    mov edx, OFFSET askBCD         ; Prompt for binary input
    call WriteString
    mov edx, OFFSET binInput
    call ReadString

    xor eax, eax
    mov esi, OFFSET binInput
bitLoop3:
    mov bl, [esi]
    cmp bl, 0
    je showBCD
    shl eax, 1
    cmp bl, '1'
    jne skipInc3
    inc eax
skipInc3:
    inc esi
    jmp bitLoop3
showBCD:
    call CrLf
    mov edx, OFFSET outputLabel4   ; Display result label
    call WriteString
    mov edx, OFFSET binInput
    call WriteString
    mov edx, OFFSET suffixB
    call WriteString
    call WriteBCD                  ; Show BCD result
    call CrLf
    call WaitMsg
    jmp menu

; Function 5: Exit Program

ExitProgram:
    call CrLf
    mov edx, OFFSET byeMsg         ; Display goodbye message
    call WriteString
    call CrLf
    exit                           ; Terminate program

main ENDP
END main
