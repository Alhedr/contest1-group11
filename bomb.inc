;IFDEF/ELSE is to make sure the file only processed once 
IFDEF BOMB_INC
	; Already included - Skip
	
ELSE	
	BOMB_INC EQU 1

	; Game settings
	MIN_WIRES = 4 ; Fixed number of wires in a range shape for flexibility
	MAX_WIRES = 4
	MAX_STRIKES = 3 ; 3rd mistake = game ends      
	TIME_LIMIT_MS = 120000 ; Timer for each game (2 minutes)      
	TICK_MS = 50 ; The loop waits 50ms every pass            

	; Wire Colors 
	WIRE_RED = 0
	WIRE_BLUE = 1
	WIRE_GREEN = 2
	WIRE_YELLOW = 3
	
	; NUM_COLORS For flexibility
	NUM_COLORS = 4
	
	
	; The result code
	RESULT_OK = 0 ; correct wire - unlocks the code prompt   
	RESULT_STRIKE = 1 ; wrong wire or wrong code
	RESULT_DEFUSED = 2 ; bomb defused and player wins   
	RESULT_INVALID = 3 ; the input is invalid (wire cut already) - No Strikes 
							
							
	; Declaring Variables						
	EXTERNDEF wireCount:BYTE ; Number of wires (4)
	EXTERNDEF wireColors:BYTE ; the color of each wire, as an array, one byte per wire 
	EXTERNDEF wireCut:BYTE ; whether each wire is cut (1 = CUT, 0 = NOT CUT)     
	EXTERNDEF bombCode:WORD ; the hex code 
	EXTERNDEF strikes:BYTE ; how many mistakes the player has made     
	EXTERNDEF rulesText:BYTE ; the rules page, as a string.
	EXTERNDEF timeLeftMs:DWORD ; milliseconds left on the timer 
								
	
	; builds a new random bomb: picks the colors and the code, sets strikes to 0 and clears wireCut
	InitBomb PROTO
	 
		
		
	CutWire PROTO, wireNum:DWORD ; the player tries to cut a wire 
	CheckCode PROTO, enteredCode:DWORD ; checks the code the player typed only after the correct wire


ENDIF	

