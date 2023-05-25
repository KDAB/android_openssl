# Android OpenSSL support for Qt
OpenSSL scripts and binaries for Android (useful for Qt Android apps)

In this repo you can find the prebuilt OpenSSL libs for Android, a qmake include project `.pri` file that can be used integrated with Qt projects, and a CMakeLists file for cmake based projects.

The following directories are available
* `ssl_3`: used for Qt 6.5.0+.
* `ssl_1_1`: for Qt Qt 5.12.5+, 5.13.1+, 5.14.0+, 5.15.0+, Qt 6.x.x up to 6.4.x

## How to use it

To add OpenSSL in your QMake project, append the following to your `.pro` project file:

```
android: include(<path/to/android_openssl/openssl.pri)
```

To add OpenSSL in your CMake project, append the following to your project's `CMakeLists.txt` file:

```
if (ANDROID)
    FetchContent_Declare(
      android_openssl
      DOWNLOAD_EXTRACT_TIMESTAMP true
      URL      https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip
#      URL_HASH MD5=c97d6ad774fab16be63b0ab40f78d945 #optional
    )
    FetchContent_MakeAvailable(android_openssl)
endif()
```
or, if you cloned the repository into a subdirectory:

```
add_subdirectory(<path/to/android_openssl>)
```

And later

```
qt_add_executable(your_target_name ..)
qt_add_executable(your_second_target_name ..)

if (ANDROID)
    android_add_openssl_to_targets(your_target_name your_second_target_name)
endif()

```
