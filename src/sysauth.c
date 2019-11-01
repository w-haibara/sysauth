SYSCALL_DEFINE0(auth)
{
  printk(KERN_INFO "[hello from kernel] \n");
  
  return 0;
}

