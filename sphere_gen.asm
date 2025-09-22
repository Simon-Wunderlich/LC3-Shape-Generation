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

			; Gets (euclidian distance)^2 and loads into r5			
			BRnzp DIST
			ENDDIST
			
			; Subtract r^2 from distance
			LD r4, NRSQR
			ADD r5, r5, r4

			; If r5 > r4 dont place block
			BRp skipPlace
				; Place block
				LD r3, BLOCK
				SETB
			skipPlace

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

; Calculates (euclidian distance)^2
DIST
	; Stores x,y, and z iterators in memory adresses x3103, x3104, x3105
	STR r0, r6, #3
	STR r1, r6, #4
	STR r2, r6, #5

	; Clears register used to sum results
	AND r5, r5, #0

	; Gets distance between x_player and current x
	LDR r3, r6, #0 ; r3 = x-dia
	LD r4, DIA ; r4 = dia
	ADD r3, r3, r4 ; r3 = x
	NOT r3, r3 ; r3 = -x_player - 1
	ADD r3, r3, #1 ; r3 = -x
	ADD r3, r0, r3 ; r3 = delta x

	; Gets square of r3 and places output in r3
	JSR SQR
	ADD r5, r5, r3
	
	; Gets distance between y_player and current y
	LDR r0, r6, #4 ; Sets r0 to current y
	LDR r3, r6, #1 ; r3 = y_player - diameter
	LD r4, DIA ; r4 = diameter
	ADD r3, r3, r4 ; r3 = y_player
	NOT r3, r3 ; r3 = -y_player - 1
	ADD r3, r3, #1 ; r3 = -y_player
	ADD r3, r0, r3 ; r3 = delta y

	; Gets square of r3 and places output in r3
	JSR SQR
	ADD r5, r5, r3

	; Gets distance between z_player and current z
	LDR r0, r6, #5 ; Sets r0 to current z
	LDR r3, r6, #2 ; r3 = y-dia
	LD r4, DIA ; r4 = dia
	ADD r3, r3, r4 ; r3 = z
	NOT r3, r3 ; -z_player - 1
	ADD r3, r3, #1 ; r3 = -z
	ADD r3, r0, r3 ; r3 = delta z

	; Gets square of r3 and places output in r3
	JSR SQR
	ADD r5, r5, r3

	; Resets r0, r1, and r2 to values current x,y,z values
	LDR r0, r6, #3
	LDR r1, r6, #4
	LDR r2, r6, #5
BRnzp ENDDIST

; Get square of r3
SQR
	; GET |r3|
	ADD r3, r3, #0
	BRzp notNeg
		NOT r3, r3
		ADD r3, r3, #1
	notNeg

	; Set r4, r1 to r3
	ADD r4, r3, #0
	ADD r1, r3, #0

	; Reset r3 to 0
	AND r3, r3, #0
	
	; Add r1 to r3, r1 times. Using r4 as a counter
	LOOP
		ADD r3, r3, r1
		ADD r4, r4, #-1
	BRp LOOP
RET

MEM .FILL x3100
DIA .FILL #100
NDIA .FILL #-100
RAD .FILL #50
BLOCK .FILL #152
NRSQR .FILL #-2500

.END

