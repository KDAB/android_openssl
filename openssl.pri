versionAtLeast(QT_VERSION, "5.14.0") {
    ANDROID_EXTRA_LIBS += \
        $$PWD/arm/libcrypto_1_1.so \
        $$PWD/arm/libssl_1_1.so \
        $$PWD/arm64/libcrypto_1_1.so \
        $$PWD/arm64/libssl_1_1.so \
        $$PWD/x86/libcrypto_1_1.so \
        $$PWD/x86/libssl_1_1.so \
        $$PWD/x86_64/libcrypto_1_1.so \
        $$PWD/x86_64/libssl_1_1.so
} else {
    equals(ANDROID_TARGET_ARCH,armeabi-v7a) {
        ANDROID_EXTRA_LIBS += \
            $$PWD/arm/libcrypto_1_1.so \
            $$PWD/arm/libssl_1_1.so
    }

    equals(ANDROID_TARGET_ARCH,arm64-v8a) {
        ANDROID_EXTRA_LIBS += \
            $$PWD/arm64/libcrypto_1_1.so \
            $$PWD/arm64/libssl_1_1.so
    }

    equals(ANDROID_TARGET_ARCH,x86) {
        ANDROID_EXTRA_LIBS += \
            $$PWD/x86/libcrypto_1_1.so \
            $$PWD/x86/libssl_1_1.so
    }

    equals(ANDROID_TARGET_ARCH,x86_64) {
        ANDROID_EXTRA_LIBS += \
            $$PWD/x86_64/libcrypto_1_1.so \
            $$PWD/x86_64/libssl_1_1.so
    }
}
