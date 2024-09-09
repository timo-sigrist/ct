;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 10
;* -- Description : Search Max
;* -- 
;* -- $Id: search_max.s 879 2014-10-24 09:00:00Z muln $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myCode, CODE, READONLY
                THUMB
                    
; STUDENTS: To be programmed




; END: To be programmed
; -------------------------------------------------------------------                    
; Searchmax
; - tableaddress in R0
; - table length in R1
; - result returned in R0
; -------------------------------------------------------------------   
search_max      PROC
                EXPORT search_max

                ; STUDENTS: To be programmed
				
				PUSH 	{R4, R5}
				
				MOVS 	R2, R0			; copy address of table to check
				LDR 	R0, =0x80000000	; set return value (empty TableCount & minimal possible value if )
				
				CMP 	R1, #0			; check table empty? R1 = length table
				BEQ 	end_searchmax	
				
				MOVS 	R3, #0			; initialise index
				B 		loop_test		; loop_test
				
loop
				LSLS 	R5, R3, #2		; set array index: R5 = R3(r1) * 4
				LDR		R4, [R2, R5]	; load address R2 with index R3 into R4
				ADDS	R3, #1			; increment index
				CMP		R4, R0			; compare entry with return
				BLE		loop_test		
				MOVS	R0, R4			; replace return parameter
				
loop_test
				CMP		R3, R1			; check index reached TableCount
				BLT		loop			; continue loop
				B 		end_searchmax	

end_searchmax
				POP		{R4, R5}
				BX		LR

                ; END: To be programmed
                ALIGN
                ENDP
; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END