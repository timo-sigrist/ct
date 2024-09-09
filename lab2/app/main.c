/* -----------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210
#define BRIGHT	0xC0
#define DARK 0xCF

// define your own macros for bitmasks below (#define)
/// STUDENTS: To be programmed




/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;
		uint8_t led_valueedited = 0;
    // add variables below
    /// STUDENTS: To be programmed
		uint8_t buttons_value = 0;
		uint8_t buttont0_value = 0;
		uint8_t buttont1_value = 0;
		uint8_t buttont2_value = 0;
		uint8_t buttont3_value = 0;
	
		uint8_t wide_counter = 0;
		uint8_t push_counter = 0;
		uint8_t lastVal_t0 = 0;
		uint8_t lastVal_t1 = 0;
		uint8_t lastVal_t2 = 0;
		uint8_t lastVal_t3 = 0;
	
		uint8_t dipswitch_value = 0;

    /// END: To be programmed

    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);

        /// STUDENTS: To be programmed
				led_valueedited = led_value | BRIGHT;
				led_valueedited = led_valueedited & DARK;
        /// END: To be programmed

        write_byte(ADDR_LED_7_0, led_valueedited);

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed
				
				buttons_value = buttons_value & 0x0F; /*mask upper 4 bits */	
				buttont0_value = buttons_value & 0x01;	
				buttont1_value = buttons_value & 0x02;
				buttont2_value = buttons_value & 0x04;
				buttont3_value = buttons_value & 0x08;
				
				/* 3.2 a */
				wide_counter = wide_counter + buttont0_value;
				write_byte(ADDR_LED_15_8, wide_counter);
				/* 3.2 b & 3.3 */
				if (lastVal_t0 != buttont0_value) {
					lastVal_t0 = buttont0_value;
					/* only on down */
					if (lastVal_t0 != 0) {
						push_counter++;
						dipswitch_value >>= 0x01;
					}
				} else if (lastVal_t1 != buttont1_value) {
					lastVal_t1 = buttont1_value;
					/* only on down */
					if (lastVal_t1 != 0) {
						dipswitch_value <<= 0x01;
					}
				}else if (lastVal_t2 != buttont2_value) {
					lastVal_t2 = buttont2_value;
					/* only on down */
					if (lastVal_t2 != 0) {
						dipswitch_value = ~dipswitch_value;
					}
				}else if (lastVal_t3 != buttont3_value) {
					lastVal_t3 = buttont3_value;
					/* only on down */
					if (lastVal_t3 != 0) {
						dipswitch_value = led_value;
					}
				}
				
				write_byte(ADDR_LED_31_24, push_counter);
				write_byte(ADDR_LED_23_16, dipswitch_value);
		
				buttons_value = read_byte(ADDR_BUTTONS);
        /// END: To be programmed
    }
}
