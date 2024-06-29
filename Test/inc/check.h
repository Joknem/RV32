#ifndef __CHECK_H
#define __CHECK_H

#define CHECK(expr) ((expr) ? (void)0 : assert_failed())
void assert_failed(void){
    while(1){

    }
}
#endif