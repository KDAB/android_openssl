function(add_android_openssl_libraries)
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(SSL_ROOT_PATH ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/no-asm)
  else()
    set(SSL_ROOT_PATH ${CMAKE_CURRENT_FUNCTION_LIST_DIR})
  endif()

  if(Qt6_VERSION VERSION_GREATER_EQUAL 6.5.0)
    list(APPEND android_extra_libs
         ${SSL_ROOT_PATH}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_3.so
         ${SSL_ROOT_PATH}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libssl_3.so)
    set(OPENSSL_CRYPTO_LIBRARY ${SSL_ROOT_PATH}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_3.so)
    set(OPENSSL_SSL_LIBRARY ${SSL_ROOT_PATH}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libssl_3.so)
    set(OPENSSL_INCLUDE_DIR ${SSL_ROOT_PATH}/ssl_3/include)
  else()
    list(APPEND android_extra_libs
         ${SSL_ROOT_PATH}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_1_1.so
         ${SSL_ROOT_PATH}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libssl_1_1.so)
    set(OPENSSL_CRYPTO_LIBRARY ${SSL_ROOT_PATH}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_1_1.so)
    set(OPENSSL_SSL_LIBRARY ${SSL_ROOT_PATH}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libssl_1_1.so)
    set(OPENSSL_INCLUDE_DIR ${SSL_ROOT_PATH}/ssl_1.1/include)
  endif()

  set_target_properties(${ARGN} PROPERTIES QT_ANDROID_EXTRA_LIBS
                                           "${android_extra_libs}")
  find_package(OpenSSL REQUIRED)
  foreach(TARGET ${ARGN})
    target_link_libraries(${TARGET} PUBLIC OpenSSL::OpenSSL)
  endforeach()
endfunction()
