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
; EvalRules: Evaluates colors and bombCode to set targetWire
;-----------------------------------------------------
EvalRules PROC USES eax ebx edx ; Saves and restores eax, ebx, edx on stack
    call CountColors ; AL=Red, AH=Blue, BL=Green, BH=Yellow
    ; Rule 1: >1 red and bombCode is odd -> cut wire 1 (second wire)
    cmp al, 1
    jbe CheckRule2
    test bombCode, 1
    jz  CheckRule2
    mov targetWire, 1
    ret
CheckRule2: ; Rule 2: Last wire is yellow and no blue -> cut wire 0
    cmp wireColors[3], WIRE_YELLOW
    jne CheckRule3
    cmp ah, 0
    jne CheckRule3
    mov targetWire, 0
    ret
CheckRule3: ; Fallback default: cut wire 3 (the last wire)
    mov targetWire, 3
    ret
EvalRules ENDP

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
    call EvalRules ; Determine which wire is safe based on the rules
    ret
InitBomb ENDP

;-----------------------------------------------------
; CutWire: wireNum:DWORD (0-based)
; Returns EAX: RESULT_OK, RESULT_STRIKE, RESULT_INVALID
;-----------------------------------------------------
CutWire PROC USES esi, wireNum:DWORD ; Saves and restores esi on stack and takes wireNum as input
    mov esi, wireNum
    movzx eax, wireCount
    cmp esi, eax
    jae InvalidCut ; Out of bounds
    cmp wireCut[esi], 1
    je  InvalidCut ; Already cut
    mov wireCut[esi], 1 ; Mark severed

    mov eax, targetWire
    cmp esi, eax ; Compare cut wire with target wire
    jne WrongWire ; Wrong wire cut
    mov eax, RESULT_OK ; Correct wire cut
    ret
WrongWire:
    inc strikes
    mov eax, RESULT_STRIKE
    ret
InvalidCut:
    mov eax, RESULT_INVALID
    ret
CutWire ENDP

END