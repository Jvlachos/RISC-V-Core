#include "printf.h"
#define REG1 (volatile unsigned int*)0x80000

int main(){
    *REG1 = 50;
    volatile int  res = *REG1;
    int a = 50;

    printf("Result %d\n", res+a);
}