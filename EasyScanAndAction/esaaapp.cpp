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
#include <QPainter>

QString ESAAApp::getWriteablePath()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}

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
    if (visitEnd.isValid())
    {
        subject += "Besuchsende ";
    }
    else
    {
        subject += "Besuchsbeginn ";
    }
    subject += facilityName();
    message.setSubject(subject);

    auto text = new SimpleMail::MimeText;

    // Now add some text to the email.
    QString work;
    work += tr("Datum: ") + visitBegin.date().toString() + "\n";
    work += tr("Uhrzeit: ") + visitBegin.time().toString() + "\n";
    work += fstname() + " aus " + location();


    jsonData2Send["DateVisitBegin"] = visitBegin.date().toString(Qt::ISODate);
    jsonData2Send["TimeVisitBegin"] = visitBegin.time().toString(Qt::ISODate);
    if (visitEnd.isValid())
    {
        jsonData2Send["DateVisitEnd"] = visitEnd.date().toString(Qt::ISODate);
        jsonData2Send["TimeVisitEnd"] = visitEnd.time().toString(Qt::ISODate);
    }
    QString plainText(QJsonDocument(jsonData2Send).toJson());
    std::string encrypted(publicKeyEncrypt(plainText.toStdString()));
    work += "\n\n";
    work += encrypted.c_str();
    work += "\n\n";
    std::string publicKeyString(Botan::X509::PEM_encode(*publicKey));
    work += publicKeyString.c_str();

    text->setText(work);

    // Now add it to the mail
    message.addPart(text);

    SimpleMail::ServerReply *reply = smtpServer.sendMail(message);
    QObject::connect(reply, &SimpleMail::ServerReply::finished, [reply] {
        qDebug() << "Message ServerReply finished" << reply->error() << reply->responseText();
        reply->deleteLater();// Don't forget to delete it
    });

    if (anonymContactMailAdress().size())
    {

        SimpleMail::MimeMessage visitMessage;
        visitMessage.setSender(SimpleMail::EmailAddress(smtpSender, appName()));
        visitMessage.addTo(SimpleMail::EmailAddress(anonymContactMailAdress()));

        subject = "Besuchmeldung " + facilityName();
        visitMessage.setSubject(subject);
        work = tr("Datum: ") + QDateTime::currentDateTime().date().toString() + "\n";
        work += tr("Uhrzeit: ") + QDateTime::currentDateTime().time().toString() + "\n";
        auto visitText = new SimpleMail::MimeText;
        visitText->setText(work);
        visitMessage.addPart(visitText);

        reply = smtpServer.sendMail(visitMessage);
        QObject::connect(reply, &SimpleMail::ServerReply::finished, [reply] {
            qDebug() << "VisitMessage ServerReply finished" << reply->error() << reply->responseText();
            reply->deleteLater();// Don't forget to delete it
        });
    }
    if (visitEnd.isNull())
    {
        ibdToken = QDateTime::currentDateTime().toString(Qt::ISODate);
        ibdToken += QString(".") + locationGUID();
        ibdToken += QString(".") + genUUID();
    }
    QString url(ibdTokenStoreURL + ibdToken);
    QNetworkReply *networkReply(networkAccessManager.get(QNetworkRequest(url)));
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply] {
        qDebug() << "StoreToken finished" << networkReply->error() << networkReply->readAll();
        networkReply->deleteLater();// Don't forget to delete it
    });
    saveVisit(ibdToken, visitBegin, visitEnd);
    if (visitEnd.isValid())
    {
        ibdToken = "";
    }
}

int ESAAApp::updateAndGetVisitCount(const QString &locationGUID, QDateTime const &visitBegin)
{
    QString visitCountFileName(getWriteablePath() + "/visitsCount-");
    visitCountFileName += locationGUID;
    visitCountFileName += QString(".json");
    QFile visitCountFile(visitCountFileName);
    QJsonObject data;
    if (visitCountFile.open(QIODevice::ReadOnly))
    {
        QByteArray visitCountData(visitCountFile.readAll());
        visitCountFile.close();
        QJsonDocument loadDoc(QJsonDocument::fromJson(visitCountData));
        data = loadDoc.object();
    }
    QString d(visitBegin.date().toString(Qt::ISODate));
    QJsonArray visits(data["visits"].toArray());
    for (int i(0); i < visits.size(); ++i)
    {
        if (visits[i].toString() == d)
        {
            return visits.size();
        }
    }
    visits.append(d);
    data["visits"] = visits;
    if (!visitCountFile.open(QIODevice::WriteOnly))
    {
        qWarning("visitFile konnte nicht zum speichern geöffnet werden.");
        return 0;
    }
    visitCountFile.write(QJsonDocument(data).toJson());
    return visits.size();
}


void ESAAApp::saveVisit(const QString &ibdToken, QDateTime const &visitBegin, QDateTime const &visitEnd)
{
    QString visitFileName(getWriteablePath() + "/visits-");
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
    QJsonObject visitObject;
    visitObject["lastVisitLocationContactMailAdress"] = lastVisitLocationContactMailAdress();
    visitObject["lastVisitLogoUrl"] = lastVisitLogoUrl();
    visitObject["lastVisitColor"] = lastVisitColor().name();
    visitObject["begin"] = visitBegin.toString((Qt::ISODate));
    visitObject["end"] = visitEnd.toString((Qt::ISODate));
    visitObject["ibdToken"] = ibdToken;
    visitObject["facilityName"] = lastVisitFacilityName();
    visitObject["fstname"] = lastVisitFstname();
    visitObject["surname"] = lastVisitSurname();
    visitObject["street"] = lastVisitStreet();
    visitObject["housenumber"] = lastVisitHousenumber();
    visitObject["zip"] = lastVisitZip();
    visitObject["location"] = lastVisitLocation();
    visitObject["emailAdress"] = lastVisitEmailAdress();
    visitObject["mobile"] = lastVisitMobile();
    visitObject["locationGUID"] = locationGUID();
    visitObject["logoUrl"] = logoUrl();
    visitObject["color"] = color().name();
    visitObject["locationContactMailAdress"] = locationContactMailAdress();
    visitObject["visitCount"] = lastVisitCount();
    visitObject["lastVisitCountXColor"] = lastVisitCountXColor().name();
    visitObject["lastVisitCountX"] = lastVisitCountX();
    QJsonArray visits(data["visits"].toArray());
    bool found(false);
    for (int i(0); i < visits.size(); ++i)
    {
        QJsonObject visit(visits[i].toObject());
        if (visit["ibdToken"] == ibdToken)
        {
            found = true;
            visits[i] = visitObject;
            break;
        }
    }
    if (!found)
    {
        visits.append(visitObject);
    }
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
        locationInfo["facilityName"] = it->second.facilityName;
        locationInfo["anonymReceiveEMail"] = it->second.anonymReceiveEMail;
        ++it;
    }

    QJsonObject data;
    data["lastVisitLocationContactMailAdress"] = lastVisitLocationContactMailAdress();
    data["lastVisitLogoUrl"] = lastVisitLogoUrl();
    data["lastVisitColor"] = lastVisitColor().name();
    data["contactData"] = contactData;
    data["locationInfos"] = locationInfos;
    data["firstStart"] = firstStart();
    data["aggrementChecked"] = aggrementChecked();
    data["lastVisitDateTime"] = lastVisitDateTime().toSecsSinceEpoch();
    data["lastVisitFacilityName"] = lastVisitFacilityName();
    data["lastVisitFstname"] = lastVisitFstname();
    data["lastVisitSurname"] = lastVisitSurname();
    data["lastVisitStreet"] = lastVisitStreet();
    data["lastVisitHousenumber"] = lastVisitHousenumber();
    data["lastVisitZip"] = lastVisitZip();
    data["lastVisitLocation"] = lastVisitLocation();
    data["lastVisitEmailAdress"] = lastVisitEmailAdress();
    data["lastVisitMobile"] = lastVisitMobile();
    data["lastVisitCountXColor"] = lastVisitCountXColor().name();
    data["lastVisitCountX"] = lastVisitCountX();


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
    QDateTime help;
    help.setSecsSinceEpoch(data["lastVisitDateTime"].toInt());
    setLastVisitDateTime(help);

    setLastVisitLocationContactMailAdress(data["lastVisitLocationContactMailAdress"].toString());
    setLastVisitLogoUrl(data["lastVisitLogoUrl"].toString());
    setLastVisitColor(data["lastVisitColor"].toString());

    setLastVisitFacilityName(data["lastVisitFacilityName"].toString());
    setLastVisitFstname(data["lastVisitFstname"].toString());
    setLastVisitSurname(data["lastVisitSurname"].toString());
    setLastVisitStreet(data["lastVisitStreet"].toString());
    setLastVisitHousenumber(data["lastVisitHousenumber"].toString());
    setLastVisitZip(data["lastVisitZip"].toString());
    setLastVisitLocation(data["lastVisitLocation"].toString());
    setLastVisitEmailAdress(data["lastVisitEmailAdress"].toString());
    setLastVisitMobile(data["lastVisitMobile"].toString());
    setLastVisitCountXColor(data["lastVisitCountXColor"].toString());
    setLastVisitCountX(data["lastVisitCountX"].toInt());

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
            li.facilityName= locationInfo["facilityName"].toString();
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

#include <fstream>

std::string ESAAApp::publicKeyEncrypt(const std::string &plainText)
{
    Botan::AutoSeeded_RNG rng;

    Botan::secure_vector<uint8_t> data(plainText.data(), plainText.data() + plainText.length());

    const std::string OAEP_HASH = "SHA-256";
    const std::string aead_algo = "AES-256/GCM";

    std::unique_ptr<Botan::AEAD_Mode> aead =
            Botan::AEAD_Mode::create(aead_algo, Botan::ENCRYPTION);

    const Botan::OID aead_oid = Botan::OID::from_string(aead_algo);


    const Botan::AlgorithmIdentifier hash_id(OAEP_HASH, Botan::AlgorithmIdentifier::USE_EMPTY_PARAM);
    const Botan::AlgorithmIdentifier pk_alg_id("RSA/OAEP", hash_id.BER_encode());

    Botan::PK_Encryptor_EME enc(*publicKey, rng, "OAEP(" + OAEP_HASH + ")");

    const Botan::secure_vector<uint8_t> file_key = rng.random_vec(aead->key_spec().maximum_keylength());

    const std::vector<uint8_t> encrypted_key = enc.encrypt(file_key, rng);

    const Botan::secure_vector<uint8_t> nonce = rng.random_vec(aead->default_nonce_length());
    aead->set_key(file_key);
    aead->set_associated_data_vec(encrypted_key);
    aead->start(nonce);

    aead->finish(data);

    std::vector<uint8_t> buf;
    Botan::DER_Encoder der(buf);

    der.start_cons(Botan::SEQUENCE)
            .encode(pk_alg_id)
            .encode(encrypted_key, Botan::OCTET_STRING)
            .encode(aead_oid)
            .encode(nonce, Botan::OCTET_STRING)
            .encode(data, Botan::OCTET_STRING)
            .end_cons();
    std::string message(Botan::PEM_Code::encode(buf, "PUBKEY ENCRYPTED MESSAGE"));
    return message;
}


ESAAApp::ESAAApp(QQmlApplicationEngine &e):QObject(&e),
    mobileExtension(e, "ichbinda.jw78.de/MyIntentCaller"),
    networkAccessManager(this)
{
    QFile publicKeyFile(":/keys/publickey2020-07-26.txt");
    publicKeyFile.open(QIODevice::ReadOnly);
    QByteArray publicKeyData(publicKeyFile.readAll());
    Botan::DataSource_Memory datasource(publicKeyData.toStdString());
    publicKey = Botan::X509::load_key(datasource);

    e.rootContext()->setContextProperty("ESAA", QVariant::fromValue(this));
    QDir dir;
    QString path(getWriteablePath());
    if (!dir.exists(path))
    {
        qDebug() << "erzeuge: " << path;
        qDebug() << (dir.mkpath(path) ? "erfolgreich" : "nicht erfolgreich");
    }
    if (!dir.exists(getWriteablePath() + "/temp"))
    {
        dir.mkdir(getWriteablePath() + "/temp");
    }
    dataFileName = getWriteablePath() + "/esaaData.json";
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
        ibdTokenStoreURL = QString(buf).trimmed();
    }
}

void ESAAApp::clearData2Send()
{
    setData2send("");
    jsonData2Send = QJsonObject();
}

void ESAAApp::addData2Send(const QString &field, const QString &value)
{
    setData2send(data2send() + field + ": " + value);
    setData2send(data2send() + "<br>");
    jsonData2Send[field] = value;
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
    setLastVisitDateTime(QDateTime::currentDateTime());
    saveData();
    visitBegin = QDateTime::currentDateTime();
    setLastVisitCount(updateAndGetVisitCount(locationGUID(), visitBegin));
    visitEnd = QDateTime();
    sendMail();
    showLastTransmission();
}

QString ESAAApp::getTempPath()
{
    return getWriteablePath() + "/temp";
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

    QPixmap pix(500, 500);
    QPainter painter(&pix);
    painter.fillRect(pix.rect(), QColor(0xffffff));
    painter.drawPixmap(25, 25, QIcon(filename).pixmap(QSize(450, 450)));
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
    if (lastActionDateTime.addSecs(60) > QDateTime::currentDateTime() && qrCodeJSON == lastActionJSON)
    {
        qDebug() << "der gleiche code wie vor max einer minute wird abgelehnt";
        return;
    }
    lastActionJSON = qrCodeJSON;
    lastActionDateTime = QDateTime::currentDateTime();
    QJsonDocument qrJSON(QJsonDocument::fromJson(qrCodeJSON.toUtf8()));
    QJsonObject data(qrJSON.object());
    int actionID(data["ai"].toInt());
    if (actionID == 0)
    {
        emit showBadMessageSignal("Das ist leider kein \"IchBinDa!\"-QR-Code.");
        return;
    }
    if (actionID == actionIDCoronaKontaktdatenerfassung)
    {
        qDebug() << "actionIDCoronaKontaktdatenerfassung";
        QString email(data["e"].toString());
        QString wantedData(data["d"].toString());
        QString logo(data["logo"].toString());
        QString backgroundColor(data["color"].toString());
        QString locationId(data["id"].toString());
        QString theFacilityName(data["ln"].toString());
        QString anonymEMail(data["ae"].toString());
        qDebug() << "facilityName: " << theFacilityName;
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
        setFacilityName(theFacilityName);
        setLocationContactMailAdress(email);
        setAnonymContactMailAdress(anonymEMail);
        setLastVisitCountX(data["x"].toInt());
        setLastVisitCountXColor(data["colorx"].toString());
        emit validQRCodeDetected();
        return;
    }
    emit invalidQRCodeDetected();

}

QString ESAAApp::generateQRCode(const QString &facilityName,
                                const QString &contactReceiveEMail,
                                const QString &theLogoUrl,
                                const QColor color,
                                bool withAddress,
                                bool withEMail,
                                bool withMobile,
                                const QString &anonymReceiveEMail,
                                int visitCountX,
                                const QString &visitCountXColor)
{
    SLocationInfo &li(email2locationInfo[contactReceiveEMail]);
    if (li.locationId == "")
    {
        li.locationId = genUUID();
    }
    li.contactReceiveEmail = contactReceiveEMail;
    li.facilityName = facilityName;
    li.color = color;
    li.logoUrl = theLogoUrl;
    li.anonymReceiveEMail = anonymReceiveEMail;

    saveData();
    QJsonObject qr;
    qr["ai"] = 1;
    qr["ln"] = li.facilityName;
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
    qr["x"] = visitCountX;
    qr["xcolor"]  = visitCountXColor;
    return generateQRcodeIntern(QJsonDocument(qr).toJson(QJsonDocument::Compact));
}

void ESAAApp::sendQRCode(const QString &qrCodeReceiver, const QString &facilityName)
{
    smtpServer.setHost(smtpHost);
    smtpServer.setPort(smtpPort);
    smtpServer.setConnectionType(SimpleMail::Server::SslConnection);

    smtpServer.setUsername(smtpUser);
    smtpServer.setPassword(smtpPassword);

    SimpleMail::MimeMessage message;
    message.setSender(SimpleMail::EmailAddress(smtpSender, appName()));
    message.addTo(SimpleMail::EmailAddress(qrCodeReceiver));

    QString subject("QR-Code ");
    subject += facilityName;
    message.setSubject(subject);

    // Now add some text to the email.
    SimpleMail::MimeHtml *html = new SimpleMail::MimeHtml;

    QString jpgGuid(genUUID());

    html->setHtml(QLatin1String("<h1> Hier folgt der QR-Code </h1>"
                                "<img src=\"cid:") + jpgGuid + "\" />");

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
#ifndef DMOBILEDEVICE
    height = 480;
    width = 300;
#endif
    qreal dpi = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    qDebug() << "dpi: " << dpi;
    qDebug() << "height: " << rect.height();
    qDebug() << "width: " << rect.width();
    qreal m_ratio = qMin(height/refHeight, width/refWidth);
    qreal m_ratioFont = qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth));
    qDebug() << "m_ratio: " << m_ratio;
    qDebug() << "m_ratioFont: " << m_ratioFont;
    double baseFontSize(24);
    double baseSpacing(45);
#ifdef DMOBILEDEVICE
    baseFontSize = 22;
    baseSpacing = 40;
#endif
    setFontButtonPixelsize(m_ratioFont * baseFontSize);
    setFontMessageTextPixelsize(m_ratioFont * baseFontSize * 1.5);
    setSpacing(baseSpacing * m_ratio);
    setFontTextPixelsize(m_ratioFont * baseFontSize);
}

void ESAAApp::reset()
{
    QFile(dataFileName).remove();
}

void ESAAApp::showLastTransmission()
{
    emit showSendedData();
//    showMessage("Folgende Daten wurden verschlüsselt an<br><br><b>" + facilityName() + "</b><br><br>übertragen:<br><br>" + data2send());
}

void ESAAApp::finishVisit()
{
    setLastVisitDateTime(QDateTime::currentDateTime().addDays(-2));
    saveData();
    visitEnd = QDateTime::currentDateTime();
    sendMail();
}

bool ESAAApp::isActiveVisit(const QDateTime &visitDateTime, int changeCounter)
{
    changeCounter += 10;
    return QDateTime::currentDateTime() < visitDateTime.addSecs(60 * 60 * 12);
}
