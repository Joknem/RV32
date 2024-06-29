#ifndef _GPIO_H
#define _GPIO_H

#define GPIO_BASE (0x20000000)
#define GPIO_CTRL (GPIO_BASE + 0x00)
#define GPIO_DATA (GPIO_BASE + 0x04)

#define GPIO_REG(addr) (*((volatile unsigned int*)addr))
#endif