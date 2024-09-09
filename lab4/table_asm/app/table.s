; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed
byte_array SPACE 16 ; Erstellen von array mit 16 byte platz



; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed
		LDR R0,=byte_array
		LDR R1,=ADDR_DIP_SWITCH_7_0			; load address of adress 7_0 in r1
		LDR R2,=ADDR_DIP_SWITCH_15_8		; load address of adress 15_8 in r2
		LDR R3,=BITMASK_LOWER_NIBBLE
		LDR R4,=ADDR_LED_7_0				; load adress of led
		LDR R5,=ADDR_LED_15_8
		LDR R6,=ADDR_DIP_SWITCH_31_24
		LDR R7,=ADDR_LED_31_24
		
		LDRB R1,[R1]						; load first 8 bit with ldrb
		LDRB R2,[R2]
		
		LDRB R6,[R6]
		
		ANDS R2,R2,R3						; AND bitmask to second value
		STR R1,[R4]							; store value of R1 in addr R4
		STR R2,[R5]							; store value of R2 in addr R5
		
		ANDS R6,R6,R3						; AND bitmask to upper index
		STR R6,[R7]							; Store outputindex in led
		
		STR R1,[R0,R2]						; save value into array r0 with index r2
		
		LDRB R1, [R0, R6]					; load value from array with offset r6(outIndex) into R1
		LDR R2, =ADDR_LED_23_16				; load led outputvalue addr in r2
		STRB R1,[R2]						; store one byte value from index R1 into addr R2

; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
