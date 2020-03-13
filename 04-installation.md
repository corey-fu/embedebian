### 安裝至目標資料夾

Create a symbol link on the local machine (Absolute path)

Usage : ln -s $Source $Target

```bash
$ ln -s /home/coreyfu/docker/debian/buster/mnt_share/raspi/boot /home/coreyfu/Embedded/debian/arch/armhf/boot
$ ln -s /home/coreyfu/docker/debian/buster/mnt_share/raspi/rootfs /home/coreyfu/Embedded/debian/arch/armhf/rootfs
```

Then **Back to docker container**

## Boot Section

Copy files from offcial repository

```bash
$ cd $BootDir
$ svn checkout https://github.com/raspberrypi/firmware/trunk/boot/
$ rm -rf boot/.svn
$ cp ../linux/arch/arm/boot/dts/*-rpi-3-b*.dtb .
$ cp boot/{start.elf,start_cd.elf,start_db.elf,start_x.elf} .
$ cp boot/{fixup.dat,fixup_cd.dat,fixup_db.dat,fixup_x.dat} .
$ cp boot/{bootcode.bin,COPYING.linux,LICENCE.broadcom} .
$ cp -ra boot/overlays/ .
```
Install the kernel

- zImage:armhf
-  Image:arm64

```bash
$ cd linux
$ scripts/mkknlimg arch/arm/boot/zImage $BootDir/$KERNEL.img
```

## RootFileSystem Section

安裝在特定的資料夾們中

```bash
$ mkdir {boot,rootfs}
# vmlinuz systemap
$ make install INSTALL_PATH=boot
# modules
$ make modules_install INSTALL_MOD_PATH=rootfs
# headers
$ make headers_install INSTALL_HDR_PATH=rootfs/usr
```
<!-- 

touch /etc/systemd/timesyncd.conf
sudo ln -s /lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3

- all wheels
 - kivy 1.11 : failed ( sdl2 : no avaliable video source )
 - kivy 2.x  : failed ( x11 : couldnt connect to xserver )
- part of wheels
 - kivy from source 

sdl path : 704 765

- python2
 - kivy 1.11 : works but sdl still not funtional

 -->


