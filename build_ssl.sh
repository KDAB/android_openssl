#!/bin/bash

rm -fr static
mkdir -p static/lib
mkdir -p static/include
BUILD_DIR=$(pwd)
DEFAULT_PATH=$PATH

# This has been tested with NDK 20.0.5594570 (r20b) and NDK r10e (for old GCC toolchian)
# Set the correct NDK paths for the mentioned NDK versions first
declare -A version_for_ndk=( ["1.1.1d"]=~/Android/Sdk/ndk/20.0.5594570 ["1.1.1c"]=~/Android/Sdk/ndk/20.0.5594570 ["1.0.2u"]=~/Android/Sdk/ndk/android-ndk-r10e)
declare -A version_for_path=( ["1.1.1d"]="latest" ["1.1.1c"]="Qt-5.12.4_5.13.0" ["1.0.2u"]="Qt-5.12.3" )
declare -A qt_architectures=( ["x86_64"]="x86_64" ["x86"]="x86" ["arm64"]="arm64-v8a" ["arm"]="armeabi-v7a" )
declare hosts=( "linux-x86_64" "linux-x86" "darwin-x86_64" "darwin-x86" )

for version in ${!version_for_ndk[@]}
do
    export ANDROID_NDK_HOME=${version_for_ndk[$version]}

    if [ ! -f "openssl-$version.tar.gz" ]; then
        wget https://www.openssl.org/source/openssl-$version.tar.gz
    fi

    for arch in ${!qt_architectures[@]}
    do
        rm -fr $arch
        mkdir -p ${version_for_path[$version]}/$arch
        rm -fr openssl-$version
        tar xfa openssl-$version.tar.gz
        cd openssl-$version
        ANDROID_TOOLCHAIN=""

        if [ $version == "1.1.1c" ] || [ $version == "1.1.1d" ]; then
            case $arch in
                arm)
                    ANDROID_API=16
                    ;;
                x86)
                    ANDROID_API=16
                    ;;
                arm64)
                    ANDROID_API=21
                    ;;
                x86_64)
                    ANDROID_API=21
                    ;;
            esac

            for host in ${hosts[@]}
            do
                if [ -d "$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$host/bin" ]; then
                    ANDROID_TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$host/bin"
                    break
                fi
            done

            export PATH="$ANDROID_TOOLCHAIN:$DEFAULT_PATH"

            ./Configure shared android-${arch} -D__ANDROID_API__=${ANDROID_API} || exit 1
            make depend
            make -j$(nproc) SHLIB_VERSION_NUMBER= SHLIB_EXT=_1_1.so build_libs || exit 1
            llvm-strip -strip-all libcrypto_1_1.so
            llvm-strip -strip-all libssl_1_1.so
        else
            # For Older NDK r10e
            case $arch in
                arm)
                    export ANDROID_EABI="arm-linux-androideabi-4.9"
                    export CROSS_COMPILE="arm-linux-androideabi-"
                    export ANDROID_API=android-9
                    CONF_PARAM=android
                    ;;
                aarch64)
                    export ANDROID_EABI="aarch64-linux-android-4.9"
                    export CROSS_COMPILE="aarch64-linux-android-"
                    export ANDROID_API=android-21
                    CONF_PARAM=android
                    ;;
                x86)
                    export ANDROID_EABI="x86-4.9"
                    export CROSS_COMPILE="i686-linux-android-"
                    export ANDROID_API=android-9
                    CONF_PARAM=android-x86
                    ;;
                *)
                    break
            esac

            export ANDROID_PLATFORM=arch-$arch
            export SYSTEM=android
            export ANDROID_SYSROOT=$ANDROID_NDK_HOME/platforms/$ANDROID_API/$ANDROID_PLATFORM
            export ANDROID_DEV=$ANDROID_SYSROOT/usr
            export CFLAGS="--sysroot=$ANDROID_SYSROOT"
            export CPPFLAGS="--sysroot=$ANDROID_SYSROOT"
            export CXXFLAGS="--sysroot=$ANDROID_SYSROOT"

            for host in ${hosts[@]}
            do
                if [ -d "$ANDROID_NDK_HOME/toolchains/$ANDROID_EABI/prebuilt/$host/bin" ]; then
                    ANDROID_TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/$ANDROID_EABI/prebuilt/$host/bin"
                    break
                fi
            done

            export PATH="$ANDROID_TOOLCHAIN:$DEFAULT_PATH"

            ./Configure shared $CONF_PARAM || exit 1
            make depend
            make -j$(nproc) CALC_VERSIONS="SHLIB_COMPAT=; SHLIB_SOVER=" build_libs || exit 1
            ${CROSS_COMPILE}strip -s libcrypto.so
            ${CROSS_COMPILE}strip -s libssl.so

            # Unset variables so they don't interfere with different versions
            unset CXXFLAGS CPPFLAGS CFLAGS ANDROID_DEV ANDROID_SYSROOT SYSTEM ANDROID_PLATFORM CONF_PARAM CROSS_COMPILE ANDROID_EABI
        fi

        # Only for latest OpenSSL with Qt 5.14.1+
        if [ $version == "1.1.1d" ]; then
            cp libcrypto_1_1.so libssl_1_1.so ../${version_for_path[$version]}/$arch
            mv libcrypto.a ../static/lib/libcrypto_${qt_architectures[$arch]}.a
            mv libssl.a ../static/lib/libssl_${qt_architectures[$arch]}.a
        else
            cp libcrypto.so libssl.so ../${version_for_path[$version]}/$arch
        fi
        cd ..
    done

    # Copy include files to static folder
    cd $BUILD_DIR
    if [ $version == "1.1.1d" ]; then
        cp -a openssl-$version/include/openssl static/include
    fi
    rm -fr openssl-$version openssl-$version.tar.gz
done
