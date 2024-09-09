;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 7
;* -- Description : Control structures
;* -- 
;* -- $Id: main.s 3748 2016-10-31 13:26:44Z kesr $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
    
                AREA myCode, CODE, READONLY
                    
                THUMB

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_7_SEG_BIN_DS1_0    EQU     0x60000114
ADDR_DIP_SWITCH_15_0    EQU     0x60000200
ADDR_HEX_SWITCH         EQU     0x60000211

NR_CASES                EQU     0xB
BITMASK_ROTARY          EQU     0x0F

jump_table      ; ordered table containing the labels of all cases
                ; STUDENTS: To be programmed 
				DCD	case_dark
				DCD case_add
				DCD case_sub
				DCD case_mul
				DCD case_and
				DCD case_or
				DCD case_xor
				DCD case_not
				DCD case_nand
				DCD case_nor
				DCD case_xnor
				DCD case_light

                ; END: To be programmed
    

; -------------------------------------------------------------------
; -- Main
; -------------------------------------------------------------------   
                        
main            PROC
                EXPORT main
                
read_dipsw      ; Read operands into R0 and R1 and display on LEDs
                ; STUDENTS: To be programmed
				LDR R2,=ADDR_DIP_SWITCH_15_0
				LDRB R0,[R2, #1]				;load operand 1 with offset of 1
				LDRB R1,[R2]					;load operand 2
				
				LDRH R2, [R2]					; value for display
				LDR	 R3,=ADDR_LED_15_0
				STRH R2,[R3]					;display inputvalues on display
                ; END: To be programmed
                    
read_hexsw      ; Read operation into R2 and display on 7seg.
                ; STUDENTS: To be programmed
				LDR R3,= BITMASK_ROTARY
				LDR R2,=ADDR_HEX_SWITCH
				LDRB R2,[R2]					; load rotaryinput
				ANDS R2,R2,R3					; eliminate leading f of rotaryinput
				
				LDR R3,=ADDR_7_SEG_BIN_DS1_0
				STR R2,[R3]						; display operand in 7seg				
                ; END: To be programmed
                
case_switch     ; Implement switch statement as shown on lecture slide
                ; STUDENTS: To be programmed
				CMP R2, #NR_CASES
				BHS case_light			; default case
				LSLS R2, #2				; *4 -> 4 bit grossen adressen
				LDR R7, =jump_table		; load jumptable
				LDR R7, [R7, R2]		; load address from table with offset of rotary(r2)
				BX R7					; go to loaded address
                ; END: To be programmed


; Add the code for the individual cases below
; - operand 1 in R0
; - operand 2 in R1
; - result in R0

case_dark       
                LDR  R0, =0
                B    display_result  

case_add        
                ADDS R0, R0, R1
                B    display_result

; STUDENTS: To be programmed
case_sub
				SUBS R0, R0, R1
				B    display_result

case_mul		
				MULS R0, R1, R0	
				B    display_result

case_and		
				ANDS R0, R0, R1
				B    display_result

case_or			
				ORRS R0, R0, R1
				B    display_result

case_xor
				EORS R0, R0, R1
				B    display_result

case_not		
				MVNS R0, R0
				B    display_result

case_nand
				ANDS R0, R0, R1
				MVNS R0, R0
				B    display_result

case_nor
				ORRS R0, R0, R1
				MVNS R0, R0
				B    display_result
				
case_xnor		
				EORS R0, R0, R1
				MVNS R0, R0
				B    display_result
				
case_light      
                LDR  R0, =0xffff
                B    display_result  
; END: To be programmed


display_result  ; Display result on LEDs
                ; STUDENTS: To be programmed
				LDR R3,=ADDR_LED_31_16
				STRH R0,[R3]				;display on leds
                ; END: To be programmed

                B    read_dipsw
                
                ALIGN
                ENDP

; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

