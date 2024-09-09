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

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000

BITMASK_LOWER_NIBBLE 	EQU 	0x0f

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed
		LDR R0, =BITMASK_LOWER_NIBBLE
		
		LDR R1,=ADDR_DIP_SWITCH_7_0
		LDRB R1, [R1]					;load value dipswitch 0-7
		ANDS R1, R1, R0
		
		LDR R2,=ADDR_DIP_SWITCH_15_8
		LDRB R2, [R2]					; load value dipswitch 8-15
		ANDS R2, R2, R0
		
		LDR R5,=ADDR_LED_15_0
		MOV R4, R2						; copy value from R2 to R4 (zehner)
		LSLS R4, R4, #4					; move binary to left
		ADDS R4, R4, R1					; add einer to zehner
		STR R4, [R5]					; display input
		
		MOV R5, R2						; copy zehner (dec)
		LSLS R5, R5, #4					; shift zehner one to the right
		ADD R5, R5, R1					; add einer (dec)
		
		LDR R3,=10
		MULS R2, R3, R2					; multiply with 10 for zehner (hex)
		ADDS R0, R2, R1					; add zehner and einer (hex)
		
		LDR R6,=ADDR_LED_15_8
		STRB R0,[R6]
		
		LSLS R0,R0,#8					; shift hexvalue to the right for 7seg
		ADD R0, R0, R5					; add dec display to hex fpr 7seg
		
		LDR R5,=ADDR_7_SEG_BIN_DS3_0	; display number on 7seg
		STR R0, [R5]
		
; END: To be programmed

        B       main
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------

;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF
        
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
