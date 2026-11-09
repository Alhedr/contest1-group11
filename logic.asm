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
    ret
InitBomb ENDP

END