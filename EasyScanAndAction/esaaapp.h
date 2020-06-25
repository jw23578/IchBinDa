#ifndef ESAAAPP_H
#define ESAAAPP_H

#include <QObject>
#include "qt_extension_macros.h"
#include <QQmlApplicationEngine>

class ESAAApp: public QObject
{
    Q_OBJECT
    JWPROPERTY(QString, fstname, Fstname, "")
    JWPROPERTY(QString, surname, Surname, "");

    QString dataFileName;
    void saveData();
    void loadData();
public:
    ESAAApp(QQmlApplicationEngine &e);

    Q_INVOKABLE void showMessage(const QString &mt);
    Q_INVOKABLE void sendContactData();

signals:
    void showMessageSignal(const QString &mt);
};

#endif // ESAAAPP_H
