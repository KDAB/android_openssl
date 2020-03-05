if (lessThan(QT_VERSION, 5.12.3)) {
    contains(ANDROID_TARGET_ARCH, armeabi-v7a) {
        ANDROID_EXTRA_LIBS += \
            $$PWD/Qt-5.12.3/arm/libcrypto.so \
            $$PWD/Qt-5.12.3/arm/libssl.so
    }

    contains(ANDROID_TARGET_ARCH, arm64-v8a) {
        ANDROID_EXTRA_LIBS += \
            $$PWD/Qt-5.12.3/arm64/libcrypto.so \
            $$PWD/Qt-5.12.3/arm64/libssl.so
    }

    contains(ANDROID_TARGET_ARCH, x86) {
        ANDROID_EXTRA_LIBS += \
            $$PWD/Qt-5.12.3/x86/libcrypto.so \
            $$PWD/Qt-5.12.3/x86/libssl.so
    }
} else {
    if (equals(QT_VERSION, 5.12.4) || equals(QT_VERSION, 5.13.0)) {
        contains(ANDROID_TARGET_ARCH, armeabi-v7a) {
            ANDROID_EXTRA_LIBS += \
                $$PWD/Qt-5.12.4_5.13.0/arm/libcrypto.so \
                $$PWD/Qt-5.12.4_5.13.0/arm/libssl.so
        }

        contains(ANDROID_TARGET_ARCH, arm64-v8a) {
            ANDROID_EXTRA_LIBS += \
                $$PWD/Qt-5.12.4_5.13.0/arm64/libcrypto.so \
                $$PWD/Qt-5.12.4_5.13.0/arm64/libssl.so
        }

        contains(ANDROID_TARGET_ARCH, x86) {
            ANDROID_EXTRA_LIBS += \
                $$PWD/Qt-5.12.4_5.13.0/x86/libcrypto.so \
                $$PWD/Qt-5.12.4_5.13.0/x86/libssl.so
        }

        contains(ANDROID_TARGET_ARCH, x86_64) {
            ANDROID_EXTRA_LIBS += \
                $$PWD/Qt-5.12.4_5.13.0/x86_64/libcrypto.so \
                $$PWD/Qt-5.12.4_5.13.0/x86_64/libssl.so
        }
    } else {
        versionAtLeast(QT_VERSION, "5.14.0") {
            ANDROID_EXTRA_LIBS += \
                $$PWD/latest/arm/libcrypto_1_1.so \
                $$PWD/latest/arm/libssl_1_1.so \
                $$PWD/latest/arm64/libcrypto_1_1.so \
                $$PWD/latest/arm64/libssl_1_1.so \
                $$PWD/latest/x86/libcrypto_1_1.so \
                $$PWD/latest/x86/libssl_1_1.so \
                $$PWD/latest/x86_64/libcrypto_1_1.so \
                $$PWD/latest/x86_64/libssl_1_1.so
        } else {
            equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
                ANDROID_EXTRA_LIBS += \
                    $$PWD/latest/arm/libcrypto_1_1.so \
                    $$PWD/latest/arm/libssl_1_1.so
            }

            equals(ANDROID_TARGET_ARCH, arm64-v8a) {
                ANDROID_EXTRA_LIBS += \
                    $$PWD/latest/arm64/libcrypto_1_1.so \
                    $$PWD/latest/arm64/libssl_1_1.so
            }

            equals(ANDROID_TARGET_ARCH, x86) {
                ANDROID_EXTRA_LIBS += \
                    $$PWD/latest/x86/libcrypto_1_1.so \
                    $$PWD/latest/x86/libssl_1_1.so
            }

            equals(ANDROID_TARGET_ARCH, x86_64) {
                ANDROID_EXTRA_LIBS += \
                    $$PWD/latest/x86_64/libcrypto_1_1.so \
                    $$PWD/latest/x86_64/libssl_1_1.so
            }
        }
    }
}
