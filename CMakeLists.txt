if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set (SSL_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/no-asm)
else()
    set (SSL_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR})
endif()


if (QT_VERSION LESS 5.12.4)
    message(QT_VERSION)
    if (CMAKE_ANDROID_ARCH_ABI STREQUAL "armeabi-v7a")
        set(ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/Qt-5.12.3/arm/libcrypto.so
            ${SSL_ROOT_PATH}/Qt-5.12.3/arm/libssl.so
        CACHE INTERNAL "")
    endif()

    if (CMAKE_ANDROID_ARCH_ABI STREQUAL "arm64-v8a")
        set(ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/Qt-5.12.3/arm64/libcrypto.so
            ${SSL_ROOT_PATH}/Qt-5.12.3/arm64/libssl.so
        CACHE INTERNAL "")
    endif()

    if (CMAKE_ANDROID_ARCH_ABI STREQUAL "x86")
        set(ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/Qt-5.12.3/x86/libcrypto.so
            ${SSL_ROOT_PATH}/Qt-5.12.3/x86/libssl.so
        CACHE INTERNAL "")
    endif()
else()
    if (QT_VERSION EQUAL 5.12.4 OR QT_VERSION EQUAL 5.13.0)
        if (CMAKE_ANDROID_ARCH_ABI STREQUAL "armeabi-v7a")
            set(ANDROID_EXTRA_LIBS
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/arm/libcrypto.so
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/arm/libssl.so
            CACHE INTERNAL "")
        endif()

        if (CMAKE_ANDROID_ARCH_ABI STREQUAL "arm64-v8a")
            set(ANDROID_EXTRA_LIBS
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/arm64/libcrypto.so
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/arm64/libssl.so
            CACHE INTERNAL "")
        endif()

        if (CMAKE_ANDROID_ARCH_ABI STREQUAL "x86")
            set(ANDROID_EXTRA_LIBS
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/x86/libcrypto.so
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/x86/libssl.so
            CACHE INTERNAL "")
        endif()

        if (CMAKE_ANDROID_ARCH_ABI STREQUAL "x86_64")
            set(ANDROID_EXTRA_LIBS
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/x86_64/libcrypto.so
                ${SSL_ROOT_PATH}/Qt-5.12.4_5.13.0/x86_64/libssl.so
            CACHE INTERNAL "")
        endif()
    else()
        if (NOT (QT_VERSION LESS 5.14.0))
            message(${SSL_ROOT_PATH})
            set(ANDROID_EXTRA_LIBS
                ${SSL_ROOT_PATH}/latest/arm/libcrypto_1_1.so
                ${SSL_ROOT_PATH}/latest/arm/libssl_1_1.so
                ${SSL_ROOT_PATH}/latest/arm64/libcrypto_1_1.so
                ${SSL_ROOT_PATH}/latest/arm64/libssl_1_1.so
                ${SSL_ROOT_PATH}/latest/x86/libcrypto_1_1.so
                ${SSL_ROOT_PATH}/latest/x86/libssl_1_1.so
                ${SSL_ROOT_PATH}/latest/x86_64/libcrypto_1_1.so
                ${SSL_ROOT_PATH}/latest/x86_64/libssl_1_1.so
            CACHE INTERNAL "")
        else()
            if (CMAKE_ANDROID_ARCH_ABI STREQUAL "armeabi-v7a")
                set(ANDROID_EXTRA_LIBS
                    ${SSL_ROOT_PATH}/latest/arm/libcrypto_1_1.so
                    ${SSL_ROOT_PATH}/latest/arm/libssl_1_1.so
                CACHE INTERNAL "")
            endif()

            if (CMAKE_ANDROID_ARCH_ABI STREQUAL "arm64-v8a")
                set(ANDROID_EXTRA_LIBS
                    ${SSL_ROOT_PATH}/latest/arm64/libcrypto_1_1.so
                    ${SSL_ROOT_PATH}/latest/arm64/libssl_1_1.so
                CACHE INTERNAL "")
            endif()

            if (CMAKE_ANDROID_ARCH_ABI STREQUAL "x86")
                set(ANDROID_EXTRA_LIBS
                    ${SSL_ROOT_PATH}/latest/x86/libcrypto_1_1.so
                    ${SSL_ROOT_PATH}/latest/x86/libssl_1_1.so
                CACHE INTERNAL "")
            endif()

            if (CMAKE_ANDROID_ARCH_ABI STREQUAL "x86_64")
                set(ANDROID_EXTRA_LIBS
                    ${SSL_ROOT_PATH}/latest/x86_64/libcrypto_1_1.so
                    ${SSL_ROOT_PATH}/latest/x86_64/libssl_1_1.so
                CACHE INTERNAL "")
            endif()
        endif()
    endif()
endif()

#Added Qt6 support via QT_ANDROID_EXTRA_LIBS
# With the recent update and the introduction of the QT_ANDROID_EXTRA_LIBS variable, this modification is necessary to copy the openssl files to the required path in Qt6.
# https://doc.qt.io/qt-6/cmake-target-property-qt-android-extra-libs.html
if(QT_VERSION GREATER 6.0.0)
    if (CMAKE_ANDROID_ARCH_ABI STREQUAL "armeabi-v7a")
        set_property(TARGET ${PROJECT_NAME} PROPERTY QT_ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/arm/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/arm/libssl_1_1.so
        )
    endif()

    if (CMAKE_ANDROID_ARCH_ABI STREQUAL "arm64-v8a")
        set_property(TARGET ${PROJECT_NAME} PROPERTY QT_ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/arm64/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/arm64/libssl_1_1.so
        )
    endif()

    if (CMAKE_ANDROID_ARCH_ABI STREQUAL "x86")
        set_property(TARGET ${PROJECT_NAME} PROPERTY QT_ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/x86/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/x86/libssl_1_1.so
        )
    endif()

    if (CMAKE_ANDROID_ARCH_ABI STREQUAL "x86_64")
        set_property(TARGET ${PROJECT_NAME} PROPERTY QT_ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/latest/x86_64/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/latest/x86_64/libssl_1_1.so
        )
    endif()
endif()
