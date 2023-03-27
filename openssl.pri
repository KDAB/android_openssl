!contains(QT.network_private.enabled_features, openssl-linked) {
    CONFIG(release, debug|release): SSL_PATH = $$PWD
                            else: SSL_PATH = $$PWD/no-asm

    if (versionAtLeast(QT_VERSION, 6.5.0)) {
        ANDROID_EXTRA_LIBS += \
            $$SSL_PATH/ssl_3/$$ANDROID_TARGET_ARCH/libcrypto_3.so \
            $$SSL_PATH/ssl_3/$$ANDROID_TARGET_ARCH/libssl_3.so
    } else {
        ANDROID_EXTRA_LIBS += \
            $$SSL_PATH/ssl_1.1/$$ANDROID_TARGET_ARCH/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/$$ANDROID_TARGET_ARCH/libssl_1_1.so
    }
}
