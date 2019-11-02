#!/bin/bash
kernel_name="sechack"
linux_version="5.3.5"
JOBS=$[$(grep cpu.cores /proc/cpuinfo | sort -u | sed 's/[^0-9]//g') + 1]

function init (){
	local url="https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-${linux_version}.tar.xz"
	local syscall_num=436
	local syscall_tbl="arch/x86/entry/syscalls/syscall_64.tbl"
	local syscall_name="auth"
	local incert_line="${syscall_num}	common	${syscall_name}			__x64_sys_${syscall_name}"
	local func_name="sysauth.c"
	local sys_c="kernel/sys.c"

	if [ -e "linux-${linux_version}.tar.xz" ]; then 
		echo "note: linux sorce code was already donwloaded"
	else	
		curl -O -J ${url}
	fi

	if [ -e "linux-${linux_version}/" ]; then 
		echo "note: linux sorce code was already expanded"
	else	
		tar xvf linux-${linux_version}.tar.xz
	fi

	cd ./linux-${linux_version}

	cat ../config > .config 

	if grep "${incert_line}" ${syscall_tbl} > /dev/null; then
		echo "note: syscall:${syscall_num} was already incerted in syscall table"
	else
		sed -i -e '/^CONFIG_LOCALVERSION=/s/\".\+\"$/\"-'${kernel_name}'\"/gi' .config
		
		local incert_num=`cat ${syscall_tbl} | grep -n \`expr ${syscall_num} - 1\` | sed -e 's/:.*//g'`
		incert_num=`expr ${incert_num} + 1`
		
		sed -i -e "${incert_num}i ${incert_line}" ${syscall_tbl} 
	fi

	incert_line="#include \"../../src/${func_name}\""
	if grep "${incert_line}" ${sys_c} > /dev/null; then
		echo "note: ${func_name} was already included in kernel/sys.c"
	else
		echo "${incert_line}" >> ${sys_c}
	fi

	make oldconfig
}

function build (){
	cd ./linux-${linux_version}

	make -j${JOBS}
}

function deploy (){
	cd ./linux-${linux_version}

	make -j${JOBS}
	make -j${JOBS} modules_install 

	cp arch/x86_64/boot/bzImage /boot/vmlinuz-linux-${kernel_name}

	sed s/linux/linux-${kernel_name}/g \
	    </etc/mkinitcpio.d/linux.preset \
	   	>/etc/mkinitcpio.d/linux-${kernel_name}.preset
	mkinitcpio -p linux-${kernel_name}

	grub-mkconfig -o /boot/grub/grub.cfg
}

function clean (){
	rm -rf linux-${linux_version}*
}


# --- main ---

set -e

if [ $# -eq 0 ]; then
	echo "error: argument is required"
	exit 1
fi

echo $1

if [ $1 = "init" ]; then
	init
elif [ $1 = "build" ]; then
	build
elif [ $1 = "deploy" ]; then
	deploy
elif [ $1 = "clean" ]; then
	clean
else
	echo "error: invalid argument"
fi

exit 0

