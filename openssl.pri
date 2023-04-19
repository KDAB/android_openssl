!contains(QT.network_private.enabled_features, openssl-linked) {
    CONFIG(release, debug|release): SSL_PATH = $$PWD
                              else: SSL_PATH = $$PWD/no-asm

    if (versionAtLeast(QT_VERSION, 6.5.0)) {
        ANDROID_EXTRA_LIBS += \
            $$SSL_PATH/ssl_3/arm64-v8a/libcrypto_3.so \
            $$SSL_PATH/ssl_3/arm64-v8a/libssl_3.so \
            $$SSL_PATH/ssl_3/armeabi-v7a/libcrypto_3.so \
            $$SSL_PATH/ssl_3/armeabi-v7a/libssl_3.so \
            $$SSL_PATH/ssl_3/x86/libcrypto_3.so \
            $$SSL_PATH/ssl_3/x86/libssl_3.so \
            $$SSL_PATH/ssl_3/x86_64/libcrypto_3.so \
            $$SSL_PATH/ssl_3/x86_64/libssl_3.so
    } else {
        ANDROID_EXTRA_LIBS += \
            $$SSL_PATH/ssl_1.1/arm64-v8a/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/arm64-v8a/libssl_1_1.so \
            $$SSL_PATH/ssl_1.1/armeabi-v7a/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/armeabi-v7a/libssl_1_1.so \
            $$SSL_PATH/ssl_1.1/x86/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/x86/libssl_1_1.so \
            $$SSL_PATH/ssl_1.1/x86_64/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/x86_64/libssl_1_1.so
    }
}
