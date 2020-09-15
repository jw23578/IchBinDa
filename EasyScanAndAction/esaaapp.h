#ifndef ESAAAPP_H
#define ESAAAPP_H

#include <QObject>
#include "qt_extension_macros.h"
#include <QQmlApplicationEngine>
#include <QColor>
#include <SimpleMailSRC/SimpleMail>
#include "emailsender.h"
#include "src/jwmobileext.h"
#include <set>
#include <QNetworkAccessManager>
#include "internettester.h"
#include "qrcodestore.h"
#include "persistentmap.h"
#ifdef DMOBILEDEVICE
#ifdef DMOBILEIOS
#include "botan_all_iosarmv7.h"
#else
#include "botan_all_arm32.h"
#endif
#else
#include "botan_all_x64.h"
#endif
#include <QJsonObject>
#include "visit.h"

class ESAAApp: public QObject
{
    Q_OBJECT
    QString getWriteablePath();
    jw::mobileext mobileExtension;
    QNetworkAccessManager networkAccessManager;
    EMailSender emailSender;
    InternetTester internetTester;
    QRCodeStore qrCodeStore;
    PersistentMap publicKeyMap;
    Visit currentQRCodeData;
    Visit lastVisit;
    // Einstellungen
    JWPROPERTY(int, screenWidth, ScreenWidth, 0);
    JWPROPERTY(int, screenHeight, ScreenHeight, 0);
    JWPROPERTY(QColor, lineInputBorderColor, LineInputBorderColor, "#E9F0F8");


    JWPROPERTY(QColor, textColor, TextColor, "white");
    JWPROPERTY(QColor, headerColor, HeaderColor, "#191928");
    JWPROPERTY(QColor, textBackgroundColor, TextBackgroundColor, "#191928");
    JWPROPERTY(QColor, backgroundTopColor, BackgroundTopColor, "#191928");
    JWPROPERTY(QColor, backgroundBottomColor, BackgroundBottomColor, "#023B28");
    JWPROPERTY(QColor, fontColor, FontColor, "#0E79B2")
    JWPROPERTY(QColor, fontColor2, FontColor2, "#938274")
    JWPROPERTY(QColor, lineColor, LineColor, "#191919")
    JWPROPERTY(QColor, menueButtonColor, MenueButtonColor, "#0E79B2")
    JWPROPERTY(QColor, buttonColor, ButtonColor, "#4581B3");
    JWPROPERTY(QColor, buttonDownColor, ButtonDownColor, "#0E79B2");
    JWPROPERTY(QColor, buttonBorderColor, ButtonBorderColor, "#0E79B2");
    JWPROPERTY(int, fontInputPixelsize, FontInputPixelsize, 10);
    JWPROPERTY(int, fontButtonPixelsize, FontButtonPixelsize, 10);
    JWPROPERTY(int, fontTextPixelsize, FontTextPixelsize, 10);
    JWPROPERTY(int, fontMessageTextPixelsize, FontMessageTextPixelsize, 20)
    JWPROPERTY(int, radius, Radius, 5);

    // App Zustand
    JWPROPERTY(int, spacing, Spacing, 20);
    JWPROPERTY(bool, firstStart, FirstStart, true);
    JWPROPERTY(bool, aggrementChecked, AggreementChecked, false)
    JWPROPERTY(QString, appName, AppName, "IchBinDa!");
    JWPROPERTY(int, yesQuestionCount, YesQuestionCount, 0);
    std::set<QString> qrCodes;
    static std::set<std::string> invalidEMailDomains;

    // Aktuelle Location
    JWPROPERTY(QString, anonymContactMailAdress, AnonymContactMailAdress, "");
    JWPROPERTY(QString, facilityName, FacilityName, "");
    JWPROPERTY(QString, locationContactMailAdress, LocationContactMailAdress, "");
    JWPROPERTY(QString, logoUrl, LogoUrl, "");
    JWPROPERTY(QColor, color, Color, "#ffffff");
    JWPROPERTY(QString, locationGUID, LocationGUID, "");

    // gewünschte Kontaktdaten
    JWPROPERTY(bool, adressWanted, AdressWanted, false);
    JWPROPERTY(bool, emailWanted, EMailWanted, false);
    JWPROPERTY(bool, mobileWanted, MobileWanted, false);
    // gewünschte Besuchdaten
    JWPROPERTY(bool, tableNumberWanted, TableNumberWanted, false);
    JWPROPERTY(bool, whoIsVisitedWanted, WhoIsVisitedWanted, false);
    JWPROPERTY(bool, stationWanted, StationWanted, false);
    JWPROPERTY(bool, roomWanted, RoomWanted, false);
    JWPROPERTY(bool, blockWanted, BlockWanted, false);
    JWPROPERTY(bool, seatNumberWanted, SeatNumberWanted, false);

    // eingegebene Kontaktdaten
    JWPROPERTY(QString, fstname, Fstname, "")
    JWPROPERTY(QString, surname, Surname, "");
    JWPROPERTY(QString, street, Street, "");
    JWPROPERTY(QString, housenumber, Housenumber, "");
    JWPROPERTY(QString, zip, Zip, "");
    JWPROPERTY(QString, location, Location, "");
    JWPROPERTY(QString, emailAdress, EmailAdress, "");
    JWPROPERTY(QString, mobile, Mobile, "");
    JWPROPERTY(QString, data2send, Data2send, "");

    JWPROPERTY(QString, lastVisitLocationContactMailAdress, LastVisitLocationContactMailAdress, "");
    JWPROPERTY(QColor, lastVisitColor, LastVisitColor, "#ffffff");

    JWPROPERTY(int, lastVisitCount, LastVisitCount, 0);
    JWPROPERTY(QString, lastVisitFstname, LastVisitFstname, "")
    JWPROPERTY(QString, lastVisitSurname, LastVisitSurname, "");
    JWPROPERTY(QString, lastVisitStreet, LastVisitStreet, "");
    JWPROPERTY(QString, lastVisitHousenumber, LastVisitHousenumber, "");
    JWPROPERTY(QString, lastVisitZip, LastVisitZip, "");
    JWPROPERTY(QString, lastVisitLocation, LastVisitLocation, "");
    JWPROPERTY(QString, lastVisitEmailAdress, LastVisitEmailAdress, "");
    JWPROPERTY(QString, lastVisitMobile, LastVisitMobile, "");
    JWPROPERTY(QColor, lastVisitCountXColor, LastVisitCountXColor, "");
    JWPROPERTY(int, lastVisitCountX, LastVisitCountX, 0);

    Botan::Public_Key *publicKey = nullptr;
    std::string publicKeyEncrypt(const std::string &plainText);
    SimpleMail::Server smtpServer;

    QString ibdTokenStoreURL;

    void sendMail();

    struct SLocationInfo
    {
        QString contactReceiveEmail;
        QString logoUrl;
        QColor color;
        QString locationId;
        QString facilityName;
        QString anonymReceiveEMail;
    };
    std::map<QString, SLocationInfo> email2locationInfo;

    int updateAndGetVisitCount(const QString &locationGUID, QDateTime const &visitBegin);
    void saveVisit(QDateTime const &visitBegin, QDateTime const &visitEnd);

    QString dataFileName;
    void loadData();
    const int actionIDCoronaKontaktdatenerfassung = 1;
    QString getTempPath();
    QString genTempFileName(const QString &extension);
    QString genUUID();
    QString generateQRcodeIntern(const QString &code);

    QString lastActionJSON;
    QDateTime lastActionDateTime;
    QJsonObject jsonData2Send;

    std::vector<QString> yesQuestions;
    QByteArray qrCodeDataToPost;
    QString facilityIdToPost;
    void postQRCodeData(const QString &filename, QByteArray const &data);
    void interpretExtendedQRCodeData(const QString &qrCodeJSON);
    void fetchExtendedQRCodeData(const QString &facilityId);
    void setPublicKey(int qrCodeNumber);
public:
    ESAAApp(QQmlApplicationEngine &e);

    Q_INVOKABLE QString formatTime(QDateTime const &dt);
    Q_INVOKABLE bool keyNumberOK(int number);
    Q_INVOKABLE void clearYesQuestions();
    Q_INVOKABLE void addYesQuestions(const QString &yq);
    Q_INVOKABLE QString getYesQuestion(int index);
    Q_INVOKABLE void saveData();
    Q_INVOKABLE void clearData2Send();
    Q_INVOKABLE void addData2Send(const QString &field, const QString &value);
    Q_INVOKABLE void addSubData2Send(const QString &field, const QString &subField, const QString &value);
    Q_INVOKABLE void firstStartDone();
    Q_INVOKABLE void showMessage(const QString &mt);
    Q_INVOKABLE void showWaitMessage(const QString &mt);
    Q_INVOKABLE void hideWaitMessage();
    Q_INVOKABLE void scan();
    Q_INVOKABLE void sendContactData();
    Q_INVOKABLE void ignoreQRCode();
    Q_INVOKABLE void action(const QString &qrCodeJSON);
    Q_INVOKABLE void openUrlORPdf(const QString &urlOrPdf);
    Q_INVOKABLE QString generateQRCode(const int qrCodeNumer,
                                       const QString &facilityName,
                                       const QString &contactReceiveEMail,
                                       const QString &theLogoUrl,
                                       const QColor color,
                                       bool withAddress,
                                       bool withEMail,
                                       bool widthMobile,
                                       const QString &anonymReceiveEMail,
                                       int visitCountX,
                                       const QString &visitCountXColor,
                                       bool tableNumber,
                                       bool whoIsVisited,
                                       bool station,
                                       bool room,
                                       bool block,
                                       bool seatNumber,
                                       const QString &websiteURL,
                                       const QString &foodMenueURL,
                                       const QString &drinksMenueURL,
                                       const QString &individualURL1,
                                       const QString &individualURL1Caption,
                                       const QString &lunchMenueURL);
    Q_INVOKABLE void sendQRCode(const QString &qrCodeReceiver, const QString &facilityName);

    Q_INVOKABLE void recommend();
    Q_INVOKABLE bool isEmailValid(const QString& email);

    Q_INVOKABLE void calculateRatios();

    Q_INVOKABLE void reset();

    Q_INVOKABLE void showLastTransmission();

    Q_INVOKABLE void finishVisit();
    Q_INVOKABLE bool isActiveVisit(int changeCounter);

signals:
    void showWaitMessageSignal(const QString &mt);
    void hideWaitMessageSignal();
    void showMessageSignal(const QString &mt);
    void showBadMessageSignal(const QString &mt);
    void scanSignal();
    void validQRCodeDetected();
    void invalidQRCodeDetected();
    void showSendedData();


};

#endif // ESAAAPP_H
