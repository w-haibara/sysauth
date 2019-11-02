#include "fastecho_module.c"

SYSCALL_DEFINE0(auth)
{
    printk(KERN_INFO "[hello from kernel] \n");
    
    fastecho_init_module();  
    
    return 0;
}

