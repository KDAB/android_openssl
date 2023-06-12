# Android OpenSSL support for Qt
OpenSSL scripts and binaries for Android (useful for Qt Android apps)

In this repo you can find the prebuilt OpenSSL libs for Android and a qmake include project `.pri` file that can be used integrated with Qt projects.

The following directories are available
* `ssl_3`: used for Qt 6.5.0+.
* `ssl_1_1`: for Qt Qt 5.12.5+, 5.13.1+, 5.14.0+, 5.15.0+, Qt 6.x.x up to 6.4.x

## How to use it

To add OpenSSL in your QMake project, append the following to your `.pro` project file:

```
android: include(<path/to/android_openssl/openssl.pri)
```

To add OpenSSL in your CMake project, append the following to your project's `CMakeLists.txt` file, anywhere after the qt_add_executable() call for your target application:

```
if (ANDROID)
    include(<path/to/android_openssl/CMakeLists.txt)
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
