#!/bin/sh
(
BINARIES_DIR="${0%/*}/"
cd ${BINARIES_DIR}

if [ "${1}" = "serial-only" ]; then
    EXTRA_ARGS='-nographic'
else
    EXTRA_ARGS='-serial stdio'
fi
#exec qemu-system-x86_64 -M pc,nvdimm=on -enable-kvm -cpu host -m 2G,slots=2,maxmem=10G -object memory-backend-file,id=mem1,share=on,mem-path=raw.hda,size=8G,readonly=off -kernel bzImage -drive file=rootfs.ext4,if=virtio,format=raw -append "rootwait root=/dev/vda console=tty1 console=ttyS0 nokaslr"  -net nic,model=virtio -net user ${EXTRA_ARGS}

export PATH="/home/huawei/source/buildroot/output/host/bin:${PATH}"
exec qemu-system-x86_64 -M pc -enable-kvm -cpu host -m 2G -kernel bzImage -drive file=rootfs.ext4,if=virtio,format=raw -drive file=raw.hda,if=none,id=nvm -device nvme,serial=deadbeef,drive=nvm -append "rootwait root=/dev/vda console=tty1 console=ttyS0 nokaslr" -device rtl8139,netdev=net0 -netdev user,id=net0 -object filter-dump,id=f1,netdev=net0,file=local.pcap,maxlen=50000000 -trace kvm_set_user_memory -d guest_errors -D debug.txt -monitor stdio
#exec qemu-system-x86_64 -M pc -enable-kvm -cpu host -m 2G -kernel bzImage -drive file=rootfs.ext4,if=virtio,format=raw -drive file=raw.hda,if=none,id=nvm -device nvme,serial=deadbeef,drive=nvm -append "rootwait root=/dev/vda console=tty1 console=ttyS0 nokaslr" -netdev user,id=net0,hostfwd=tcp::5555-:5556 -device e1000,netdev=net0 -object filter-dump,id=f1,netdev=net0,file=local.pcap,maxlen=50000000 -monitor stdio -d strace -D debug.txt ${EXTRA_ARGS}
)
