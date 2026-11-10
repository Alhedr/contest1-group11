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
msgHint BYTE "Cut the correct wire, then enter the PIN. Rules: MANUAL.md", 0
msgCode BYTE "Bomb code: ",0
msgStrikes BYTE "Strikes: ",0
msgOutOf BYTE "/3",0
msgKeys BYTE "Press 1-4 to cut a wire",0
msgBoom3 BYTE "BOOM! THREE STRIKES!!!",0

; Wires:
msgWire BYTE "Wire ",0
msgColon BYTE ": ",0
nameRed BYTE "red",0
nameBlue BYTE "blue",0
nameGreen BYTE "green",0
nameYellow BYTE "yellow",0
namePtrs DWORD nameRed, nameBlue, nameGreen, nameYellow ; we put the same order as WIRE_RED..etc
wireAttr BYTE lightRed, lightBlue, lightGreen, yellow ; screen color to draw each wire color

.code
main PROC
	mov edx, OFFSET msgBomb 
	call WriteString ; Show the start message
	call Crlf
	mov edx, OFFSET msgHint
	call WriteString
	call Crlf
	call Randomize ; seed the random numbers once
	INVOKE InitBomb ; logic.asm: random wires and codes
	mov dh, 8 ; Row 8
	mov dl, 0 ; column 0
	call Gotoxy
	mov edx, OFFSET msgCode
	call WriteString ; "Bomb code: "
	movzx eax,  bombCode ; from logic.asm
	mov ebx, 2 ; 2 bytes = 4 hex digits
	call WriteHexB
	mov dh, 9 ; row 9
	mov dl, 0 
	call Gotoxy
	mov edx, OFFSET msgKeys
	call WriteString
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
	call DrawStrikes ; Strikes: n/3
	call DrawWires ; show the 4 wired under the timer
	call ReadKey ; check the keyboard without waiting
	jz NoKey 
	cmp al, '1'
	jb NoKey ; not a wire number
	cmp al, '4'
	ja NoKey ; not a wire number
	sub al, '1' ; 1-4. --> 0-3
	movzx eax, al
	INVOKE CutWire, eax
	cmp eax, RESULT_STRIKE
	jne NoKey ; not strike? nothing
	cmp strikes, MAX_STRIKES
	jae Exploded
NoKey:
	INVOKE Sleep, TICK_MS ; wait 50 ms
    jmp  GL ; check again
	
	Exploded:
		call DrawStrikes ; show 3/3
		mov edx, OFFSET msgBoom3
		jmp EndGame
		
	TimeUp:
		mov edx, OFFSET msgTimeUp
	
	EndGame: 
		push edx ; keep the msg addrs
		mov dh, 12 ; Row 12
		mov dl, 0
		call Gotoxy
		pop edx 
		call WriteString
		call Crlf
		
    
		exit


main ENDP
DrawWires PROC USES eax ebx edx esi
	mov esi, 0
DrawL: ; Draw Loop 
	mov eax, esi
	add al, 4 ; row = 4 + wire
	mov dh, al
	mov dl , 0 ; column 0
	call Gotoxy
	mov eax, lightGray 
	call SetTextColor ; a color for wire x
	mov edx, OFFSET msgWire
	call WriteString ; "Wire "
	mov eax, esi
	inc eax ; so the player sees 1-4 wires
	call WriteDec
	mov edx, OFFSET msgColon
	call WriteString
	movzx ebx, wireColors[esi] ; The color id
	movzx eax, wireAttr[ebx] ; screen color for x wire
	call SetTextColor
	mov edx, namePtrs [ebx*TYPE namePtrs] ; edx is the address of the color name
	call WriteString ; colors 
	mov eax, lightGray ; goes back to the normal color
	call SetTextColor
	inc esi ; next wire 
	cmp esi, MAX_WIRES
	jb DrawL
	ret
DrawWires ENDP
DrawStrikes PROC USES eax edx
	mov dh, 3 ; row 3
	mov dl, 0
	call Gotoxy
	mov edx, OFFSET msgStrikes
	call WriteString
	movzx eax, strikes
	call WriteDec
	mov edx, OFFSET msgOutOf
	call WriteString
	ret
DrawStrikes ENDP
	
	
	
END main
