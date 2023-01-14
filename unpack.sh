#!/bin/bash

FILENAME="x6100udimg-v1.1.6-221102002-en.rar"
URL="https://xiegu.eu/wp-content/uploads/sites/4/2022/11/$FILENAME"

mkdir -p out/rar

if [ ! -f out/$FILENAME ]
then
	wget $URL --directory-prefix=out/
fi

if [ ! -f out/rar/sdcard.img ]
then
	cd out/rar
	unrar e ../$FILENAME
	cd -
fi

 # Disk sdcard.img: 817 MiB, 856686592 bytes, 1673216 sectors
 # Units: sectors of 1 * 512 = 512 bytes
 # Sector size (logical/physical): 512 bytes / 512 bytes
 # I/O size (minimum/optimal): 512 bytes / 512 bytes
 # Disklabel type: dos
 # Disk identifier: 0x00000000

 # Device      Boot  Start     End Sectors  Size Id Type
 # sdcard.img1 *      2048   34815   32768   16M  c W95 FAT32 (LBA)
 # sdcard.img2       34816  854015  819200  400M 83 Linux
 # sdcard.img3      854016 1673215  819200  400M  c W95 FAT32 (LBA)

if [ ! -f out/partition1 ]
then
	dd if=out/rar/sdcard.img bs=512 skip=2048 count=32768 of=out/partition1
	dd if=out/rar/sdcard.img bs=512 skip=34816 count=819200 of=out/partition2
	dd if=out/rar/sdcard.img bs=512 skip=854016 count=819200 of=out/partition3

	mkdir -p out/partition1.d
	mkdir -p out/partition2.d
	mkdir -p out/partition3.d

	7z x out/partition1 -oout/partition1.d
	7z x out/partition2 -oout/partition2.d
	7z x out/partition3 -oout/partition3.d
fi
