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
	
ENDIF	

