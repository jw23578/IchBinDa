#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "esaaapp.h"
#include "QZXing.h"
#include <QQuickImageProvider>
#include "QZXingImageProvider.h"
#include "QZXingFilter.h"
#include <QtSvg>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<QZXing>("QZXing", 2, 3, "QZXing");
    qmlRegisterType<QZXingFilter>("QZXing", 2, 3, "QZXingFilter");
    engine.addImageProvider(QLatin1String("QZXing"), new QZXingImageProvider());
    ESAAApp esaa(engine);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
