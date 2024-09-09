		
	AREA IOFuncCode, CODE, READONLY

in_word
		EXPORT 	in_word
				
		PUSH 	{R4-R5, LR}

		MOV		R4, R0			; copy input
		LDR     R5, [R4]
		MOV		R0, R5			; store result
			

		POP 	{R4-R5, PC}
			
out_word
			EXPORT out_word
				
			PUSH 	{R4-R5, LR}
	
			MOV		R4, R0		; copy input
			MOV		R5, R1
			STR     R5, [R4]	; store result
			
			POP 	{R4-R5, PC}
			
	END