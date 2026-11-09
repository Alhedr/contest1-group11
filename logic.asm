INCLUDE Irvine32.inc
INCLUDE bomb.inc

.data
; Shared variables exported via EXTERNDEF in bomb.inc
wireCount   BYTE ?
wireColors  BYTE  MAX_WIRES DUP(?)
wireCut     BYTE  MAX_WIRES DUP(?)
bombCode    WORD ?
strikes     BYTE ?
rulesText   BYTE  "DEFUSAL MANUAL: CUT CORRECT WIRE, ENTER PIN", 0

; Internal target tracker for logic checks
targetWire  DWORD ?

.code

;-----------------------------------------------------
; CountColors: Tallies color frequencies in wireColors
; Returns: AL = Red, AH = Blue, BL = Green, BH = Yellow
;-----------------------------------------------------
CountColors PROC USES ecx esi edx ; saves and restores ecx, esi, edx on stack
    xor eax, eax ; AL = Red (0), AH = Blue (0)
    xor ebx, ebx ; BL = Green (0), BH = Yellow (0)
    movzx ecx, wireCount ; zero-extend wireCount into ecx
    xor esi, esi
CountLp:
    mov dl, wireColors[esi]
    cmp dl, WIRE_RED
    je  IncRed
    cmp dl, WIRE_BLUE
    je  IncBlue
    cmp dl, WIRE_GREEN
    je  IncGreen
    inc bh ; Fallthrough: must be WIRE_YELLOW
    jmp NextWire
IncRed:   inc al
    jmp NextWire
IncBlue:  inc ah
    jmp NextWire
IncGreen: inc bl
NextWire:
    inc esi
    loop CountLp ; Repeat for all wires
    ret
CountColors ENDP

;-----------------------------------------------------
; GenBombAttributes: Random 16-bit code & colors 0-3
;-----------------------------------------------------
GenBombAttributes PROC
    mov eax, 10000h ; Range: 0 to 65535
    call RandomRange
    mov bombCode, ax

    mov ecx, MAX_WIRES
    xor esi, esi
GenColorLoop:
    mov eax, NUM_COLORS ; Range: 0 to 3
    call RandomRange
    mov wireColors[esi], al
    inc esi
    loop GenColorLoop ; Repeat for all wires
    ret
GenBombAttributes ENDP

;-----------------------------------------------------
; InitBomb: Resets strikes and wire arrays
;-----------------------------------------------------
InitBomb PROC
    mov strikes, 0 ; Reset strikes to 0
    mov wireCount, MAX_WIRES ; Set wire count to maximum

    ; Clear wireCut array (0 = uncut)
    mov ecx, MAX_WIRES
    xor esi, esi
ClearCutLoop:
    mov wireCut[esi], 0 ; Mark wire as uncut
    inc esi
    loop ClearCutLoop ; Repeat for all wires

    call GenBombAttributes ; Generate random bomb code and wire colors
    ret
InitBomb ENDP

END