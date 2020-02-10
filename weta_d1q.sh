#!/bin/bash

VER=N9700_5.02_TA1-Permissive
DEVICE=d1q
DEFCONFIG=d1q_chn_hk_defconfig

BUILD_CROSS_COMPILE=/home/mentalmuso/kernel/toolchain/4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=/home/mentalmuso/kernel/toolchain/clang/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"
KERN=/home/mentalmuso/kernel/android_kernel_samsung_sd855ta1
TODAY=`date +%Y-%m-%d.%H:%M`
WETA=$KERN/WETA
AKOLDZIP=$WETA/weta_anykernel/WETA_Kernel_*
AKOLDIMG=$WETA/weta_anykernel/zImage

export ANDROID_MAJOR_VERSION=p
export PLATFORM_VERSION=9.0.0
export ARCH=arm64

mkdir out
mkdir $WETA
mkdir $WETA/$DEVICE

### enforcing version

make -j8 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE $DEFCONFIG
time make -j9 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE

cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
cp $(pwd)/out/arch/arm64/boot/Image-dtb $(pwd)/WETA/$DEVICE/Image-dtb

cd $WETA/weta_anykernel
rm $AKOLDZIP && rm $AKOLDIMG
cp $WETA/$DEVICE/Image-dtb $WETA/weta_anykernel/zImage
zip -r -7 WETA_Kernel_$VER.zip *
mv WETA_Kernel_$VER.zip $WETA/$DEVICE

echo " "
echo "###################################"
echo "# Kernel img found in WETA folder #"
echo "###################################"
echo " "


