<h3 id="compiling">開始編譯</h3>

開啟以cross_build_armhf(image)為底的container

***記得要掛載共享資料夾喔! 這樣會比較方便把編譯完畢的img拿出來***

其指令為:docker run -v [本地資料夾]:[container裡的資料夾] -it [image_name]

```
$ docker run -v /home/coreyfu/docker/debian/buster/mnt_share:/home/coreydocker/ -it cross_build_armhf
```

下載buildroot目錄

```
$ git clone https://github.com/buildroot/buildroot
```

進至目錄並查看buildroot目前支援的開發版類型

```
$ cd buildroot && ls -l board
```

可以看到當中有``raspberrypi3_defconfig``

接著開始編譯預設組態(以raspi3為例)

```
$ make raspberrypi3_defconfig
... 略
#
# configuration written to /home/coreypi/buildroot/.config
#
```

開始本番!

```
$ make 2>&1 | tee build.log
```

註:編譯的時間還蠻長的 可以考慮休息或是放韓假三個月囉~


編譯完成後在output/images中會有``sdcard.img`` 

```
$ ls -l output/images/
total 232656
-rw-r--r-- 1 coreydocker coreydocker     27082 Oct 18 12:31 bcm2710-rpi-3-b-plus.dtb
-rw-r--r-- 1 coreydocker coreydocker     26463 Oct 18 12:31 bcm2710-rpi-3-b.dtb
-rw-r--r-- 1 coreydocker coreydocker     25261 Oct 18 12:31 bcm2710-rpi-cm3.dtb
-rw-r--r-- 1 coreydocker coreydocker  33554432 Oct 18 12:31 boot.vfat
-rw-r--r-- 1 coreydocker coreydocker 125829120 Oct 18 12:31 rootfs.ext2
lrwxrwxrwx 1 coreydocker coreydocker        11 Oct 18 12:31 rootfs.ext4 -> rootfs.ext2
drwxr-xr-x 3 coreydocker coreydocker       113 Oct 18 12:15 rpi-firmware
-rw-r--r-- 1 coreydocker coreydocker 159384064 Oct 18 12:31 sdcard.img
-rw-r--r-- 1 coreydocker coreydocker   5278208 Oct 18 12:31 zImage
```

查看大小

```
$ du -sh output/images/sdcard.img
153M    output/images/sdcard.img
```

即使對比官方lite的img檔 我們得到了一個很精簡的img檔

這麼做的目的是為了得到最精簡的系統 除了系統指令 幾乎沒有多餘的packages

接著將其燒錄至實體sdcard

```
$ cd mnt_share/buildroot/output/images/
$ sudo dd if=sdcard.img of=/dev/sdb bs=16M
```

這樣應該就能正常開機了

***But...*** 上述的說明其實都是針對樹莓派3的預設組態設定

如果沒有事先設定的話開機後會遇上許多問題

例如shell的問題 請看下圖

![](./IMG_2936.jpg)

當輸入``cat /etc/shells`` 會發現沒有bash 導致實際操作起來綁手綁腳

這時我們就要自訂參數

```
$ make menuconfig
```

- 目標參數

```
Target options  --->
	Target Architecture --->
		(X) ARM (little endian)
	Target Architecture Variant --->
		(X) cortex-A53
```

- 系統設定

```
System configuration  ---> 
	(KioskClient2) System hostname // 設定主機名稱
	(Welcome to KioskClient2) System banner // 開機完畢並登入時所顯示的訊息
	Init system (BusyBox)  ---> // 進到選單內選擇開機起始程式
		(X) BusyBox                                                x x
                ( ) systemV                                                x x
                ( ) OpenRC                                                 x x
                    *** systemd needs a glibc toolchain w/ SSP, headers >= x x
                ( ) None  
```

### 假設解法(尚未解決)

但是這裡會發現不能選擇systemd 這是因為container內還未安裝linux-header的緣故 

先來搜尋自己的header 再自行安裝

```
$ uname -r
4.19.0-6-amd64
```

題外話:由於要切換至root權限才能安裝packages 所以開另一終端機執行:

```
$ docker exec -it --user root CONTAINER-ID bash
root@b4b6c53122cc:/#
```

接著來安裝sudo及更改root密碼 讓container內的環境跟HostOS差不多 

```
root@b4b6c53122cc:/# apt install sudo
root@b4b6c53122cc:/# echo "root:YourPasswd" | chpasswd
```

進入本番: 搜尋並安裝linux-header

```
# apt search linux-headers-$(uname -r)
Sorting... Done
Full Text Search... Done
linux-headers-4.19.0-6-amd64/stable 4.19.67-2 amd64
  Header files for Linux 4.19.0-6-amd64

---

# apt install linux-headers-$(uname -r)

```

