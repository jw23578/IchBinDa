#ifndef ESAAAPP_H
#define ESAAAPP_H

#include <QObject>
#include "qt_extension_macros.h"
#include <QQmlApplicationEngine>
#include <QColor>
#include <SimpleMailSRC/SimpleMail>

class ESAAApp: public QObject
{
    Q_OBJECT
    // Einstellungen
    JWPROPERTY(QColor, backgroundTopColor, BackgroundTopColor, "#ffa500");
    JWPROPERTY(QColor, backgroundBottomColor, BackgroundBottomColor, "#ff4500");

    // App Zustand
    JWPROPERTY(bool, firstStart, FirstStart, true);

    // Aktuelle Location
    JWPROPERTY(QString, logoUrl, LogoUrl, "");
    JWPROPERTY(QColor, color, Color, "#ffffff");

    // gewünschte Kontaktdaten
    JWPROPERTY(bool, adressWanted, AdressWanted, false);
    JWPROPERTY(bool, emailWanted, EMailWanted, false);
    JWPROPERTY(bool, mobileWanted, MobileWanted, false);

    // eingegebene Kontaktdaten
    JWPROPERTY(QString, fstname, Fstname, "")
    JWPROPERTY(QString, surname, Surname, "");
    JWPROPERTY(QString, street, Street, "");
    JWPROPERTY(QString, housenumber, Housenumber, "");
    JWPROPERTY(QString, zip, Zip, "");
    JWPROPERTY(QString, location, Location, "");
    JWPROPERTY(QString, emailAdress, EmailAdress, "");
    JWPROPERTY(QString, mobile, Mobile, "");

    SimpleMail::Server smtpServer;
    QString smtpHost;
    int smtpPort;
    QString smtpUser;
    QString smtpPassword;
    QString smtpSender;

    void sendMail();

    struct SLocationInfo
    {
        QString contactReceiveEmail;
        QString logoUrl;
        QColor color;
        QString locationId;
        QString locationName;
    };
    std::map<QString, SLocationInfo> email2locationInfo;

    QString dataFileName;
    void saveData();
    void loadData();
    const int actionIDCoronaKontaktdatenerfassung = 1;
    QString getTempPath();
    QString genTempFileName(const QString &extension);
    QString genUUID();
    QString generateQRcodeIntern(const QString &code);
public:
    ESAAApp(QQmlApplicationEngine &e);

    Q_INVOKABLE void firstStartDone();
    Q_INVOKABLE void showMessage(const QString &mt);
    Q_INVOKABLE void scan();
    Q_INVOKABLE void sendContactData();
    Q_INVOKABLE void action(const QString &qrCodeJSON);
    Q_INVOKABLE QString generateQRCode(const QString &locationName,
                                       const QString &contactReceiveEMail,
                                       const QString &theLogoUrl,
                                       const QColor color,
                                       bool withAddress,
                                       bool withEMail,
                                       bool widthMobile);

signals:
    void showMessageSignal(const QString &mt);
    void scanSignal();
};

#endif // ESAAAPP_H
