#!/bin/bash

VERSION=1.0.2r
export ANDROID_NDK_ROOT=~/android/android-ndk-r10e
export ANDROID_API=android-21

if [ ! -f "openssl-$VERSION.tar.gz" ]; then
    wget https://www.openssl.org/source/openssl-$VERSION.tar.gz
fi

for arch in "x86" "aarch64" "arm"
do
    rm -fr $arch
    mkdir $arch
    rm -fr openssl-$VERSION
    tar xfa openssl-$VERSION.tar.gz
    cd openssl-$VERSION

    case $arch in
        arm)
            export ANDROID_PLATFORM=arch-arm
            export ANDROID_EABI="arm-linux-androideabi-4.9"
            export CROSS_COMPILE="arm-linux-androideabi-"
            CONF_PARAM=android
            ;;
        aarch64)
            export ANDROID_PLATFORM=arch-arm64
            export ANDROID_EABI="aarch64-linux-android-4.9"
            export CROSS_COMPILE="aarch64-linux-android-"
            CONF_PARAM=android
            ;;
        x86)
            export ANDROID_PLATFORM=arch-x86
            export ANDROID_EABI="x86-4.9"
            export CROSS_COMPILE="i686-linux-android-"
            CONF_PARAM=android-x86
            ;;
#         x86_64)
#             export ANDROID_EABI="x86_64-4.9"
#             export ANDROID_ARCH=arch-x86_64
#             export ARCH=x86_64
#             export CROSS_COMPILE=x86_64-linux-android-
#             CONF_PARAM="linux-generic64 no-asm -m64 -no-ssl2 -no-ssl3 -no-comp -no-hw --cross-compile-prefix=$CROSS_COMPILE"
#             ;;
    esac
    export SYSTEM=android
    export ANDROID_SYSROOT=$ANDROID_NDK_ROOT/platforms/$ANDROID_API/$ANDROID_PLATFORM
    export ANDROID_DEV=$ANDROID_SYSROOT/usr
    export CFLAGS="--sysroot=$ANDROID_SYSROOT"
    export CPPFLAGS="--sysroot=$ANDROID_SYSROOT"
    export CXXFLAGS="--sysroot=$ANDROID_SYSROOT"

    ANDROID_TOOLCHAIN=""
    for host in "linux-x86_64" "linux-x86" "darwin-x86_64" "darwin-x86"
    do
        if [ -d "$ANDROID_NDK_ROOT/toolchains/$ANDROID_EABI/prebuilt/$host/bin" ]; then
            ANDROID_TOOLCHAIN="$ANDROID_NDK_ROOT/toolchains/$ANDROID_EABI/prebuilt/$host/bin"
            break
        fi
    done

    export PATH="$ANDROID_TOOLCHAIN":"$PATH"

    ./Configure shared $CONF_PARAM || exit 1
    make depend
    make -j$(nproc) CALC_VERSIONS="SHLIB_COMPAT=; SHLIB_SOVER=" build_libs || exit 1
    ${CROSS_COMPILE}strip -s libcrypto.so
    ${CROSS_COMPILE}strip -s libssl.so
    cp libcrypto.so ../$arch
    cp libssl.so ../$arch
    cd ..
done
