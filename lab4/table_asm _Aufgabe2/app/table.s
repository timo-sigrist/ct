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
ADDR_SEVEN_SEG_NUM			EQU 	0x60000114

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F
BITMASK_HALFWORD			EQU		0x0FFF

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed
byte_array SPACE 32 ; Erstellen von array mit 16 byte platz



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
		LDR R1,=ADDR_DIP_SWITCH_7_0			; load address of adress 7_0
		LDR R2,=ADDR_DIP_SWITCH_15_8
		LDR R3,=BITMASK_LOWER_NIBBLE
		LDR R4,=ADDR_LED_7_0				; load adress of led
		LDR R5,=ADDR_DIP_SWITCH_31_24		; output index
		LDR R6,=ADDR_SEVEN_SEG_NUM
		LDR R7,=BITMASK_HALFWORD
		
		LDRH R1,[R1]						; load first dipswitchrow
		ANDS R1, R1,R7						; mask index
		LDRB R2,[R2]						; load input index
		ANDS R2,R2,R3						; AND bitmask to second value
		LSLS R2,R2,#1						; multiply index by two since halfword

		STRH R1,[R4]						; store value into led 0-15
		STRH R1,[R0,R2]						; save value into array r0 with index r2
		
		LDRB R7,[R5]						; store output index
		ANDS R7,R7,R3						; mask index
		LSLS R7,R7,#1						; multiply index by two since halfword
		LDRH R1,[R0,R7]						; load value from Array at index in R1
		
		STRH R1,[R6]

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
