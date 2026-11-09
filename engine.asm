INCLUDE Irvine32.inc
INCLUDE bomb.inc

.data
timeLeftMs DWORD TIME_LIMIT_MS
startTick DWORD ?
msgBomb BYTE "DEFUSE THE BOMB! YOU HAVE 2 MINUTES", 0

.code
main PROC
	mov edx, OFFSET msgBomb 
	call WriteString
	call Crlf
	INVOKE GetTickCount
	mov startTick, eax
	exit
	
	
main ENDP
END main
