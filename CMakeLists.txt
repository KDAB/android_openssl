if (QT_VERSION LESS 5.12.3)
    message(QT_VERSION)
    if (ANDROID_TARGET_ARCH STREQUAL "armeabi-v7a")
        set(ANDROID_EXTRA_LIBS
            ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.3/arm/libcrypto.so
            ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.3/arm/libssl.so
        CACHE INTERNAL "")
    endif()

    if (ANDROID_TARGET_ARCH STREQUAL "arm64-v8a")
        set(ANDROID_EXTRA_LIBS
            ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.3/arm64/libcrypto.so
            ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.3/arm64/libssl.so
        CACHE INTERNAL "")
    endif()

    if (ANDROID_TARGET_ARCH STREQUAL "x86")
        set(ANDROID_EXTRA_LIBS
            ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.3/x86/libcrypto.so
            ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.3/x86/libssl.so
        CACHE INTERNAL "")
    endif()
else()
    if (QT_VERSION EQUAL 5.12.4 OR QT_VERSION EQUAL 5.13.0)
        if (ANDROID_TARGET_ARCH STREQUAL "armeabi-v7a")
            set(ANDROID_EXTRA_LIBS
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/arm/libcrypto.so
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/arm/libssl.so
            CACHE INTERNAL "")
        endif()

        if (ANDROID_TARGET_ARCH STREQUAL "arm64-v8a")
            set(ANDROID_EXTRA_LIBS
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/arm64/libcrypto.so
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/arm64/libssl.so
            CACHE INTERNAL "")
        endif()

        if (ANDROID_TARGET_ARCH STREQUAL "x86")
            set(ANDROID_EXTRA_LIBS
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/x86/libcrypto.so
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/x86/libssl.so
            CACHE INTERNAL "")
        endif()

        if (ANDROID_TARGET_ARCH STREQUAL "x86_64")
            set(ANDROID_EXTRA_LIBS
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/x86_64/libcrypto.so
                ${CMAKE_CURRENT_LIST_DIR}/Qt-5.12.4_5.13.0/x86_64/libssl.so
            CACHE INTERNAL "")
        endif()
    else()
        if (NOT (QT_VERSION LESS 5.14.0))
            message(${CMAKE_CURRENT_LIST_DIR})
            set(ANDROID_EXTRA_LIBS
                ${CMAKE_CURRENT_LIST_DIR}/latest/arm/libcrypto_1_1.so
                ${CMAKE_CURRENT_LIST_DIR}/latest/arm/libssl_1_1.so
                ${CMAKE_CURRENT_LIST_DIR}/latest/arm64/libcrypto_1_1.so
                ${CMAKE_CURRENT_LIST_DIR}/latest/arm64/libssl_1_1.so
                ${CMAKE_CURRENT_LIST_DIR}/latest/x86/libcrypto_1_1.so
                ${CMAKE_CURRENT_LIST_DIR}/latest/x86/libssl_1_1.so
                ${CMAKE_CURRENT_LIST_DIR}/latest/x86_64/libcrypto_1_1.so
                ${CMAKE_CURRENT_LIST_DIR}/latest/x86_64/libssl_1_1.so
            CACHE INTERNAL "")
        else()
            if (ANDROID_TARGET_ARCH STREQUAL "armeabi-v7a")
                set(ANDROID_EXTRA_LIBS
                    ${CMAKE_CURRENT_LIST_DIR}/latest/arm/libcrypto_1_1.so
                    ${CMAKE_CURRENT_LIST_DIR}/latest/arm/libssl_1_1.so
                CACHE INTERNAL "")
            endif()

            if (ANDROID_TARGET_ARCH STREQUAL "arm64-v8a")
                set(ANDROID_EXTRA_LIBS
                    ${CMAKE_CURRENT_LIST_DIR}/latest/arm64/libcrypto_1_1.so
                    ${CMAKE_CURRENT_LIST_DIR}/latest/arm64/libssl_1_1.so
                CACHE INTERNAL "")
            endif()

            if (ANDROID_TARGET_ARCH STREQUAL "x86")
                set(ANDROID_EXTRA_LIBS
                    ${CMAKE_CURRENT_LIST_DIR}/latest/x86/libcrypto_1_1.so
                    ${CMAKE_CURRENT_LIST_DIR}/latest/x86/libssl_1_1.so
                CACHE INTERNAL "")
            endif()

            if (ANDROID_TARGET_ARCH STREQUAL "x86_64")
                set(ANDROID_EXTRA_LIBS
                    ${CMAKE_CURRENT_LIST_DIR}/latest/x86_64/libcrypto_1_1.so
                    ${CMAKE_CURRENT_LIST_DIR}/latest/x86_64/libssl_1_1.so
                CACHE INTERNAL "")
            endif()
        endif()
    endif()
endif()
