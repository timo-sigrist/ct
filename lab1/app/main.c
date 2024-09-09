#include "utils_ctboard.h"

#define SWITCH 0x60000200
#define LED 0x60000100
#define ROTARY_SWITCH_P11 0x60000211
#define SEVEN_SEGEMENT_0 0x60000110
#define SEVEN_SEGEMENT_1 0x60000111
#define SEVEN_SEGEMENT_2 0x60000112
#define SEVEN_SEGEMENT_3 0x60000113

int main(void) {
	
	const static uint8_t myArr[10] = {
		0xC0, /*0*/
		0xF9,
		0xA4,
		0xB0,
		0x99,
		0x92,/*5*/
		0x82,
		0xF8,
		0x80,
		0x90,/*9*/
	};
	uint8_t valueRotray = 0x00;
	

	while (1) {
		/*copy values from switches to led */
		uint32_t valueSwitch = read_word(SWITCH);
		write_word(LED, valueSwitch);
		
		/* set 7seg */
		valueRotray = read_byte(ROTARY_SWITCH_P11);
		valueRotray = 0x0F & valueRotray;/*remove upper for bits*/
		if (valueRotray > 9 ) {
			valueRotray = valueRotray -10;
			write_byte(SEVEN_SEGEMENT_1, 0xF9);
		} else {
			write_byte(SEVEN_SEGEMENT_1, 0xC0);
		}
		write_byte(SEVEN_SEGEMENT_0, myArr[valueRotray]);
	}
}
