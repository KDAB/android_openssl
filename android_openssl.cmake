if(NOT TARGET OpenSSL::Crypto OR NOT TARGET OpenSSL::SSL)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(ssl_root_path ${CMAKE_CURRENT_LIST_DIR}/no-asm)
    else()
        set(ssl_root_path ${CMAKE_CURRENT_LIST_DIR})
    endif()

    if(Qt6_VERSION VERSION_GREATER_EQUAL 6.5.0)
        set(ssl_version_dir ssl_3)
        set(libcrypto libcrypto_3.so)
        set(libssl libssl_3.so)
    else()
        set(ssl_version_dir ssl_1.1)
        set(libcrypto libcrypto_1_1.so)
        set(libssl libssl_1_1.so)
    endif()

    set(OPENSSL_LIB_DIR ${ssl_root_path}/${ssl_version_dir}/${CMAKE_ANDROID_ARCH_ABI})
    set(OPENSSL_INCLUDE_DIR ${ssl_root_path}/${ssl_version_dir}/include)

    add_library(OpenSSL::Crypto SHARED IMPORTED GLOBAL)
    set_target_properties(OpenSSL::Crypto PROPERTIES
        IMPORTED_LOCATION "${OPENSSL_LIB_DIR}/${libcrypto}"
        INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_INCLUDE_DIR}"
    )

    add_library(OpenSSL::SSL SHARED IMPORTED GLOBAL)
    set_target_properties(OpenSSL::SSL PROPERTIES
        IMPORTED_LOCATION "${OPENSSL_LIB_DIR}/${libssl}"
        INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_INCLUDE_DIR}"
    )

    set(_OPENSSL_EXTRA_LIBS_PATHS
        "${OPENSSL_LIB_DIR}/${libcrypto}"
        "${OPENSSL_LIB_DIR}/${libssl}"
        CACHE INTERNAL "Android OpenSSL libraries for QT_ANDROID_EXTRA_LIBS"
    )
endif()

function(add_android_openssl_libraries)
    foreach(TARGET_NAME ${ARGN})
        if(TARGET ${TARGET_NAME})
            set_property(TARGET ${TARGET_NAME} APPEND PROPERTY
                QT_ANDROID_EXTRA_LIBS ${_OPENSSL_EXTRA_LIBS_PATHS}
            )
            target_link_libraries(${TARGET_NAME} PUBLIC OpenSSL::SSL OpenSSL::Crypto)
        else()
            message(WARNING "add_android_openssl_libraries(): target '${TARGET_NAME}' does not exist.")
        endif()
    endforeach()
endfunction()
