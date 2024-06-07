#include "check.h"

int main(void){
    int sum = 0;
    for(int a = 0; a < 50; a++){
        sum += a;
    }
    CHECK(sum == 1225);
    return 0;
}