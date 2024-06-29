#include "gpio.h"

int main() {
    GPIO_REG(GPIO_CTRL) |= 0x01;
    GPIO_REG(GPIO_DATA) |= 0x01;
}