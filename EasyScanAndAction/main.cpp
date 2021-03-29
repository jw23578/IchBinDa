#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "esaaapp.h"
#include "QZXing.h"
#include <QQuickImageProvider>
#include "QZXingImageProvider.h"
#include "QZXingFilter.h"
#include <QtSvg>
#include <QQuickView>
#include "jw78core_debug.h"
#include "jw78extqvector.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
//    QGuiApplication app(argc, argv);
    if (QFontDatabase::addApplicationFont("://roboto/RobotoCondensed-Regular.ttf") == -1)
    {
        jw78core::debug::gi()->d(__FILE__, __LINE__, "Font could not be loaded");
    }
    if (QFontDatabase::addApplicationFont("://roboto/Roboto-Regular.ttf") == -1)
    {
        jw78core::debug::gi()->d(__FILE__, __LINE__, "Font could not be loaded");
    }
    if (QFontDatabase::addApplicationFont("://roboto/Roboto-Thin.ttf") == -1)
    {
        jw78core::debug::gi()->d(__FILE__, __LINE__, "Font could not be loaded");
    }

    QQmlApplicationEngine engine;

//    view.setAttribute(Qt::WA_OpaquePaintEvent);
//    view.setAttribute(Qt::WA_NoSystemBackground);
//    view.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
//    view.viewport()->setAttribute(Qt::WA_NoSystemBackground);

        qmlRegisterType<QZXing>("QZXing", 2, 3, "QZXing");
    qmlRegisterType<QZXingFilter>("QZXing", 2, 3, "QZXingFilter");
    engine.addImageProvider(QLatin1String("QZXing"), new QZXingImageProvider());
    ESAAApp esaa(engine);
//    QImage logo;
//    esaa.fetchLogo("http://wienoebst.com/sprung.jpg", logo);
//    esaa.generateA4Flyer1("JensJensJens", logo, "/home/jw78/.local/share/IchBinDa78/temp/qr.png", 1);
//    esaa.generateA4Flyer1("JensJensJens", logo, "/home/jw78/.local/share/IchBinDa78/temp/qr.png", 2);
//    esaa.generateA4Flyer1("JensJensJens", logo, "/home/jw78/.local/share/IchBinDa78/temp/qr.png", 3);
//    esaa.generateA6Flyer("JensJensJens", logo, "/home/jw78/.local/share/IchBinDa78/temp/qr.png", 1);
//    esaa.generateA5Flyer("JensJensJens", logo, "/home/jw78/.local/share/IchBinDa78/temp/qr.png", 1);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
