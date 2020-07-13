#include "esaaapp.h"
#include <QQmlContext>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "zint-master/backend/zint.h"
#include <QUuid>
#include <QIcon>
#include <QPixmap>
#include <QImage>
#include <QFile>
#include <regex>
#include <QGuiApplication>
#include <QScreen>
#include <QNetworkReply>

void ESAAApp::sendMail()
{
    smtpServer.setHost(smtpHost);
    smtpServer.setPort(smtpPort);
    smtpServer.setConnectionType(SimpleMail::Server::SslConnection);

    smtpServer.setUsername(smtpUser);
    smtpServer.setPassword(smtpPassword);

    SimpleMail::MimeMessage message;
    message.setSender(SimpleMail::EmailAddress(smtpSender, appName()));
    message.addTo(SimpleMail::EmailAddress(locationContactMailAdress()));

    QString subject("Kontaktdaten ");
    subject += locationName();
    message.setSubject(subject);

    auto text = new SimpleMail::MimeText;

    // Now add some text to the email.
    QString work;
    work += tr("Datum: ") + QDateTime::currentDateTime().date().toString() + "\n";
    work += tr("Uhrzeit: ") + QDateTime::currentDateTime().time().toString() + "\n";
    for (size_t i(0); i < data2send.size(); ++i)
    {
        work += data2send[i] + "\n";
    }

    text->setText(work);

    // Now add it to the mail
    message.addPart(text);

    SimpleMail::ServerReply *reply = smtpServer.sendMail(message);
    QObject::connect(reply, &SimpleMail::ServerReply::finished, [reply] {
        qDebug() << "Message ServerReply finished" << reply->error() << reply->responseText();
        reply->deleteLater();// Don't forget to delete it
    });

    if (locationContactMailAdress().size())
    {

        SimpleMail::MimeMessage visitMessage;
        visitMessage.setSender(SimpleMail::EmailAddress(smtpSender, appName()));
        visitMessage.addTo(SimpleMail::EmailAddress(locationContactMailAdress()));

        subject = "Besuchmeldung " + locationName();
        visitMessage.setSubject(subject);
        work = tr("Datum: ") + QDateTime::currentDateTime().date().toString() + "\n";
        work += tr("Uhrzeit: ") + QDateTime::currentDateTime().time().toString() + "\n";
        auto visitText = new SimpleMail::MimeText;
        visitText->setText(work);
        visitMessage.addPart(visitText);

        reply = smtpServer.sendMail(message);
        QObject::connect(reply, &SimpleMail::ServerReply::finished, [reply] {
            qDebug() << "VisitMessage ServerReply finished" << reply->error() << reply->responseText();
            reply->deleteLater();// Don't forget to delete it
        });
    }
    QString idbToken(QDateTime::currentDateTime().toString(Qt::ISODate));
    idbToken += QString(".") + locationGUID();
    idbToken += QString(".") + genUUID();
    QString url(idbTokenStoreURL + idbToken);
    QNetworkReply *networkReply(networkAccessManager.get(QNetworkRequest(url)));
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply] {
        qDebug() << "StoreToken finished" << networkReply->error() << networkReply->readAll();
        networkReply->deleteLater();// Don't forget to delete it
    });
    saveVisit(idbToken);
}

void ESAAApp::saveVisit(const QString &idbToken)
{
    QString visitFileName(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/visits-");
    visitFileName += QDateTime::currentDateTime().date().toString(Qt::ISODate);
    visitFileName += QString(".json");
    QFile visitFile(visitFileName);
    QJsonObject data;
    if (visitFile.open(QIODevice::ReadOnly))
    {
        QByteArray visitData(visitFile.readAll());
        visitFile.close();
        QJsonDocument loadDoc(QJsonDocument::fromJson(visitData));
        data = loadDoc.object();
    }
    QJsonArray visits(data["visits"].toArray());
    visits.append(idbToken);
    data["visits"] = visits;
    if (!visitFile.open(QIODevice::WriteOnly))
    {
        qWarning("visitFile konnte nicht zum speichern geöffnet werden.");
        return;
    }
    visitFile.write(QJsonDocument(data).toJson());
}

void ESAAApp::saveData()
{
    QFile dataFile(dataFileName);
    if (!dataFile.open(QIODevice::WriteOnly))
    {
        qWarning("dataFile konnte nicht zum speichern geöffnet werden.");
        return;
    }
    QJsonObject contactData;
    contactData["fstname"] = fstname();
    contactData["surname"] = surname();
    contactData["street"] = street();
    contactData["housenumber"] = housenumber();
    contactData["zip"] = zip();
    contactData["location"] = location();
    contactData["emailAdress"] = emailAdress();
    contactData["mobile"] = mobile();

    QJsonArray locationInfos;
    std::map<QString, SLocationInfo>::iterator it(email2locationInfo.begin());
    while (it != email2locationInfo.end())
    {
        QJsonObject locationInfo;
        locationInfo["contactReceiveEmail"] = it->second.contactReceiveEmail;
        locationInfo["logoUrl"] = it->second.logoUrl;
        locationInfo["locationId"] = it->second.locationId;
        locationInfo["color"] = it->second.color.name();
        locationInfo["locationName"] = it->second.locationName;
        locationInfo["anonymReceiveEMail"] = it->second.anonymReceiveEMail;
        ++it;
    }

    QJsonObject data;
    data["contactData"] = contactData;
    data["locationInfos"] = locationInfos;
    data["firstStart"] = firstStart();
    data["aggrementChecked"] = aggrementChecked();
    dataFile.write(QJsonDocument(data).toJson());
}

void ESAAApp::loadData()
{
    QFile dataFile(dataFileName);
    if (!dataFile.open(QIODevice::ReadOnly))
    {
        qWarning("dataFile konnte nicht zum laden geöffnet werden.");
        return;
    }
    QByteArray saveData = dataFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
    QJsonObject data(loadDoc.object());
    setAggreementChecked(data["aggrementChecked"].toBool());
    if (data.contains("firstStart"))
    {
        setFirstStart(data["firstStart"].toBool());
    }
    if (data.contains("locationInfos"))
    {
        QJsonArray locationInfos(data["locationInfos"].toArray());
        for (int i(0); i < locationInfos.size(); ++i)
        {
            QJsonObject locationInfo(locationInfos[i].toObject());
            SLocationInfo li;
            li.contactReceiveEmail = locationInfo["contactReceiveEmail"].toString();
            li.logoUrl = locationInfo["logoUrl"].toString();
            li.locationId = locationInfo["locationId"].toString();
            li.color = locationInfo["color"].toString();
            li.locationName = locationInfo["locationName"].toString();
            li.anonymReceiveEMail = locationInfo["anonymReceiveEMail"].toString();
            email2locationInfo[li.contactReceiveEmail] = li;
        }
    }
    if (data.contains("contactData"))
    {
        QJsonObject contactData(data["contactData"].toObject());
        setFstname(contactData["fstname"].toString());
        setSurname(contactData["surname"].toString());
        setStreet(contactData["street"].toString());
        setHousenumber(contactData["housenumber"].toString());
        setZip(contactData["zip"].toString());
        setLocation(contactData["location"].toString());
        setEmailAdress(contactData["emailAdress"].toString());
        setMobile(contactData["mobile"].toString());
    }
}



ESAAApp::ESAAApp(QQmlApplicationEngine &e):QObject(&e),
    mobileExtension(e, "ichbinda.jw78.de/MyIntentCaller"),
    networkAccessManager(this)
{
    e.rootContext()->setContextProperty("ESAA", QVariant::fromValue(this));
    QDir dir;
    if (!dir.exists(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)))
    {
        dir.mkdir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    }
    if (!dir.exists(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/temp"))
    {
        dir.mkdir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/temp");
    }
    dataFileName = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/esaaData.json";
    qDebug() << dataFileName;
    loadData();

    QString data;
    QString EMailConfig(":/EMailConfig.txt");

    QFile file(EMailConfig);
    if (file.open(QIODevice::ReadOnly))
    {
        char buf[1000];
        file.readLine(buf, 1000);
        smtpHost = QString(buf).trimmed();
        file.readLine(buf, 1000);
        smtpPort = QString(buf).trimmed().toInt();
        file.readLine(buf, 1000);
        smtpUser = QString(buf).trimmed();
        file.readLine(buf, 1000);
        smtpPassword = QString(buf).trimmed();
        file.readLine(buf, 1000);
        smtpSender = QString(buf).trimmed();
        file.readLine(buf, 1000);
        idbTokenStoreURL = QString(buf).trimmed();
    }
}

void ESAAApp::clearData2Send()
{
    data2send.clear();
}

void ESAAApp::addData2Send(const QString &field, const QString &value)
{
    data2send.push_back(field + ": " + value);
}

void ESAAApp::firstStartDone()
{
    setFirstStart(false);
    saveData();
}

void ESAAApp::showMessage(const QString &mt)
{
    emit showMessageSignal(mt);
}

void ESAAApp::scan()
{
    emit scanSignal();
}

void ESAAApp::sendContactData()
{
    saveData();
    sendMail();
}

QString ESAAApp::getTempPath()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/temp";
}

QString ESAAApp::genUUID()
{
    QString u(QUuid::createUuid().toString());
    return u.mid(1, u.size() - 2);
}

QString ESAAApp::genTempFileName(const QString &extension)
{
    return getTempPath() + "/" + genUUID() + extension;
}

QString ESAAApp::generateQRcodeIntern(const QString &code)
{
    QString filename(getTempPath()+ "/qr.svg");
    qDebug() << filename;
    struct zint_symbol *my_symbol;
    my_symbol = ZBarcode_Create();
    my_symbol->symbology = BARCODE_QRCODE;
    //    strcpy(my_symbol->bgcolour, "fed8a7");
    //    strcpy(my_symbol->fgcolour, "404040");
    strcpy(my_symbol->outfile, filename.toStdString().c_str());;
    ZBarcode_Encode(my_symbol, (uint8_t*)code.toStdString().c_str(), 0);
    ZBarcode_Print(my_symbol, 0);
    ZBarcode_Delete(my_symbol);

    QPixmap pix(QIcon(filename).pixmap(QSize(500, 500)));
    pix.toImage().save(getTempPath()+ "/qr.png");
    pix.toImage().save(getTempPath()+ "/qr.jpg");
    qrCodes.insert(filename);
    qrCodes.insert(getTempPath()+ "/qr.png");
    qrCodes.insert(getTempPath()+ "/qr.jpg");
    return filename;
}

void ESAAApp::action(const QString &qrCodeJSON)
{
    qDebug() << "qrCodeJSON: " << qrCodeJSON;
    QJsonDocument qrJSON(QJsonDocument::fromJson(qrCodeJSON.toUtf8()));
    QJsonObject data(qrJSON.object());
    int actionID(data["ai"].toInt());
    if (actionID == actionIDCoronaKontaktdatenerfassung)
    {
        qDebug() << "actionIDCoronaKontaktdatenerfassung";
        QString email(data["e"].toString());
        QString wantedData(data["d"].toString());
        QString logo(data["logo"].toString());
        QString backgroundColor(data["color"].toString());
        QString locationId(data["id]"].toString());
        QString theLocationName(data["ln"].toString());
        QString anonymEMail(data["ae"].toString());
        qDebug() << "locationId: " << locationId;
        qDebug() << "anonymEMail: " << anonymEMail;
        qDebug() << "email: " << email;
        qDebug() << "wantedData: " << wantedData;
        qDebug() << "logo: " << logo;
        qDebug() << "backgroundColor: " << backgroundColor;
        setLocationGUID(locationId);
        setAdressWanted(wantedData.contains("adress"));
        setEMailWanted(wantedData.contains("email"));
        setMobileWanted(wantedData.contains("mobile"));
        setLogoUrl(logo);
        setColor(backgroundColor);
        setLocationName(theLocationName);
        setLocationContactMailAdress(email);
        setAnonymContactMailAdress(anonymEMail);
        emit validQRCodeDetected();
        return;
    }
    emit invalidQRCodeDetected();

}

QString ESAAApp::generateQRCode(const QString &locationName,
                                const QString &contactReceiveEMail,
                                const QString &theLogoUrl,
                                const QColor color,
                                bool withAddress,
                                bool withEMail,
                                bool withMobile,
                                const QString &anonymReceiveEMail)
{
    SLocationInfo &li(email2locationInfo[contactReceiveEMail]);
    if (li.locationId == "")
    {
        li.locationId = genUUID();
    }
    li.contactReceiveEmail = contactReceiveEMail;
    li.locationName = locationName;
    li.color = color;
    li.logoUrl = theLogoUrl;
    li.anonymReceiveEMail = anonymReceiveEMail;

    saveData();
    QJsonObject qr;
    qr["ai"] = 1;
    qr["id"] = li.locationId;
    qr["e"] = li.contactReceiveEmail;
    qr["ae"] = li.anonymReceiveEMail;
    QString d;
    d += withEMail ? "email," : "";
    d += withAddress ? "adress," : "";
    d += withMobile ? "mobile," : "";
    if (d.size())
    {
        d.remove(d.size() - 1, 1);
    }
    qr["d"] = d;
    qr["color"] = li.color.name();
    qr["logo"] = li.logoUrl;
    return generateQRcodeIntern(QJsonDocument(qr).toJson());
}

void ESAAApp::sendQRCode(const QString &qrCodeReceiver)
{
    smtpServer.setHost(smtpHost);
    smtpServer.setPort(smtpPort);
    smtpServer.setConnectionType(SimpleMail::Server::SslConnection);

    smtpServer.setUsername(smtpUser);
    smtpServer.setPassword(smtpPassword);

    SimpleMail::MimeMessage message;
    message.setSender(SimpleMail::EmailAddress(smtpSender, appName()));
    message.addTo(SimpleMail::EmailAddress(qrCodeReceiver));

    QString subject("QR-Code");
    message.setSubject(subject);

    // Now add some text to the email.
    SimpleMail::MimeHtml *html = new SimpleMail::MimeHtml;

    QString jpgGuid(genUUID());

    html->setHtml(QLatin1String("<h1> Hello! </h1>"
                                "<h2> This is the first image </h2>"
                                "<img src=\"cid:") + jpgGuid + "\" />"
                                                                "<h2> This is the second image </h2>");

    // Now add it to the mail
    message.addPart(html);

    // Create a MimeInlineFile object for each image
    std::set<QString>::iterator it(qrCodes.begin());
    while (it != qrCodes.end())
    {
        auto image1 = new SimpleMail::MimeInlineFile(new QFile(*it));

        // An unique content id must be setted
        if (it->right(3) == "jpg")
        {
            image1->setContentId(jpgGuid.toLatin1());
            image1->setContentType(QByteArrayLiteral("image/jpg"));
        }
        if (it->right(3) == "png")
        {
            image1->setContentId(genUUID().toLatin1());
            image1->setContentType(QByteArrayLiteral("image/png"));
        }
        if (it->right(3) == "svg")
        {
            image1->setContentId(genUUID().toLatin1());
            image1->setContentType(QByteArrayLiteral("image/svg+xml"));
        }

        message.addPart(image1);
        ++it;
    }

    SimpleMail::ServerReply *reply = smtpServer.sendMail(message);
    QObject::connect(reply, &SimpleMail::ServerReply::finished, [reply] {
        qDebug() << "QR-Code ServerReply finished" << reply->error() << reply->responseText();
        reply->deleteLater();// Don't forget to delete it
    });

}

void ESAAApp::recommend()
{
    QString content("Ich benutze die ");
    content += appName() + " App um meine Kontakten im Restauraung, Frisör und Co abzugeben. Hier kannst du sie herunterladen: ";
    mobileExtension.shareText("Ich bin da!", "Ich bin da! Kontaktdatenaustausch per QR-Code", content);
}

std::set<std::string> ESAAApp::invalidEMailDomains;

bool ESAAApp::isEmailValid(const QString &email)
{
    std::string work(email.toStdString());
    const std::regex pattern("^[_a-zA-Z0-9-]+(\\.[_a-zA-Z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,63})$");
    bool result(std::regex_match(work, pattern));
    if (result && invalidEMailDomains.size())
    {
        std::string domain(work.substr(work.find("@") + 1));
        return invalidEMailDomains.find(domain) == invalidEMailDomains.end();
    }
    return result;
}

void ESAAApp::calculateRatios()
{
    qreal refDpi = 216.;
    qreal refHeight = 1776.;
    qreal refWidth = 1080.;
    QRect rect = QGuiApplication::primaryScreen()->geometry();
    qreal height = qMax(rect.width(), rect.height());
    qreal width = qMin(rect.width(), rect.height());
    qreal dpi = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    qDebug() << "dpi: " << dpi;
    qDebug() << "height: " << rect.height();
    qDebug() << "width: " << rect.width();
    qreal m_ratio = qMin(height/refHeight, width/refWidth);
    qreal m_ratioFont = qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth));
    qDebug() << "m_ratioFont: " << m_ratioFont;
    setFontButtonPixelsize(m_ratioFont * 8.);
}
