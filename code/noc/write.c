#include "printf.h"
#include "noc.h"

int main(){
    for(int i =0; i < 16; i++){
        *NOC_REGS[i] = 50 + i;
    }

    for(int i =0; i < 16; i++){
        printf("NOC_REGS[%d] = %d\n", i, *NOC_REGS[i]);
    }
}