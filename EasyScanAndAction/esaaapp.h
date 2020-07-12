#ifndef ESAAAPP_H
#define ESAAAPP_H

#include <QObject>
#include "qt_extension_macros.h"
#include <QQmlApplicationEngine>
#include <QColor>
#include <SimpleMailSRC/SimpleMail>
#include "src/jwmobileext.h"
#include <set>

class ESAAApp: public QObject
{
    Q_OBJECT

    jw::mobileext mobileExtension;
    // Einstellungen
    JWPROPERTY(QColor, headerColor, HeaderColor, "#191928");
    JWPROPERTY(QColor, textBackgroundColor, TextBackgroundColor, "#191928");
    JWPROPERTY(QColor, backgroundTopColor, BackgroundTopColor, "#191928");
    JWPROPERTY(QColor, backgroundBottomColor, BackgroundBottomColor, "#023B28");
    JWPROPERTY(QColor, fontColor, FontColor, "#BF1363")
    JWPROPERTY(QColor, fontColor2, FontColor2, "#938274")
    JWPROPERTY(QColor, lineColor, LineColor, "#191919")
    JWPROPERTY(QColor, menueButtonColor, MenueButtonColor, "#0E79B2")
    JWPROPERTY(QColor, buttonColor, ButtonColor, "#191928");
    JWPROPERTY(QColor, buttonDownColor, ButtonDownColor, "#0E79B2");
    JWPROPERTY(QColor, buttonBorderColor, ButtonBorderColor, "#0E79B2");
    JWPROPERTY(int, fontButtonPixelsize, FontButtonPixelsize, 10);
    JWPROPERTY(int, radius, Radius, 5);

    // App Zustand
    JWPROPERTY(int, spacing, Spacing, 20);
    JWPROPERTY(bool, firstStart, FirstStart, true);
    JWPROPERTY(bool, aggrementChecked, AggreementChecked, false)
    JWPROPERTY(QString, appName, AppName, "Ich bin da!");
    std::set<QString> qrCodes;
    static std::set<std::string> invalidEMailDomains;

    // Aktuelle Location
    JWPROPERTY(QString, locationContactMailAdress, LocationContactMailAdress, "");
    JWPROPERTY(QString, anonymContactMailAdress, AnonymContactMailAdress, "");
    JWPROPERTY(QString, locationName, LocationName, "");
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
        QString anonymReceiveEMail;
    };
    std::map<QString, SLocationInfo> email2locationInfo;

    QString dataFileName;
    void loadData();
    const int actionIDCoronaKontaktdatenerfassung = 1;
    QString getTempPath();
    QString genTempFileName(const QString &extension);
    QString genUUID();
    QString generateQRcodeIntern(const QString &code);
    std::vector<QString> data2send;
public:
    ESAAApp(QQmlApplicationEngine &e);

    Q_INVOKABLE void saveData();
    Q_INVOKABLE void clearData2Send();
    Q_INVOKABLE void addData2Send(const QString &field, const QString &value);
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
                                       bool widthMobile,
                                       const QString &anonymReceiveEMail);
    Q_INVOKABLE void sendQRCode(const QString &qrCodeReceiver);

    Q_INVOKABLE void recommend();
    Q_INVOKABLE bool isEmailValid(const QString& email);

    Q_INVOKABLE void calculateRatios();

signals:
    void showMessageSignal(const QString &mt);
    void scanSignal();
    void validQRCodeDetected();
    void invalidQRCodeDetected();
};

#endif // ESAAAPP_H
