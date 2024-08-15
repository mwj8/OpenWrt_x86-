#!/bin/bash

shopt -s extglob
SHELL_FOLDER=$(dirname $(readlink -f "$0"))

bash $SHELL_FOLDER/../common/kernel_6.1.sh

rm -rf package/boot

rm -rf target/linux/generic/!(*-5.15) target/linux/rockchip

git_clone_path master https://github.com/coolsnowwolf/lede package/boot target/linux/rockchip
git_clone_path master https://github.com/coolsnowwolf/lede mv target/linux/generic

wget -N https://github.com/istoreos/istoreos/raw/istoreos-22.03/target/linux/rockchip/patches-5.10/304-r2s-pwm-fan.patch -P target/linux/rockchip/patches-6.1/

wget -N https://github.com/coolsnowwolf/lede/raw/master/include/kernel-6.1 -P include/

sed -i "/KernelPackage,ptp/d" package/kernel/linux/modules/other.mk

mv -f tmp/r8125 feeds/kiddin9/

sed -i -e 's,kmod-r8168,kmod-r8169,g' target/linux/rockchip/image/armv8.mk
sed -i -e 's,wpad-openssl,wpad-basic-mbedtls,g' target/linux/rockchip/image/armv8.mk

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/

sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += fdisk lsblk kmod-drm-rockchip/' target/linux/rockchip/Makefile

cp -Rf $SHELL_FOLDER/diy/* ./

sed -i 's/Ariaboard/光影猫/' target/linux/rockchip/image/armv8.mk
sed -i 's,NanoPi R2S$,NanoPi R2S / R2S Plus,' target/linux/rockchip/image/armv8.mk

echo '
CONFIG_SENSORS_PWM_FAN=y
' >> ./target/linux/rockchip/armv8/config-6.1
