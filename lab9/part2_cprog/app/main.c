#include <stdint.h>

#define DIP_ADDR 					0x60000200
#define LED_ADDR 					0x60000100

extern void out_word(uint32_t out_address, uint32_t out_value);
extern uint32_t in_word(uint32_t in_address);

int main(void) {
	
	while(1){
		out_word(LED_ADDR, in_word(DIP_ADDR));
	}

}
