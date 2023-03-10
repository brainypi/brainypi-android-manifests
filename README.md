# Compile Android 9 (AOSP) for BrainyPi

Android 9 compilation steps by community for BrainyPi. 

## Requirements 
1.  Linux Laptop/PC with docker.
2.  Minimum 250 GB of disk space. 
3.  Good internet speed. (requires approx 86 GB download) 

## Overview of steps

1.  [Setup docker container for compilation.](#1-setup-docker-container-for-compilation) 
2.  [Download source code.](#2-download-source-code)
3.  [Compile Uboot, Kernel and AOSP.](#3-compile-uboot-kernel-and-aosp)
    1.  [Compile Uboot](#3a-compile-uboot)
    1.  [Compile Kernel](#3b-compile-kernel) 
    1.  [Compile AOSP](#3c-compile-aosp)
4.  [Generate Android image.](#4-generate-android-image)
5.  [Flashing Android to BrainyPi.](#5-flashing-android-image-to-brainypi)

## 1. Setup docker container for compilation 

1.  We will be building in a docker container to avoid build dependency problems. 
1.  Build docker image
    ```sh
    git clone https://github.com/brainypi/brainypi-android-manifests.git  
    cd brainypi-android-manifests
    sudo docker build -t android-builder:9.x --build-arg USER_ID=`id -u` --build-arg GROUP_ID=`id -g` .
    ```
1.  Run docker container 
    ```sh
    sudo mkdir -p /opt/brainypi-android-build
    sudo chmod 777 /opt/brainypi-android-build
    sudo docker run -it -d -v /opt/brainypi-android-build:/home/android-builder --name android-build android-builder:9.x /bin/bash
    ```
1.  Get access to the docker container shell
    ```sh 
    sudo docker exec -it android-build /bin/bash 
    ```
    
## 2. Download source code

**Note:** Run the commands below inside the docker container shell. 

1.  Create your working folder 
    ```sh
    cd /home/android-builder
    mkdir -p brainypi-android
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
1.  Depending on your internet speed, it might take some time to download all the source code, total size of the is approximately 86GB
    
## 3. Compile Uboot, Kernel and AOSP

### 3.a Compile Uboot 

```sh
cd u-boot
./make.sh rk3399
cd ..
```

Compilation will generate images rk3399_loader_v_xxx.bin and uboot.img. 

### 3.b Compile Kernel

```sh
cd kernel
make rockchip_defconfig
make rk3399-brainypi.img -j$(nproc)
cd ..
```

Compilation will generate images kernel.img and resource.img.

### 3.c Compile AOSP 

#### Compile Android 9 Tablet

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

1.  Pack compiled code into individual images
    ```sh
    ln -s RKTools/linux/Linux_Pack_Firmware/rockdev/ rockdev
    ./mkimage.sh
    ```
2.  Generate Android image 
    1.  For Android 9 Tablet 
        ```sh 
        cd rockdev
        ln -s Image-rk3399 Image
        ./mkupdate.sh
        ./android-gpt.sh
        ```
    1.  For Android 9 TV 
        ```sh
        cd rockdev
        ln -s Image-rk3399_box Image
        ./mkupdate.sh
        ./android-gpt.sh
        ```
3.  Scripts will generate `Image/gpt.img`. This image can be flashed on EMMC or SDcard for BrainyPi.
4.  Exit from the docker container shell
    ```sh
    exit 
    ```

## 5. Flashing Android image to BrainyPi

1.  Generated Android image will be loacted in your system at `/opt/brainypi-android-build/brainypi-android/rockdev/Image/gpt.img`
2.  See the Flashing guides to flash android on BrainyPi
    1.  [Flash to Internal Storage (EMMC)](./Flashing_on_EMMC.md)
    2.  [Flash to SDcard](Flashing_on_SDcard.md)

## Need Help? 

-   Need help with **Android compilation**, Please report the problem on the forum [Link to forum](https://forum.brainypi.com/c/android/android-compilation/22)
-   Facing problems with **Android OS**, Please report the problem on the forum [Link to forum](https://forum.brainypi.com/c/android/21)
