
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>

// https://www.kernel.org/doc/Documentation/input/joystick-api.txt

#define JS_EVENT_BUTTON         0x01    /* button pressed/released */
#define JS_EVENT_AXIS           0x02    /* joystick moved */
#define JS_EVENT_INIT           0x80    /* initial state of device */

struct js_event {
	uint32_t time;     /* event timestamp in milliseconds */
	int16_t value;    /* value */
	uint8_t type;      /* event type */
	uint8_t number;    /* axis/button number */
};

int main() {
    
    int fd = open ("/dev/input/js0", O_RDONLY);
    
    if(fd > -1)
        printf("Opnened Joystick interface\n");
    else {
        printf("Failed to open Joystick interface\n");
    }
    
    printf("Handle: %d\n", fd);

// Step 2

    struct js_event e;

    // Blank screen and set cursor to 0
    printf("%c[%dJ",0x1B,1);
    printf("%c[%d;%df",0x1B,1,1);
    //std::cout << "\x1b[1;1f";

    uint8_t cursor = 0;

    while(1) {

        read (fd, &e, sizeof(e));

        if(e.type == JS_EVENT_AXIS) {

            if(e.number >-1 && e.number < 9) {
                // Move cursor to position and blank line
                printf("%c[%d;%dH",0x1B,e.number+2,1);
                printf("%c[%dK",0x1B,0);
                printf("%c[%d;%dH",0x1B,e.number+2,1);

                printf("Axis: %d\t", e.number);
                printf("Value: %d\n", e.value);
            }
        }
        if(e.type == JS_EVENT_BUTTON) {
            // Move cursor to position and blank line
            printf("%c[%d;%dH",0x1B,e.number+2+9,1);
            printf("%c[%dK",0x1B,0);
            printf("%c[%d;%dH",0x1B,e.number+2+9,1);

            printf("Button: %d\t", e.number);
            printf("Value: %d\n", e.value);
        }
    }

    // Clean up    
    close(fd);
    
    return 0;
}