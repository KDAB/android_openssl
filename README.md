# Android OpenSSL support for Qt
OpenSSL scripts and binaries for Android (useful for Qt Android apps)

In this repo you can find the prebuilt OpenSSL libs for Android, a QMake include project `.pri` file that can be used integrated with Qt projects, and a `.cmake` file for CMake based projects.

The following directories are available
* `ssl_3`: used for Qt 6.5.0+.
* `ssl_1_1`: for Qt Qt 5.12.5+, 5.13.1+, 5.14.0+, 5.15.0+, Qt 6.x.x up to 6.4.x

## How to use it
### QMake based projects
To add OpenSSL to your QMake project, append the following to your `.pro` project file:

```
android: include(<path/to/android_openssl/openssl.pri)
```

### CMake based projects
To add OpenSSL to your CMake project, append the following to your project's `CMakeLists.txt` file:

```
if (ANDROID)
    FetchContent_Declare(
      android_openssl
      DOWNLOAD_EXTRACT_TIMESTAMP true
      URL      https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip
#      URL_HASH MD5=c97d6ad774fab16be63b0ab40f78d945 #optional
    )
    FetchContent_MakeAvailable(android_openssl)
    include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)
endif()
```
or, if you cloned the repository into a subdirectory:

```
include(<path/to/android_openssl>/android_openssl.cmake)
```

Then

```
qt_add_executable(your_target_name ..)
qt_add_executable(your_second_target_name ..)

if (ANDROID)
    add_android_openssl_libraries(your_target_name your_second_target_name)
endif()

```

## Build Script

The build script `build_ssl.sh` can be used to rebuild the OpenSSL libraries. Since specific
versions might depend or work better with specific NDK versions, the OpenSSL<==>NDK version
combinations are defined in the script. Before running the script, check that the NDK paths
are correct for your environment.

### Build Prerequisites

Both Linux, macOS need `patchelf` command when building for OpenSSL 3+.

Additionally, for macOS you need:
- `bash` shell version 4+ is required
- `wget` command
