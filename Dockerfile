# Base on the image of debian
FROM debian:latest

# Modify apt-sources.list
RUN echo "#deb [arch=amd64] http://120.117.72.71/debian/ buster main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb [arch=armhf,arm64] http://opensource.nchc.org.tw/debian/ buster main contrib non-free" >> /etc/apt/sources.list

# Add architectures
RUN dpkg --add-architecture armhf && dpkg --add-architecture arm64
# Install dependencies
RUN apt update -y && apt install -y \
 sed make binutils build-essential \
 gcc g++ bash patch gawk git libncurses5-dev wget python unzip \
 bc bison flex kmod libssl-dev cpio rsync vim \
 crossbuild-essential-armhf crossbuild-essential-arm64 \
 device-tree-compiler u-boot-tools

# Add a regular user (eg. coreydocker)
RUN useradd coreydocker -m -s /bin/bash \
 && echo "root:abc123" | chpasswd \
&& echo "coreydocker ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/coreydocker

# Switch in
USER coreydocker

