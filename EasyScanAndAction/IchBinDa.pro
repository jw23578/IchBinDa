QT += quick multimedia svg xml qml

CONFIG += c++11
CONFIG += qzxing_qml
CONFIG += qzxing_multimedia

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += QZXING_MULTIMEDIA
DEFINES += NO_PNG

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    esaaapp.cpp \
    src/jwmobileext.cpp \
zint-master/backend/2of5.c \
zint-master/backend/auspost.c \
zint-master/backend/aztec.c \
zint-master/backend/code.c \
zint-master/backend/code1.c \
zint-master/backend/code128.c \
zint-master/backend/code16k.c \
zint-master/backend/code49.c \
zint-master/backend/common.c \
zint-master/backend/composite.c \
zint-master/backend/dllversion.c \
zint-master/backend/dmatrix.c \
zint-master/backend/gridmtx.c \
zint-master/backend/gs1.c \
zint-master/backend/imail.c \
zint-master/backend/large.c \
zint-master/backend/library.c \
zint-master/backend/maxicode.c \
zint-master/backend/medical.c \
zint-master/backend/pdf417.c \
zint-master/backend/plessey.c \
zint-master/backend/png.c \
zint-master/backend/postal.c \
zint-master/backend/ps.c \
zint-master/backend/qr.c \
zint-master/backend/reedsol.c \
zint-master/backend/render.c \
zint-master/backend/rss.c \
zint-master/backend/svg.c \
zint-master/backend/telepen.c \
zint-master/backend/upcean.c \
main.cpp

HEADERS += \
    esaaapp.h \
    qt_extension_macros.h \
    src/jwmobileext.h \
zint-master/backend/aztec.h \
zint-master/backend/code1.h \
zint-master/backend/code49.h \
zint-master/backend/common.h \
zint-master/backend/composite.h \
zint-master/backend/dmatrix.h \
zint-master/backend/font.h \
zint-master/backend/gb2312.h \
zint-master/backend/gridmtx.h \
zint-master/backend/gs1.h \
zint-master/backend/large.h \
zint-master/backend/maxicode.h \
zint-master/backend/maxipng.h \
zint-master/backend/pdf417.h \
zint-master/backend/qr.h \
zint-master/backend/reedsol.h \
zint-master/backend/rss.h \
zint-master/backend/sjis.h \
zint-master/backend/zint.h

RESOURCES += qml.qrc \
    keys.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

message($$QT_ARCH)

message($$ANDROID_TARGET_ARCH)

contains(QT_ARCH, "x86_64") {
    message("building for x86")
    HEADERS += botan_all_x64.h
    SOURCES += botan_all_x64.cpp
}

ANDROID_VERSION_NAME = "Version 1"
ANDROID_VERSION_CODE = "4"
ANDROID_TARGET_SDK_VERSION = "29"

android{
    message("building for android")
    DEFINES += DMOBILEDEVICE
    DEFINES += DMOBILEANDROID
    HEADERS += botan_all_arm32.h
    SOURCES += botan_all_arm32.cpp
    QT += androidextras
    INCLUDEPATH += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/include
#    LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/armeabi-v7a/lib/libcrypto.so
#    LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/armeabi-v7a/lib/libssl.so
#    ANDROID_EXTRA_LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/armeabi-v7a/lib/libcrypto.so
#    ANDROID_EXTRA_LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/armeabi-v7a/lib/libssl.so
#    LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/arm64-v8a/lib/libcrypto.so
#    LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/arm64-v8a/lib/libssl.so
#    ANDROID_EXTRA_LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/arm64-v8a/lib/libcrypto.so
#    ANDROID_EXTRA_LIBS += /home/jenz/dev/third/openssl-android-prebuild/openssl-1.1.1a-clang/arm64-v8a/lib/libssl.so

contains(QT_ARCH, "arm64-v8a") {
    message("building for arm64-v8a")
}
else
{
    contains(QT_ARCH, "arm") {
        message("for arm")
    }
}
}


DISTFILES += \
    ../README.md \
    .gitignore \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    android/res/xml/filepaths.xml \
    src/ichbinda/jw78/de/JWAppActivity.java \
    src/ichbinda/jw78/de/JWAppService.java \
    src/ichbinda/jw78/de/JWJobService.java \
    src/ichbinda/jw78/de/MyIntentCaller.java

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    ANDROID_JAVA_SOURCES.path = /src/ichbinda/jw78/de
    ANDROID_JAVA_SOURCES.files = $$files($$PWD/src/ichbinda/jw78/de/*.java)
    INSTALLS += ANDROID_JAVA_SOURCES
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

include(QZXing/QZXing.pri)
include(SimpleMailSRC/simplemail.pri)

android: include(/home/jenz/Android/Sdk/android_openssl/openssl.pri)
