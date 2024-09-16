if(NOT QT_BUILD_STANDALONE_TESTS AND NOT QT_BUILDING_QT)
    cmake_minimum_required(VERSION 3.16)
    project(tst_openssl LANGUAGES CXX)
    find_package(Qt6BuildInternals REQUIRED COMPONENTS STANDALONE_TEST)
endif()

qt_internal_add_test(tst_openssl
    SOURCES
        tst_openssl.cpp
    LIBRARIES
        Qt::Network
)

if (ANDROID)
    include(../android_openssl.cmake)
    add_android_openssl_libraries(tst_openssl)
endif()
