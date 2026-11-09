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

END