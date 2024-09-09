; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_7_0            EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_SEG_BIN_1		    EQU     0x60000114
ADDR_SEG_BIN_2		    EQU     0x60000115
ADDR_BUTTONS            EQU     0x60000210
MASK_KEY_T0             EQU     0x00000001

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000
	
BIT_MASK				EQU		0x0f

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed
		LDR		R7, =BIT_MASK			
		
		LDR 	R0, =ADDR_DIP_SWITCH_7_0	;load value dipswitch 0-7 
		LDRB	R0, [R0]
		ANDS	R0, R0, R7					; einer in r0
		
		LDR 	R1, =ADDR_DIP_SWITCH_15_8	; load value dipswitch 8-15
		LDRB	R1, [R1]
		ANDS	R1, R1, R7					; zehner in r1
		
		MOVS	R2, R1						; copy value from R2 to R4 (zehner)
		LSLS	R2, R2, #4					; move decimal one to left
		;ORRS	R2, R2, R0					; add ones to tens
		ADDS 	R2, R2, R0
		
		LDR 	R7, =ADDR_BUTTONS			
		LDR  	R5, [R7]
		LDR 	R7, =MASK_KEY_T0
		ANDS	R5, R5, R7
											
		MOVS	R3, R1						; check T0 pressed for shift multi
		LDR     R7, =ADDR_LCD_BLUE
		CMP		R5, #1
		BEQ		pressed
		
		LDR		R4, =10
		MULS 	R3, R4, R3					; multiply with 10 for zehner (hex)
		
go_on	ADDS	R3, R3, R0
		
		LDR     R4, =LCD_BACKLIGHT_OFF		
		LDR		R0, =ADDR_LCD_BLUE
		LDR		R1, =ADDR_LCD_RED			; reset lights
		STRH	R4, [R0]
		STRH	R4, [R1]
		
		LDR     R4, =LCD_BACKLIGHT_FULL
        STRH    R4, [R7]					; set background color
		
		LDR		R7, =ADDR_LED_7_0			
		STRB	R2, [R7]					; display input einer
		
		LDR		R7, =ADDR_LED_15_8
		STRB	R3, [R7]					; display inpurt zehner
		
		LDR		R7, =ADDR_SEG_BIN_1
		STRB 	R2, [R7]					; display 7seg einer
		
		LDR		R7, =ADDR_SEG_BIN_2
		STRB 	R3, [R7]					; display 7seg zehner
		
		MOVS 	R0, R3
		BL		count_set_bits				; go to Task 2 code
		
		; shifting with position (R8)
		CMP		R6, #15
		BEQ 	reset_shift
		
		BL		shift_value
		BL 		pause
		
		LDR 	R7, =ADDR_LED_31_16
		STRH	R0, [R7]
		
		; increment shift position
		ADDS 	R6, R6, #1

; END: To be programmed

        B       main
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------
; react on T0 button pressed
pressed	LDR		R7, =ADDR_LCD_RED			

		MOVS	R5, R3
		
		MOVS 	R3, #0
		
		LSLS	R5, R5, #1
		ADDS	R3, R3, R5
		LSLS	R5, R5, #2
		ADDS	R3, R3, R5

		B		go_on

; count set bits
count_set_bits
		MOVS    R1, #0       
		MOVS    R2, #0x01      

count_loop
		CMP     R0, #0         
		BEQ     count_done 
		
		MOVS 	R3, R0
		ANDS    R3, R3, R2    
		CMP     R3, #0       
		BNE     count_increment      	; shift with count size

count_loop_go_on
		LSRS 	R0, R0, #1
		B count_loop

count_increment
		LSLS	R1, R1, #1
		ADDS	R1, R1, #1
		B       count_loop_go_on

count_done
		MOVS    R0, R1  
		BX      LR
		
; reset shift
reset_shift
		MOVS 	R6,	#0
		BX		LR
		
; shift
shift_value
		MOVS    R1, #0         

shift_loop
		CMP     R1, R6
		BEQ     shift_done   
		
		MOVS	R2, #1
		RORS    R0, R0, R2
		
		ADDS    R1, R1, #1
		B       shift_loop

shift_done
		MOVS	R3, R0
		LSRS	R3, R3, #16
		
		ORRS	R0, R0, R3
		
		BX      LR

;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x002FFFFF
        
loop        
        SUBS    R0, R0, R1
        BCS     loop
    
        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
