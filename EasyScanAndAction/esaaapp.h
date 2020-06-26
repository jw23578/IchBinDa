#ifndef ESAAAPP_H
#define ESAAAPP_H

#include <QObject>
#include "qt_extension_macros.h"
#include <QQmlApplicationEngine>
#include <QColor>

class ESAAApp: public QObject
{
    Q_OBJECT
    JWPROPERTY(QString, fstname, Fstname, "")
    JWPROPERTY(QString, surname, Surname, "");
    JWPROPERTY(QString, logoUrl, LogoUrl, "");
    JWPROPERTY(QColor, color, Color, "#ffffff");

    JWPROPERTY(bool, adressWanted, AdressWanted, false);
    JWPROPERTY(bool, emailWanted, EMailWanted, false);
    JWPROPERTY(bool, mobileWanted, MobileWanted, false);

    QString dataFileName;
    void saveData();
    void loadData();
    const int actionIDCoronaKontaktdatenerfassung = 1;
public:
    ESAAApp(QQmlApplicationEngine &e);

    Q_INVOKABLE void showMessage(const QString &mt);
    Q_INVOKABLE void scan();
    Q_INVOKABLE void sendContactData();
    Q_INVOKABLE void action(const QString &qrCodeJSON);

signals:
    void showMessageSignal(const QString &mt);
    void scanSignal();
};

#endif // ESAAAPP_H
