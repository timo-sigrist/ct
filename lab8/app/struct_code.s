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
; -- CT1 P08 "Strukturierte Codierung" mit Assembler
; --
; -- $Id: struct_code.s 3787 2016-11-17 09:41:48Z kesr $
; ------------------------------------------------------------------
;Directives
		PRESERVE8
		THUMB

; ------------------------------------------------------------------
; -- Address-Defines
; ------------------------------------------------------------------
; input
ADDR_DIP_SWITCH_7_0       EQU        0x60000200
ADDR_BUTTONS              EQU        0x60000210

; output
ADDR_LED_31_0             EQU        0x60000100
ADDR_7_SEG_BIN_DS3_0      EQU        0x60000114
ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x60000314


; ------------------------------------------------------------------
; -- Program-Defines
; ------------------------------------------------------------------
; value for clearing lcd
ASCII_DIGIT_CLEAR        EQU         0x00000000
LCD_LAST_OFFSET          EQU         0x00000028

; offset for showing the digit in the lcd
ASCII_DIGIT_OFFSET        EQU        0x00000030

; lcd background colors to be written
DISPLAY_COLOUR_RED        EQU        0
DISPLAY_COLOUR_GREEN      EQU        2
DISPLAY_COLOUR_BLUE       EQU        4
	
MASK_KEY_T0             EQU     0x00000001	


; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
		AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
		ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
		AREA myCode, CODE, READONLY
		ENTRY

		; imports for calls
		import adc_init
		import adc_get_value

main    PROC
		export main
		; 8 bit resolution, cont. sampling
		BL         adc_init 
		BL         clear_lcd

main_loop
; STUDENTS: To be programmed
		BL		adc_get_value
		LDR 	R7,=ADDR_BUTTONS
		LDR 	R1,[R7]				;get value of button
		LDR 	R7,=MASK_KEY_T0
		ANDS	R1, R1, R7			;mask for t0
		
		CMP 	R1,#1				;if pressed
		BEQ 	pressed
		
		LDR 	R7,=ADDR_LED_31_0
		LDR 	R6,=0x00			
		STR 	R6,[R7]				;turnoff all led -> taskb

		BL 		read_dip_switch 	;reads dispwitch in R1
		SUBS 	R2, R0, R1			; diff in R2
		CMP		R2,#0
		BGE 	dif_greater_null
		BL 		set_red
		BL 		count_zeros
		
display_flow
		LDR 	R7,=ADDR_7_SEG_BIN_DS3_0
		STR 	R2,[R7]				;display diff to 7seg


; END: To be programmed
		B          main_loop


pressed
		BL 		set_green
		BL		display_leds
		LDR 	R7,=ADDR_7_SEG_BIN_DS3_0
		STRH 	R0,[R7]						; display adc on 7seg
		BL 		clear_lcd
		B 		main_loop

		
dif_greater_null
		BL 		set_blue
		BL		display_bit_lcd
		B 		display_flow


	
read_dip_switch
		PUSH 	{R7,LR}
		LDR 	R7,=ADDR_DIP_SWITCH_7_0
		LDRB 	R1,[R7]						;saves value form dipswitch in R1
		POP 	{R7,PC}

set_red
		PUSH 	{R5,R6,R7,LR}
		;BL         clear_lcd
		LDR 	R5,=ADDR_LCD_COLOUR
		LDR 	R6,=DISPLAY_COLOUR_RED
		LDR 	R7,=0xffff
		STR 	R7,[R5,R6]					;trun on red
		
		LDR 	R6,=DISPLAY_COLOUR_BLUE
		LDR 	R7,=0x0000
		STRH 	R7,[R5,R6]					;turrn off blue
		LDR 	R6,=DISPLAY_COLOUR_GREEN
		STRH 	R7,[R5,R6]					;turn off green
		
		POP 	{R5,R6,R7,PC}
	
set_blue
		PUSH 	{R5,R6,R7,LR}
		;BL         clear_lcd
		LDR 	R5,=ADDR_LCD_COLOUR
		LDR 	R6,=DISPLAY_COLOUR_BLUE
		LDR 	R7,=0xffff
		STR 	R7,[R5,R6]					;trun on blue
		
		LDR 	R6,=DISPLAY_COLOUR_RED
		LDR 	R7,=0x0000
		STRH 	R7,[R5,R6]					;turrn off red
		LDR 	R6,=DISPLAY_COLOUR_GREEN
		STRH 	R7,[R5,R6]					;turn off green
		
		POP 	{R5,R6,R7,PC}

set_green
		PUSH 	{R5,R6,R7,LR}
		;BL         clear_lcd
		LDR 	R5,=ADDR_LCD_COLOUR
		LDR 	R6,=DISPLAY_COLOUR_GREEN
		LDR 	R7,=0xffff
		STR 	R7,[R5,R6]					;trun on green
		
		LDR 	R6,=DISPLAY_COLOUR_RED
		LDR 	R7,=0x0000
		STRH 	R7,[R5,R6]					;turrn off red
		LDR 	R6,=DISPLAY_COLOUR_BLUE
		STRH 	R7,[R5,R6]					;turn off blue
		
		POP 	{R5,R6,R7,PC}
		
display_leds								;start task b
		PUSH	{R3,R4,R7,LR}
		LDR 	R7,=ADDR_LED_31_0	
		MOVS 	R3,R0						;copy acd
		LSRS 	R3,R3,#3					;divide acd by 8 -> shift 3 left
		MOVS	R4,#1						;init diplay register
		B		led_test
loop_leds
		LSLS 	R4,R4,#1					;shift displaylabel to left
		ADDS 	R4,R4,#1					;add one to displaylable
		SUBS 	R3,R3,#1					;decrement loop cond
		
led_test
		CMP 	R3,#0
		BHI 	loop_leds
		
		STR 	R4,[R7]						;display on led
		POP 	{R3,R4,R7,PC}				;leave subroutin


display_bit_lcd
		PUSH 	{R3,R7,LR}
		LDR 	R7,=ADDR_LCD_ASCII
		
		CMP 	R2,#4
		BLS		display_2bit
		
		CMP		R2,#16
		BLS 	display_4bit
		
		LDR		R3,=DISPLAY_8_BIT
		B		display_done
		
display_2bit
		LDR 	R3,=DISPLAY_2_BIT
		B		display_done
display_4bit
		LDR		R3,=DISPLAY_4_BIT
		B		display_done
display_done
		LDRB	R3,[R3]
		STR		R3,[R7]
		BL		write_bit_ascii
		POP		{R3,R7,PC}


count_zeros
		PUSH	{R2,R4,R5,R6,R7,LR}
		MOVS 	R5,R2			;copy diff in r5
		;SUBS	R5,R5,#1
		MVNS	R5,R5			;turn all 0 in 1 to count
		MOVS	R2,#0			;resultat in r0
		MOVS	R6,#8			;counter 
		
		LDR		R7,=MASK_KEY_T0
		
start_loop
		MOVS	R4,R5	
		ANDS 	R4, R4,R7		; lsb in R4 to cmp
		
		CMP 	R4, #0
		BEQ		continue_loop
		ADDS	R2,R2,#1

continue_loop
		LSRS	R5,R5,#1		; R5 eins nach rechts shiften
		SUBS	R6,R6,#1		; decrease counter with 1
		CMP 	R6,#0
		BHI		start_loop
		
		
		LDR 	R6,=ASCII_DIGIT_OFFSET
		ADDS	R2,R2,R6
		LDR 	R6,=ADDR_LCD_ASCII_2ND_LINE
		STR		R2,[R6]
		POP 	{R2,R4,R5,R6,R7,PC}
		

clear_lcd
		PUSH       {R0, R1, R2}
		LDR        R2, =0x0
clear_lcd_loop
		LDR        R0, =ADDR_LCD_ASCII
		ADDS       R0, R0, R2                ; add index to lcd offset
		LDR        R1, =ASCII_DIGIT_CLEAR
		STR        R1, [R0]
		ADDS       R2, R2, #4                       ; increas index by 4 (word step)
		CMP        R2, #LCD_LAST_OFFSET             ; until index reached last lcd point
		BMI        clear_lcd_loop
		POP        {R0, R1, R2}
		BX         LR

write_bit_ascii
		PUSH       {R0, R1}
		LDR        R0, =ADDR_LCD_ASCII_BIT_POS 
		LDR        R1, =DISPLAY_BIT
		LDR        R1, [R1]
		STR        R1, [R0]
		POP        {R0, R1}
		BX         LR

		ENDP
		ALIGN


; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
		END
