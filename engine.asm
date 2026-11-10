; engine.asm - Bomb Defusal game: timer, HUD, input
; Yosef Alhedr - Henry Case
INCLUDE Irvine32.inc
INCLUDE bomb.inc

.data
timeLeftMs DWORD TIME_LIMIT_MS ; ms left on the timer
startTick DWORD ? ; GetTickCount value when the game started
msgBomb BYTE "DEFUSE THE BOMB! YOU HAVE 2 MINUTES", 0
msgTimeUp BYTE "BOOM! Time is up.",0
msgTime BYTE "Time left: ",0

.code
main PROC
	mov edx, OFFSET msgBomb 
	call WriteString ; Show the start message
	call Crlf
	INVOKE GetTickCount ; eax is ms since windows started
	mov startTick, eax
	
	
	GL: ; Game Loop
	INVOKE GetTickCount ; EAX = ms since Windows started
    sub  eax, startTick ; EAX = ms since the game started
    cmp  eax, TIME_LIMIT_MS ; has the time limit passed?
    jae  TimeUp ; yes: game over
    mov  ebx, TIME_LIMIT_MS
    sub  ebx, eax ; EBX = ms left
    mov  timeLeftMs, ebx ; save it
    
	mov dh, 2 ; Row 2
	mov dl, 0 ; Column 0
	call Gotoxy ; Moving the cursor there
	mov edx, OFFSET msgTime
	call WriteString ; "Time left: "
	mov eax, timeLeftMs
	mov edx, 0 ; Clear EDX before the division
	mov ecx, 1000
	div ecx ; Seconds left
	call WriteDec 
	mov al, ' ' 
	call WriteChar ; now instead of printing 990 after 100, it prints 99 after 100
	
	
	INVOKE Sleep, TICK_MS ; wait 50 ms
    jmp  GL ; check again
	
	TimeUp:
	call Crlf
	mov  edx, OFFSET msgTimeUp
    call WriteString ; time ran out
	call Crlf
    
    exit


main ENDP
END main
