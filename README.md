# Compile Android 9 (AOSP) for BrainyPi

## Requirements 
1.  Laptop/PC with docker installed.
2.  200 GB of disk space. 
3.  Good internet speed. 

## Overview of steps

1.  Setup docker container for compilation. 
2.  Download the Android source code.
3.  Compile Uboot, Kernel and AOSP.
    a.  Compile Uboot
    b.  Compile Kernel 
    c.  Compile AOSP
4.  Generate Android image.

## 1. Setup docker container for compilation 

1.  We will be building in a docker container to avoid build dependency problems. 
1.  Build docker image
    ```sh
    # Steps assume that you have cloned the repository 
    cd brainypi-android-manifests
    docker build -t android-builder:10.x --build-arg USER_ID=`id -u` --build-arg GROUP_ID=`id -g` .
    ```
   
1.  Run docker container 
    ```sh
    docker run -it -d --name android-build android-builder:10.x /bin/bash
    ```
1.  Get access to the docker container shell
    ```sh 
    docker exec -it android-build /bin/bash 
    ```
    
## 2. Download source code

1.  Create your working folder 
    ```sh
    cd ~/
    mkdir brainypi-android
    cd brainypi-android 
    ```
    
1.  Configure git, 
    ```sh
    git config --global user.email "<EMAIL>"
    git config --global user.name "<NAME>"
    ```
    replace your email id and name.
    
1.  Download the source code 
    ```sh
    repo init -u https://github.com/brainypi/brainypi-android-manifests.git -b android-9.0 -m brainypi-android-9.0-release.xml
    repo sync -j$(nproc)
    ```
1.  This will download the source code. 
    
## 3. Compile Uboot, Kernel and AOSP

### 3.a Compile Uboot 

```sh
cd u-boot
./make.sh rk3399
cd ..
```

### 3.b Compile Kernel

```sh
cd kernel
make rockchip_defconfig
make rk3399-brainypi.img -j$(nproc)
cd ..
```
### 3.c Compile AOSP 

#### Compile Android 9

```sh
source build/envsetup.sh
lunch rk3399-userdebug
make -j$(nproc)
```

#### Compile Android 9 TV

```sh
source build/envsetup.sh
lunch rk3399_box-userdebug
make -j$(nproc)
```

## 4. Generate Android image
