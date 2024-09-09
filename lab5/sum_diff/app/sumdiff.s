; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- sumdiff.s
; --
; -- CT1 P05 Summe und Differenz
; --
; -- $Id: sumdiff.s 705 2014-09-16 11:44:22Z muln $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_LED_7_0            EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_23_16          EQU     0x60000102
ADDR_LED_31_24          EQU     0x60000103

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA MyCode, CODE, READONLY

main    PROC
        EXPORT main

user_prog
        ; STUDENTS: To be programmed
		
		LDR  R0,=ADDR_DIP_SWITCH_15_8
		LDRB R0,[R0]						;load value from dipswitch in R0 -> Operand a
		LDR  R1,=ADDR_DIP_SWITCH_7_0
		LDRB R1,[R1]						; load value from dipswitch in R1 -> Operand b
		LSLS R0,R0, #24						
		LSLS R1,R1, #24						; shift value to the left, right part get zeros -> now 32 bit


		LDR  R6,=ADDR_LED_7_0				;addr res
		LDR  R7,=ADDR_LED_15_8				;addr flag
		ADDS R2,R0,R1
		
		MRS  R4,APSR
		LSRS R4,R4, #24						; flags are on bit 28, 32 -> shift by 24 to in in by
		STRB  R4,[R7]
		
		LSRS R2,R2, #24						; add + shift value back for most siginificatn bit
		STRB  R2,[R6]
		
		
		LDR R6,=ADDR_LED_23_16				;addr res
		LDR R7,=ADDR_LED_31_24				;addr flag
		SUBS R3,R0,R1		
		
		MRS R4,APSR
		LSRS R4,R4, #24						;load and shift flag
		STRB R4,[R7]
		
		LSRS R3,R3, #24
		STRB R3,[R6]
		
		
		
		


        ; END: To be programmed
        B       user_prog
        ALIGN
; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
