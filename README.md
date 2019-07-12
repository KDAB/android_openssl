# android_openssl
OpenSSL scripts and bins for Android (useful for Qt on Android apps)

In this repo you can find prebuilt openssl libs for Android and a qmake `.pri` file.

The following branches/tag(s) are available
* `1.0.x` branch has OpenSSL 1.0.x which can be used with **Qt up to 5.12.3**
* `5.12.4_5.13.0` tag has OpenSSL 1.1.x which can be used **ONLY with 5.12.4 and 5.13.0**. Be aware that on Android 5 (API 21) these libs names are clasing with the system SSL libs which are using OpenSSL 1.0, this means your Qt app will fail to use OpenSSL 1.1 as the system ones are already loaded by the OS.
* `master` branch is needed for **Qt 5.12.5+ and 5.13.1+**

To add openssl in your qmake project just add:
```
include(<path/to/android_openssl/openssl.pri)
```
to your `.pro` file
