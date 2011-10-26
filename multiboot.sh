#!/bin/sh

DEVICE=/dev/sdb
VOLUME=multibootusb


# create filesystem on usb pen
sudo mkfs.vfat -n ${VOLUME} ${DEVICE}1


# mount usb
sudo mount ${DEVICE}1 /mnt/


# install grub2 on usb pen
sudo grub-install --no-floppy --force --root-directory=/mnt ${DEVICE}


# create grub config
cat <<EOF> /mnt/boot/grub/grub.cfg
set color_normal='light-blue/black'
set color_highlight='light-cyan/blue'

menuentry "Ubuntu Live 11.04 64bit" {
loopback loop /boot/iso/ubuntu-11.04-desktop-amd64.iso
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=/boot/iso/ubuntu-11.04-desktop-amd64.iso noeject noprompt --
initrd (loop)/casper/initrd.lz
}

menuentry "Ubuntu Live 9.10 32bit" {
loopback loop /boot/iso/ubuntu-9.10-desktop-i386.iso
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=/boot/iso/ubuntu-9.10-desktop-i386.iso noeject noprompt --
initrd (loop)/casper/initrd.lz
}

menuentry "Ubuntu Live 9.10 64bit" {
loopback loop /boot/iso/ubuntu-9.10-desktop-amd64.iso
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=/boot/iso/ubuntu-9.10-desktop-amd64.iso noeject noprompt --
initrd (loop)/casper/initrd.lz
}

menuentry "Grml small 2009.10" {
loopback loop /boot/iso/grml-small_2009.10.iso
linux (loop)/boot/grmlsmall/linux26 findiso=/boot/iso/grml-small_2009.10.iso apm=power-off lang=us vga=791 boot=live nomce noeject noprompt --
initrd (loop)/boot/grmlsmall/initrd.gz
}

menuentry "tinycore" {
loopback loop /boot/iso/tinycore_2.3.1.iso
linux (loop)/boot/bzImage --
initrd (loop)/boot/tinycore.gz
}

menuentry "Netinstall 32 preseed" {
loopback loop /boot/iso/mini.iso
linux (loop)/linux auto url=http://www.panticz.de/pxe/preseed/preseed.seed locale=en_US console-setup/layoutcode=de netcfg/choose_interface=eth0 debconf/priority=critical --
initrd (loop)/initrd.gz
}

menuentry "debian-installer-amd64.iso" {
loopback loop /boot/iso/debian-installer-amd64.iso
linux (loop)/linux vga=normal --
initrd (loop)/initrd.gz
}

menuentry "BackTrack 4" {
linux /boot/bt4/boot/vmlinuz BOOT=casper boot=casper nopersistent rw vga=0x317 --
initrd /boot/bt4/boot/initrd.gz
}

menuentry "Memory test (memtest86+)" {
linux16 /boot/img/memtest86+.bin
}

menuentry "BackTrack ERR" {
loopback loop /boot/iso/bt4-pre-final.iso
linux (loop)/boot/vmlinuz find_iso/filename=/boot/iso/bt4-pre-final.iso BOOT=casper boot=casper nopersistent rw vga=0x317--
initrd (loop)/boot/initrd.gz
}

menuentry "XBMC ERR" {
loopback loop /boot/iso/XBMCLive.iso
linux (loop)/vmlinuz boot=cd isofrom=/dev/sda1/boot/iso/XBMCLive.iso xbmc=nvidia,nodiskmount,tempfs,setvolume loglevel=0 --
initrd (loop)/initrd0.img
}

menuentry "netboot.me" {
loopback loop /boot/iso/netbootme.iso
linux16 (loop)/GPXE.KRN
}

menuentry "debian installer amd64 netboot XEN pressed" {
linux /boot/debian/linux auto preseed/url=http://www.panticz.de/pxe/preseed/xen.seed locale=en_US console-setup/layoutcode=de netcfg/choose_interface=eth0 debconf/priority=critical --
initrd /boot/debian/initrd.gz
}

menuentry "System Rescue CD" {
 loopback loop /iso/systemrescuecd-x86-2.3.1.iso
 linux (loop)/isolinux/rescuecd isoloop=/iso/systemrescuecd-x86-2.3.1.iso setkmap=us docache dostartx
 initrd (loop)/isolinux/initram.igz
}

menuentry "Parted Magic Disk Utilities" {
 loopback loop /iso/pmagic-6.2.iso
 linux (loop)/pmagic/bzImage iso_filename=/iso/pmagic-6.2.iso edd=off noapic load_ramdisk=1 prompt_ramdisk=0 rwnomce sleep=10 loglevel=0
 initrd (loop)/pmagic/initramfs
}

menuentry "Ubuntu 11.04" {
 loopback loop /iso/ubuntu-11.04-desktop-i386.iso
 linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=/iso/ubuntu-11.04-desktop-i386.iso noeject noprompt --
 initrd (loop)/casper/initrd.lz
}

menuentry "Arch Linux i686" {
 loopback loop /iso/archlinux-2011.10-1-archboot.iso
 linux (loop)/boot/vmlinuz rootdelay=10
 initrd (loop)/boot/initrd.img
}

menuentry "Arch Linux x86_64" {
 loopback loop /iso/archlinux-2011.10-1-archboot.iso
 linux (loop)/boot/vm64 rootdelay=10
 initrd (loop)/boot/initrd64.img
}

menuentry "FreeBSD 8.2 i386" {
 set isofile=/iso/FreeBSD-8.2-RELEASE-i386-disc1.iso
 loopback loop $isofile
 kfreebsd (loop)/boot/kernel/kernel iso-scan/filename=$isofile noeject noprompt splash --
 kfreebsd_module (loop)/boot/mfsroot.gz type=mfs_root
}

menuentry "FreeBSD 8.2 x86_64" {
 set isofile=/iso/FreeBSD-8.2-RELEASE-amd64-disc1.iso
 loopback loop $isofile
 kfreebsd (loop)/boot/kernel/kernel iso-scan/filename=$isofile noeject noprompt splash --
 kfreebsd_module (loop)/boot/mfsroot.gz type=mfs_root
}
EOF

# create iso directory
sudo mkdir /mnt/boot/iso
