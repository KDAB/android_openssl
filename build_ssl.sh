#!/bin/bash -x

## Prerequisites
## The script supports builds from Linux and macOS.
## set BUILD_DIR and OUTPUT_ROOT variables to use custom build and output paths.
## Set NDK_ROOT_PREFIX to use custom Android NDK root path that contains various
## NDK versions.

set -eo pipefail

[ -n "$OUTPUT_ROOT" ] || OUTPUT_ROOT="$(pwd)"
[ -n "$BUILD_DIR" ] || BUILD_DIR="$(pwd)/build"

# Set Android NDK path prefix under the Android SDK
if [ -z "$NDK_ROOT_PREFIX" ]; then
    if [[ "$(uname)" == "Darwin" ]]; then
        NDK_ROOT_PREFIX="$HOME/Library/Android/sdk/ndk"
    else
        NDK_ROOT_PREFIX="$HOME/Android/Sdk/ndk"
    fi
fi

ssl_versions=("1.1.1w" "3.1.8")
architectures=("arm64" "arm" "x86_64" "x86")
build_types=('' 'no-asm')

get_qt_arch() {
    # takes OpenSSL arch as argument
    case $1 in
    arm64)
        echo "arm64-v8a"
        ;;
    arm)
        echo "armeabi-v7a"
        ;;
    *)
        echo $1
        ;;
    esac
}

get_ssl_build_dir() {
    # takes OpenSSL version as argument
    case $1 in
    1.1.*)
        echo "ssl_1.1"
        ;;
    3.*)
        echo "ssl_3"
        ;;
    *)
        echo $1
        ;;
    esac
}

get_ssl_ndk_version() {
    # takes OpenSSL version as argument
    case $1 in
    1.1.*)
        echo "21.4.7075529"
        ;;
    3.*)
        echo "25.2.9519653"
        ;;
    *)
        echo $1
        ;;
    esac
}

download_ssl_version() {
    ssl_version=$1
    download_dir=$2

    ssl_filename="openssl-$ssl_version.tar.gz"
    echo "Downloading OpenSSL $ssl_filename"
    if [ ! -f "$ssl_filename" ]; then
        curl -sfL -o "$download_dir/$ssl_filename" "https://www.openssl.org/source/$ssl_filename" \
            || (echo "Downloading sources failed!"; exit 1)
    fi
}

extract_package() {
    ssl_version=$1
    src_path=$2
    output_dir=$3

    echo "Extracting OpenSSL $ssl_version under $output_dir"
    rm -fr "openssl-$ssl_version"
    tar xf "$src_path/openssl-$ssl_version.tar.gz" || exit 1
}

configure_ssl() {
    ssl_version=$1
    arch=$2
    ndk=$3
    build_type=$4
    log_file=$5

    nkd_path="$NDK_ROOT_PREFIX/$ndk"

    if [ ! -e "$nkd_path" ]; then
        echo "NDK path $nkd_path does not exist"
        exit 1
    fi

    export ANDROID_NDK_ROOT="$nkd_path"
    export ANDROID_NDK_HOME="$nkd_path"

    declare hosts=("linux-x86_64" "linux-x86" "darwin-x86_64" "darwin-x86")
    for host in "${hosts[@]}"; do
        if [ -d "$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/$host/bin" ]; then
            ANDROID_TOOLCHAIN="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/$host/bin"
            export PATH="$ANDROID_TOOLCHAIN:$PATH"
            break
        fi
    done

    case $ssl_version in
    1.1.*)
        ANDROID_API=21
        # use suffix _1_1.so with OpenSSL 1.1.x (up to Qt 6.4)
        patch -p0 <<EOF
--- Configurations/15-android.conf
+++ Configurations/15-android.conf
@@ -190,6 +190,8 @@
         bn_ops           => sub { android_ndk()->{bn_ops} },
         bin_cflags       => "-pie",
         enable           => [ ],
+        shared_extension => ".so",
+        shlib_variant => "_1_1",
     },
     "android-arm" => {
         ################################################################
EOF
        ;;
    3.*)
        ANDROID_API=23
        # use suffix _3.so with OpenSSL 3.1.x (Qt 6.5.0 and above)
        patch -p0 <<EOF
--- Configurations/15-android.conf
+++ Configurations/15-android.conf
@@ -192,6 +192,7 @@
         bin_lflags       => "-pie",
         enable           => [ ],
         shared_extension => ".so",
+        shlib_variant => "_3",
     },
     "android-arm" => {
         ################################################################
EOF
        ;;
    esac

    echo "Configuring OpenSSL $ssl_version for ABI $arch with NDK $ndk"
    config_params=()

    if [ -n "$build_type" ]; then
        config_params+=( "${build_type}" )
    fi

    config_params+=( "shared" "android-${arch}" "-U__ANDROID_API__"
                     "-D__ANDROID_API__=${ANDROID_API}" )

    if [ "$arch" = "arm64" -o "$arch" = "x86_64" ]; then
	    echo "Configuring OpenSSL to 16KB page sizes"
        config_params+=( "-Wl,-z,max-page-size=16384" "-Wl,-z,common-page-size=16384" )
    fi

    echo "Configure parameters: ${config_params[@]}"
    ./Configure "${config_params[@]}" 2>&1 1>${log_file} | tee -a ${log_file} || exit 1
    make depend
}

build_ssl() {
    log_file=$1

    echo "Building..."
    make -j$(nproc) SHLIB_VERSION_NUMBER= build_libs 2>&1 1>>${log_file} \
        | tee -a ${log_file} || exit 1
}

strip_libs() {
    find . -name "libcrypto_*.so" -exec llvm-strip --strip-all {} \;
    find . -name "libssl_*.so" -exec llvm-strip --strip-all {} \;
}

copy_build_artefacts() {
    output_dir=$1

    cp libcrypto_*.so "$output_dir/" || exit 1
    cp libssl_*.so "$output_dir/" || exit 1
    cp libcrypto.a libssl.a "$output_dir" || exit 1

    # Create relative non-versioned symlinks
    ln -s $(find . -name "libcrypto_*.so" -exec basename {} \;) "${output_dir}/libcrypto.so"
    ln -s $(find . -name "libssl_*.so" -exec basename {} \;) "${output_dir}/libssl.so"
    ln -s "../include" "$output_dir/include"
}

[[ -e "$BUILD_DIR" ]] && rm -fr "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
pushd "$BUILD_DIR"

for build_type in "${build_types[@]}"; do
    if [[ "${build_type}" ]]; then
        mkdir -p $build_type
        pushd $build_type
    fi
    for ssl_version in "${ssl_versions[@]}"; do
        ndk=$(get_ssl_ndk_version $ssl_version)
        version_build_dir=$(get_ssl_build_dir $ssl_version)
        mkdir -p $version_build_dir
        pushd $version_build_dir

        download_ssl_version $ssl_version $BUILD_DIR

        for arch in "${architectures[@]}"; do
            qt_arch=$(get_qt_arch $arch)

            extract_package $ssl_version $BUILD_DIR $version_build_dir
            mv "openssl-$ssl_version" "openssl-$ssl_version-$arch"
            pushd "openssl-$ssl_version-$arch" || exit 1

            log_file="build_${arch}_${ssl_version}.log"
            configure_ssl ${ssl_version} ${arch} "${ndk}" "${build_type}" ${log_file}

            # Delete existing build artefacts
            output_dir="$OUTPUT_ROOT/$build_type/$version_build_dir/$qt_arch"
            rm -fr "$output_dir"
            mkdir -p "$output_dir" || exit 1

            build_ssl ${log_file}
            strip_libs
            copy_build_artefacts ${output_dir}

            # Copy the include dir only once since since it's the same for all abis
            if [ ! -d "$output_dir/../include" ]; then
                cp -a include "$output_dir/../" || exit 1

                # Clean include folder
                find "$output_dir/../" -name "*.in" -delete
                find "$output_dir/../" -name "*.def" -delete
            fi

            popd
        done
        popd
    done
    [[ "${build_type}" ]] && popd
done
