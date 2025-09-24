.ORIG x3000

; Define address in memory to define variables
LD r6, MEM 

; Gets player positions and loads x,y,z in r0,r1,r2
GETP 

; Offset sphere height by radius
LD r3, RAD
ADD r1, r1, r3

; Subtract the diameter from x,y, and z and store in addresses in x3100, x3101, and x3102
LD r3, NDIA

ADD r0, r0, r3
STR r0, r6, #0

ADD r1, r1, r3
STR r1, r6, #1

ADD r2, r2, r3
STR r2, r6, #2

; Sets r0, r1, and r2 to diameter
LD r0, DIA
LD r1, DIA
LD r2, DIA

LOOP_X
	; Loads x - diameter
	LDR r3, r6, #0

	; Diameter - (x-diameter) = x coord
	; At end of loop, r0 is decremented so that next loop this will yeild x-1
	ADD r0, r0, r3

	; Resets y pos to diameter
	LD r1, DIA

	; Start looping over y values
	LOOP_Y
		; Loads y - diameter
		LDR r3, r6, #1

		; Same iteration logic as lines 32-36
		ADD r1, r1, r3

		; Resets z pos to diameter
		LD r2, DIA

		; Start looping over z values
		LOOP_Z
			; Loads z - diameter
			LDR r3, r6, #2

			; Same iteration logic as lines 32-36
			ADD r2, r2, r3
			
			; Offset x,y, and z values by radius to center sphere on player pos
			LD r3, RAD 
			ADD r0, r0, r3
			ADD r1, r1, r3
			ADD r2, r2, r3

			; Place block
			LD r3, BLOCK
			SETB

			; Remove radius offset
			LD r3, RAD
			NOT r3, r3
			ADD r3, r3, #1
			
			ADD r0, r0, r3
			ADD r1, r1, r3
			ADD r2, r2, r3

			; r2 is decremented by 1
			
			LDR r3, r6, #2 ; (z-diameter)
			NOT r3, r3 ; -(z - diameter) - 1
			
			; Subtract (z_player - diameter + 1) from z
			; Decrements z by 1 and subtracts by player z
			; Iterate over diameter until it hits z
			ADD r2, r2, r3
		BRp LOOP_Z

		LDR r3, r6, #1 ; (y-diameter)
		NOT r3, r3 ; -(y-diameter) - 1

		; Same logic as lines 94-96
		ADD r1, r1, r3
	BRp LOOP_Y

	LDR r3, r6, #0 ; (x - diameter)
	NOT r3, r3 ; -(x - diameter) - 1
		
	; Same logic as lines 94-96
	ADD r0, r0, r3
BRp LOOP_X

HALT 

MEM .FILL x3100
DIA .FILL #24
NDIA .FILL #-24
RAD .FILL #12
BLOCK .FILL #155
NRSQR .FILL #-144

.END


