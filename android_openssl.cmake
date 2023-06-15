function(android_add_openssl_to_targets)
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set (SSL_ROOT_PATH ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/no-asm)
    else()
        set (SSL_ROOT_PATH ${CMAKE_CURRENT_FUNCTION_LIST_DIR})
    endif()

    if (Qt6_VERSION VERSION_GREATER_EQUAL 6.5.0)
        list(APPEND ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_3.so
            ${SSL_ROOT_PATH}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libssl_3.so)
    else()
        list(APPEND ANDROID_EXTRA_LIBS
            ${SSL_ROOT_PATH}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_1_1.so
            ${SSL_ROOT_PATH}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libssl_1_1.so)
    endif()

    #message(WARNING "set_target_properties(${ARGV} PROPERTIES QT_ANDROID_EXTRA_LIBS \"${ANDROID_EXTRA_LIBS}\")")
    set_target_properties(${ARGV} PROPERTIES
        QT_ANDROID_EXTRA_LIBS "${ANDROID_EXTRA_LIBS}")
endfunction()
