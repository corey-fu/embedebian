<h3 id="why">為何使用docker</h3>

通常我們都會習慣性地在本機端的環境上直接開發、編譯等等...

在此我們選擇使用一個乾淨的container當作開發環境

既不會弄髒本機的開發環境 如果當container建置失敗時也可直接移除重來

事情也會比較單純化

<h3 id="installing">安裝</h3>

**請注意 筆者使用的HostOS為Debian 10(Buster)**

**如果您使用的OS不是Debian系的話其package name及commands可能會不太一樣**

**請多加留意!!!**

請以root權限執行:

```
# apt install docker.io
```

<h3 id="configuration">設定</h3>

安裝完畢後 請將自己(一般使用者)加入``docker``群組中 以便往後操作

修改設定檔:

```
# vim /etc/group
```

找到docker這行:

```
docker:x:115:
```

在最尾端加上一般使用者的名稱:

```
docker:x:115:coreyfu
```

重新登出&登入即可生效

<h3 id="initializtion">初始化</h3>

先把debian官方的docker-image拉至本地端

```
$ ducker pull debian
```

確認是否已經被載下來了

```
$ docker image list
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
debian                                    latest              8e9f8546050d        12 hours ago        114MB
```

開啟docker/debian(image)的**container**

```
$ docker run -it debian bash
root@2973d9df7f84:/#
```

開啟另一Terminal確認container是否有在運行

```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS
2973d9df7f84        debian              "bash"              4 minutes ago       Up 4 minutes
```

如果發現之前開啟但已經沒在使用的container還在列表上的話 可以順便清一清

```
$ docker rm HASH-ID
```

接著先下載vim套件 以便修改``/etc/apt/sources.list``

```
root@2973d9df7f84:/# apt install vim 
root@2973d9df7f84:/# vim /etc/apt/sources.list
```

改為南臺校內鏡像站

```
deb http://120.117.72.71/debian/ buster main contrib non-free
```

試著執行``apt update`` 應該能連上並順利更新了

---

<h3 id="dockerfile">使用Dockerfile建置</h3>

由於進入以官方image為底的container 預設會直接切換至root管理員進行操作

雖然在container中以root權限亂搞是無所謂(除非你把Host的根目錄與container內的目錄掛載在一起!)

但還是不要養成壞習慣

所以我們來寫個簡略的``Dockerfile`` 進而客製化其開發環境

**注意 以下皆在HostOS的環境下執行**

```
$ vim Dockerfile
```

```dockerfile
FROM debian:latest

RUN echo "deb http://120.117.72.71/debian/ buster main contrib non-free" > /etc/apt/sources.list
RUN apt update
RUN apt install -y g++ make gawk git libncurses5-dev wget python unzip bc cpio rsync vim sudo

RUN useradd coreydocker -m -s /bin/bash

RUN echo "coreydocker ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/coreydocker
USER coreydocker
```

接著來建置屬於自己的image

```
$ docker build -t cross_build_armhf .
```

跑完後 確認是否已在image list中

```
$ docker image list
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
cross_build_armhf                         latest              0db21e089b65        About an hour ago   490MB
```

<h3 id="references">參考連結</h3>

- [User privileges in Docker containers](https://medium.com/jobteaser-dev-team/docker-user-best-practices-a8d2ca5205f4)
- [buildRoot study - 建立自己的作業系統](http://fichugh.blogspot.com/2016/02/buildroot-study.html)


