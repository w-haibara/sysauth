#include "network_client.c"

SYSCALL_DEFINE5(auth, unsigned char *, ip, unsigned int, port, int, mode, char *, msg_from_server, size_t, msg_size)
{
    int ret = 0;
    char msg_ptr[msg_size];
    memset(msg_ptr, 0, sizeof(msg_ptr));

    printk(KERN_INFO "[sysauth] called \n");

    unsigned char buf[4];
    long copied = copy_from_user(buf, ip, sizeof(buf));
    if (copied < 0 || copied == sizeof(buf)) return -EFAULT;
    printk(KERN_INFO "[sysauth] dest ip: %d.%d.%d.%d \n", buf[0], buf[1], buf[2], buf[3]);

    switch(mode){
        case 0:
            printk(KERN_INFO "[sysauth] init \n");
            ret = network_client_init(buf, port, msg_ptr, sizeof(msg_ptr));
            copy_to_user(msg_from_server, msg_ptr, sizeof(msg_ptr));
            break;
        case 1:
            //printk(KERN_INFO "[sysauth] exit \n");
            //network_client_exit();
            break;
        default:
            printk(KERN_INFO "[sysauth] val of mode is invalid \n");
            break;
    }

    return ret;
}

