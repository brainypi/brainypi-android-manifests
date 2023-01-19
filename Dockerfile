FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update -y && apt-get install -y python3.8
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 150
RUN apt-get install -y python3-pip && pip3 install pycrypto

RUN apt-get update -y && apt-get install -y openjdk-8-jdk python git-core gnupg flex bison \ 
    gperf build-essential liblz4-tool zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
    lib32ncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
    libgl1-mesa-dev libxml2-utils xsltproc unzip mtools u-boot-tools \
    htop iotop sysstat iftop pigz bc device-tree-compiler lunzip \
    dosfstools vim-common parted udev libssl-dev  sudo rsync python3-pyelftools cpio zip gawk 
RUN pip3 install pycrypto
RUN apt install -y wget
RUN wget 'https://storage.googleapis.com/git-repo-downloads/repo' -P /tmp/ && cp -arv /tmp/repo /usr/local/bin/repo && chmod +x /usr/local/bin/repo

ENV USER=android-builder
ARG USER_ID=999
ARG GROUP_ID=999
RUN groupadd -g ${GROUP_ID} android-builder && useradd -m -g android-builder -u ${USER_ID} android-builder

USER android-builder
