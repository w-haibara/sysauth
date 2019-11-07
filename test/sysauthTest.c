#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <string.h>

#define MYCALL_NUM 436

int main(){
    unsigned char ip[4] = {127, 0, 1, 1};
    printf("[sysauthTest.c] ip: %d.%d.%d.%d \n", ip[0], ip[1], ip[2], ip[3]); 
    
    char msg[256];
    memset(msg, 0, sizeof(msg));
    
    long res = syscall(MYCALL_NUM, &ip, 2325, 0, msg, sizeof(msg));
	if(res == 0) printf("[sysauthTest.c] msg from server: %s \n", msg);

    printf("[sysauthTest.c] sysauth returned %ld.\n", res);

    return 0;
}
