<h3 id="compiling">開始編譯</h3>

開啟以cross_build(image)為底的container

***記得要掛載共享資料夾喔! 這樣會比較方便把編譯完畢的成品拿出來***

其指令為:docker run -v [本地資料夾]:[container裡的資料夾] -it [image_name]

```bash
$ docker run -v /home/coreyfu/docker/debian/buster/mnt_share:/home/coreydocker/ -it cross_build
```

進入該使用者的家目錄並下載raspberrypi的linux原始碼

```bash
$ cd ~
$ mkdir raspi && cd raspi
$ git clone https://github.com/raspberrypi/linux
```

環境設定

- armhf

```bash
$ export ARCH=arm
$ export CROSS_COMPILE=arm-linux-gnueabihf- 
$ export KERNEL=kernel7
$ make bcm2709_defconfig (RPI-3B+)
```

- arm64

```bash
$ export ARCH=arm64
$ export CROSS_COMPILE=aarch64-linux-gnu-
$ export KERNEL=kernel8
$ make defconfig
```

**If you want to enable or disable some features (eg.virtualization)**

```
$ make menuconfig
[*] Virtualization  ---> 
 --- Virtualization                                                 
      <M>   Host kernel accelerator for virtio net                 
      [*]   Cross-endian support for vhost

Device Drivers  --->
    Graphics support  --->
	<M> Broadcom V3D 3.x and newer             
	<M> Broadcom VC4 Graphics        
	[*]   Broadcom VC4 HDMI CEC Support
    [*] Staging drivers  --->
	<*>   Broadcom VideoCore support  --->
		{M}   BCM2835 VCHIQ                                            
		<M>   BCM2835 Audio                                             
		<M>   BCM2835 Camera                                      
		{M}   BCM2835 MMAL VCHIQ service                             
		-M-   VideoCore Shared Memory (CMA) driver                     
		<M>   BCM2835 Video codec support
```
Start Compiling with your maximum cpu cores

```bash
$ make all -j $CORES
```





