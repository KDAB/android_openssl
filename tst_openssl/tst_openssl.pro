QT += testlib gui network

CONFIG += qt warn_on depend_includepath testcase

TEMPLATE = app

SOURCES +=  tst_openssl.cpp

android: include(../openssl.pri)
