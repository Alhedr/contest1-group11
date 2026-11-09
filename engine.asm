INCLUDE Irvine32.inc
INCLUDE bomb.inc

.data
timeLeftMs DWORD TIME_LIMIT_MS
startTick DWORD ?
msgBomb BYTE "DEFUSE THE BOMB! YOU HAVE 2 MINUTES", 0
msgTimeUp BYTE "BOOM! Time is up.",0

.code
main PROC
	mov edx, OFFSET msgBomb 
	call WriteString
	call Crlf
	INVOKE GetTickCount
	mov startTick, eax
	
	
	GL: ; Game Loop
	INVOKE GetTickCount ; EAX = ms since Windows started
    sub  eax, startTick ; EAX = ms since the game started
    cmp  eax, TIME_LIMIT_MS ; has the time limit passed?
    jae  TimeUp ; yes: game over
    mov  ebx, TIME_LIMIT_MS
    sub  ebx, eax ; EBX = ms left
    mov  timeLeftMs, ebx ; save it
    INVOKE Sleep, TICK_MS ; wait 50 ms
    jmp  GL ; check again
	
	TimeUp:
	mov  edx, OFFSET msgTimeUp
    call WriteString ; time ran out
    call Crlf
    exit


main ENDP
END main
	exit
	
	
main ENDP
END main
