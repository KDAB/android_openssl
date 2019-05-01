contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/arm/libcrypto.so \
        $$PWD/arm/libssl.so
}

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/arm64/libcrypto.so \
        $$PWD/arm64/libssl.so
}

contains(ANDROID_TARGET_ARCH,x86) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/x86/libcrypto.so \
        $$PWD/x86/libssl.so
}

contains(ANDROID_TARGET_ARCH,x86_64) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/x86_64/libcrypto.so \
        $$PWD/x86_64/libssl.so
}
