<h3 id="partition">格式化實體的SD卡</h3>

1. 插入一個實體SD卡 並檢查其狀態 

```
$ lsblk
```

在此case中因我插入的是16G的SD卡 所以其狀態應會是:

```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
fd0      2:0    1     4K  0 disk
sda      8:0    0 931.5G  0 disk
├─sda1   8:1    0   100G  0 part /
├─sda2   8:2    0   350G  0 part /usr
├─sda3   8:3    0   450G  0 part /home
└─sda4   8:4    0  31.5G  0 part [SWAP]
sdb      8:16   1  14.9G  0 disk
└─sdb1   8:17   1  14.9G  0 part
```

其中可以看到其裝置/dev/sdb已成功被辨認出來

2. 創建分割區

- 行前準備

```
# fdisk /dev/sdb1
```

為了確認是否有無分割區在SD卡裡 

請輸入**p**

```
Command (m for help): p
Disk /dev/sdb1: 14.9 GiB, 15958278144 bytes, 31168512 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000
```

一旦經確認無分割區 接著可進行分割動作

---

- [x] 創建開機之分割區
- [ ] 創建根檔案系統之分割區

先來設定目標分割區的類型及大小吧

- 類型:主分割區(primary)
- 大小:200MB

分割完畢之後可使用***p***來查看分割區列表

```
Command (m for help): p
Disk /dev/sdb: 14.9 GiB, 15962472448 bytes, 31176704 sectors
Disk model: Storage Device
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot  Start      End  Sectors  Size Id Type
/dev/sdb1         2048   411647   409600  200M  83 Linux
```

但是第一分割區的格式現為Linux file system 明顯不符合我們所需的格式
所以我們必須更改為vfat

請輸入***t***以更改格式

```
Command (m for help): t
Selected partition 1
```

接著輸入Hex code(在此case中 我們需要的是vfat格式)
所以請輸入***b***

輸入***p***以確認分割區列表

```
Command (m for help): p
Disk /dev/sdb1: 14.9 GiB, 15958278144 bytes, 31168512 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot  Start      End  Sectors  Size Id Type
/dev/sdb1         2048   411647   409600  200M  b W95 FAT32
```

在這裡可看到第一分割區已是vfat格式 可以進行下一步驟了

---

- [x] 創建開機之分割區
- [x] 創建根檔案系統之分割區

由於在這裡我們只有分割2個分割區
所以基本上輸入***n***、***p*** 一直下一步即可

完整的分割區列表應會是

```
Disk /dev/sdb: 14.9 GiB, 15962472448 bytes, 31176704 sectors
Disk model: Storage Device
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot  Start      End  Sectors  Size Id Type
/dev/sdb1         2048   411647   409600  200M  b W95 FAT32
/dev/sdb2       411648 31176703 30765056 14.7G 83 Linux
```
若確認無誤 可寫入至實體的SD卡中了

此時輸入***w***便可寫入

<h3 id="format">格式化分割完畢後實體的SD卡</h3>

在分割區列表中我們可以看到``/dev/sdb1``及``/dev/sdb2``

其中``/dev/sdb1``為第一分割區 其格式為vfat 
其中``/dev/sdb2``為第二分割區 其格式為ext4 

請以root權限執行:

```
# mkfs.vfat /dev/sdb1
# mkfs.ext4 /dev/sdb2
```

確認其格式是否有誤:

```
# blkid /dev/sdb1
/dev/sdb1: SEC_TYPE="msdos" UUID="A5E5-6D25" TYPE="vfat" PARTUUID="96836fe7-01"
```

```
# blkid /dev/sdb2
/dev/sdb2: UUID="d52f1de5-b682-4241-b9f2-e881172ac775" TYPE="ext4" PARTUUID="96836fe7-02"
```
