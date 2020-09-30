#ifndef JWANDEXT_H
#define JWANDEXT_H

#include <QtGlobal>
#include <QQmlApplicationEngine>

#ifdef Q_OS_ANDROID

#include <qandroidjniobject.h>
#include <qandroidactivityresultreceiver.h>
#include <QAndroidJniEnvironment>
#include <QtAndroid>

#endif

namespace jw
{
class mobileext : public QObject
{
    Q_OBJECT
private:
    enum RequestCode
    {
        request_pick_image = 230578
    };
    QString getAppDataLocation();

#ifdef Q_OS_ANDROID
    class resultreceiver : public QAndroidActivityResultReceiver
    {
      public:
        QJSValue pickImagecallback;
        void handleActivityResult(int requestCode, int resultCode, const QAndroidJniObject & data);
    };
    resultreceiver the_resultreceiver;

#endif
    std::string javapackage;

    QString copyfile2sharefiles(QString filepath);
public:
    mobileext(QQmlApplicationEngine &engine, QString javapackagestring);
    Q_INVOKABLE void shareText(QString title, QString subject, QString content);
    Q_INVOKABLE void pickImage(QJSValue callback);
    Q_INVOKABLE void share(QString text, QString url);
    Q_INVOKABLE void sendFile(QString title, QString filePath, QString mimeType);

    Q_INVOKABLE QString email(QString emailTo, QString emailCC, QString subject, QString emailText, QString filePaths);
};
}

#endif // JWANDEXT_H
