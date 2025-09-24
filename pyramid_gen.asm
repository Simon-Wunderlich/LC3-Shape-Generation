.ORIG x3000

GETP
ST r0, X
ST r1, Y
ST r2, Z
ADD r1, r1, #2
LD r7, DIAM
LD r3, BLOCK

AND r6, r6, #0
LOOP_Y
	LD r5, NRAD
	ADD r6, r6, #1

	LD r7, DIAM
	NOT r6, r6
	ADD r6, r6, #1
	
	ADD r7, r7, r6
	ADD r7, r7, r6
	NOT r6, r6
	ADD r6, r6, #1
	LOOP_X
		LD r4, DIAM
		NOT r6, r6
		ADD r6, r6, #1
		
		ADD r4, r4, r6
		ADD r4, r4, r6
		NOT r6, r6
		ADD r6, r6, #1
		
		LOOP_Z
			LD r0, X
			LD r1, Y
			LD r2, Z
			ADD r1, r1, #2
			ADD r1, r1, r6

			ADD r0, r0, r5
			ADD r2, r2, r5

			ADD r0, r0, r7
			ADD r2, r2, r4


			ADD r0, r0, r6
			ADD r2, r2, r6


			SETB

			ADD r4, r4, #-1
		BRp LOOP_Z
		ADD r7, r7, #-1
	BRp LOOP_X
	ADD r5, r6, r5
BRn LOOP_Y

HALT
BLOCK .FILL #201
RAD .FILL #25
DIAM .FILL #51
NRAD .FILL #-25
X .FILL #0
Y .FILL #0
Z .FILL #0
.END
