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