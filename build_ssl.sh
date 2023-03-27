#!/bin/bash

BUILD_DIR=$(pwd)
DEFAULT_PATH=$PATH

declare -a params=( 'no-asm' '' )
declare -A ssl_versions=( ["3.1.0"]=$HOME/android/ndk/25.1.8937393 ["1.1.1t"]=$HOME/android/ndk/25.1.8937393 )

# Qt up to 6.4 is using OpenSSL 1.1.x but the library is suffixed with _1_1.so
# Qt 6.5.0+ is using OpenSSL 3.1.x but the library is suffixed with _3_1.so

declare -A versions=( ["ssl_3"]="3.1*" ["ssl_1.1"]="1.1*" )
declare -A architectures=( ["x86_64"]="x86_64" ["x86"]="x86" ["arm64"]="arm64-v8a" ["arm"]="armeabi-v7a" )
declare hosts=( "linux-x86_64" "linux-x86" "darwin-x86_64" "darwin-x86" )

for param in ${!params[@]}
do
    if [ ${params[$param]} ]; then
        rm -fr ${params[$param]}
        mkdir ${params[$param]}
        pushd ${params[$param]}
    fi
    for ssl_version in ${!ssl_versions[@]}
    do
        echo "SSL version = $ssl_version"
        if [ ! -f "openssl-$ssl_version.tar.gz" ]; then
            wget https://www.openssl.org/source/openssl-$ssl_version.tar.gz
        fi
        export ANDROID_NDK_HOME="${ssl_versions[$ssl_version]}"
        export ANDROID_NDK_ROOT="${ssl_versions[$ssl_version]}"

        for version in ${!versions[@]}
        do
            if [[ $ssl_version != ${versions[$version]} ]]; then
                continue;
            fi
            echo "Build $ssl_version for $version"
            for arch in ${!architectures[@]}
            do
                qt_arch=${architectures[$arch]}
                rm -fr $qt_arch $version/$qt_arch
                mkdir -p $version/$qt_arch || exit 1
                rm -fr openssl-$ssl_version
                tar xfa openssl-$ssl_version.tar.gz || exit 1
                pushd openssl-$ssl_version || exit 1
                ANDROID_TOOLCHAIN=""
                case $arch in
                    arm)
                        ANDROID_API=19
                        ;;
                    x86)
                        ANDROID_API=19
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
                echo "./Configure ${params[$param]} shared android-${arch} -D__ANDROID_API__=${ANDROID_API} || exit 1"
                ./Configure ${params[$param]} shared android-${arch} -D__ANDROID_API__=${ANDROID_API} || exit 1
                make depend

                case $version in
                    ssl_1.1)
                        make -j$(nproc) SHLIB_VERSION_NUMBER= SHLIB_EXT=_1_1.so build_libs || exit 1
                        llvm-strip --strip-all libcrypto_1_1.so
                        llvm-strip --strip-all libssl_1_1.so
                        cp libcrypto_1_1.so libssl_1_1.so ../$version/$qt_arch || exit 1
                        cp libcrypto.a libssl.a ../$version/$qt_arch || exit 1
                        ;;
                    ssl_3)
                        make -j$(nproc) SHLIB_VERSION_NUMBER= build_libs || exit 1
                        llvm-strip --strip-all libcrypto.so
                        llvm-strip --strip-all libssl.so
                        cp libcrypto.a libssl.a ../$version/$qt_arch || exit 1
                        cp libcrypto.so ../$version/$qt_arch/libcrypto_3.so || exit 1
                        cp libssl.so ../$version/$qt_arch/libssl_3.so || exit 1
                        pushd ../$version/$qt_arch || exit 1
                        patchelf --set-soname libcrypto_3.so libcrypto_3.so || exit 1
                        patchelf --set-soname libssl_3.so libssl_3.so || exit 1
                        patchelf --replace-needed libcrypto.so libcrypto_3.so libssl_3.so || exit 1
                        popd
                        ;;
                    *)
                        echo "Unhandled ssl version $version"
                        exit 1
                        ;;
                esac

                if [ $arch == "arm64" ] && [ ! -d ../$version/include/openssl ]; then
                    cp -a include ../$version || exit 1
                fi
                popd
            done
        done
        rm -fr openssl-$ssl_version
        rm openssl-$ssl_version.tar.gz
    done
    if [ ${params[$param]} ]; then
        popd
    fi
done

# Clean include folder
find . -name *.in | xargs rm
find . -name *.def | xargs rm
