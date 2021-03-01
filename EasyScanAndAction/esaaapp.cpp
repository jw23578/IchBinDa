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
#include <QUrlQuery>
#include <QDesktopServices>
#include <QPdfWriter>
#include "customercard.h"
#include "jw78core_debug.h"
#include "qthelper.h"

void ESAAApp::checkDevelopMobile()
{
    jw78core::debug::gi()->setIgnoreSSL(false);
    if (mobile() == "230578")
    {
        setIsDevelop(true);
    }
    if (mobile() == "197823578")
    {
        setIsDevelop(true);
        setBaseServerURL("https://127.0.0.1:23578");
        jw78core::debug::gi()->setIgnoreSSL(true);
    }
    if (mobile() == "999999")
    {
        setLoginTokenString("");
        setLoggedIn(false);
    }
    jw78core::debug::gi()->setDevelop(isDevelop());
}

void ESAAApp::sendMail()
{
    SimpleMail::MimeMessage *message(new SimpleMail::MimeMessage);
    message->setSender(SimpleMail::EmailAddress(emailSender.smtpSender, appName()));
    message->addTo(SimpleMail::EmailAddress(lastVisit.locationContactMailAdress()));

    QString subject("Kontaktdaten ");
    if (lastVisit.end().isValid())
    {
        subject += "Besuchsende ";
    }
    else
    {
        subject += "Besuchsbeginn ";
    }
    subject += facilityName();
    message->setSubject(subject);

    auto text = new SimpleMail::MimeText;

    // Now add some text to the email.
    QString work;
    work += tr("Datum: ") + lastVisit.begin().date().toString() + "\n";
    work += tr("Uhrzeit: ") + lastVisit.begin().time().toString() + "\n";
    work += mainPerson.fstname() + " aus " + mainPerson.location();


    jsonData2Send["DateVisitBegin"] = lastVisit.begin().date().toString(Qt::ISODate);
    jsonData2Send["TimeVisitBegin"] = lastVisit.begin().time().toString(Qt::ISODate);
    if (lastVisit.end().isValid())
    {
        jsonData2Send["DateVisitEnd"] = lastVisit.end().date().toString(Qt::ISODate);
        jsonData2Send["TimeVisitEnd"] = lastVisit.end().time().toString(Qt::ISODate);
    }
    QString plainText(QJsonDocument(jsonData2Send).toJson());
    std::string encrypted(encrypter.publicKeyEncrypt(plainText.toStdString()));
    work += "\n\n";
    work += encrypted.c_str();
    work += "\n\n";
    std::string publicKeyString(Botan::X509::PEM_encode(*encrypter.publicKey));
    work += publicKeyString.c_str();

    text->setText(work);

    // Now add it to the mail
    message->addPart(text);
    emailSender.addMailToSend(message, true);

    if (lastVisit.locationAnonymContactMailAdress().size())
    {

        SimpleMail::MimeMessage *visitMessage(new SimpleMail::MimeMessage);
        visitMessage->setSender(SimpleMail::EmailAddress(emailSender.smtpSender, appName()));
        visitMessage->addTo(SimpleMail::EmailAddress(lastVisit.locationAnonymContactMailAdress()));

        subject = "Besuchmeldung " + facilityName();
        visitMessage->setSubject(subject);
        work = tr("Datum: ") + QDateTime::currentDateTime().date().toString() + "\n";
        work += tr("Uhrzeit: ") + QDateTime::currentDateTime().time().toString() + "\n";
        auto visitText = new SimpleMail::MimeText;
        visitText->setText(work);
        visitMessage->addPart(visitText);

        emailSender.addMailToSend(visitMessage, false);
    }
}

int ESAAApp::updateAndGetVisitCount(const QString &locationGUID, QDateTime const &visitBegin)
{
    QString visitCountFileName(jw78::Utils::getWriteablePath() + "/visitsCount-");
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


void ESAAApp::saveVisit(QDateTime const &visitBegin, QDateTime const &visitEnd)
{
    QString visitFileName(jw78::Utils::getWriteablePath() + "/visits-");
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
    visitObject["begin"] = visitBegin.toString((Qt::ISODate));
    visitObject["end"] = visitEnd.toString((Qt::ISODate));
    visitObject["ibdToken"] = lastVisit.ibdToken;
    visitObject["facilityName"] = lastVisit.facilityName();
    visitObject["websiteURL"] = lastVisit.websiteURL();
    visitObject["foodMenueURL"] = lastVisit.foodMenueURL();
    visitObject["drinksMenueURL"] = lastVisit.drinksMenueURL();
    visitObject["individualURL1"] = lastVisit.individualURL1();
    visitObject["individualURL1Caption"] = lastVisit.individualURL1Caption();
    visitObject["lunchMenueURL"] = lastVisit.lunchMenueURL();
    visitObject["fstname"] = lastVisit.fstname();
    visitObject["surname"] = lastVisit.surname();
    visitObject["street"] = lastVisitStreet();
    visitObject["housenumber"] = lastVisitHousenumber();
    visitObject["zip"] = lastVisitZip();
    visitObject["location"] = lastVisitLocation();
    visitObject["emailAdress"] = lastVisitEmailAdress();
    visitObject["mobile"] = lastVisitMobile();
    visitObject["locationGUID"] = locationGUID();
    visitObject["logoUrl"] = logoUrl();
    visitObject["color"] = color().name();
    visitObject["locationContactMailAdress"] = lastVisit.locationContactMailAdress();
    visitObject["visitCount"] = lastVisitCount();
    visitObject["CountXColor"] = lastVisitCountXColor().name();
    visitObject["CountX"] = lastVisitCountX();
    QJsonArray visits(data["visits"].toArray());
    bool found(false);
    for (int i(0); i < visits.size(); ++i)
    {
        QJsonObject visit(visits[i].toObject());
        if (visit["ibdToken"] == lastVisit.ibdToken)
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
    Visit *aVisit(new Visit);
    *aVisit = lastVisit;
    if (!ESAAApp::appendAVisit(aVisit))
    {
        delete aVisit;
    }
}

void ESAAApp::saveData()
{
    if (loading)
    {
        qWarning("Loading will not save");
        return;
    }
    QFile dataFile(dataFileName);
    if (!dataFile.open(QIODevice::WriteOnly))
    {
        qWarning("dataFile konnte nicht zum speichern geöffnet werden.");
        return;
    }
    qWarning("Save the Data");
    QJsonObject contactData;
    contactData["fstname"] = mainPerson.fstname();
    contactData["surname"] = mainPerson.surname();
    contactData["street"] = mainPerson.street();
    contactData["housenumber"] = mainPerson.housenumber();
    contactData["zip"] = mainPerson.zip();
    contactData["location"] = mainPerson.location();
    contactData["emailAdress"] = mainPerson.emailAdress();
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
    data["appVersion"] = appVersion();
    data["loginTokenString"] = loginTokenString();
    data["ibdToken"] = lastVisit.ibdToken;
    data["lastVisitLocationContactMailAdress"] = lastVisit.locationContactMailAdress();
    data["lastVisitLogoUrl"] = lastVisit.logoUrl();
    data["lastVisitColor"] = lastVisit.color().name();
    data["contactData"] = contactData;
    data["locationInfos"] = locationInfos;
    data["firstStart"] = firstStart();
    data["aggrementChecked"] = aggrementChecked();
    data["lastVisitBegin"] = lastVisit.begin().toSecsSinceEpoch();
    data["lastVisitEnd"] = lastVisit.end().toSecsSinceEpoch();
    data["lastVisitFacilityName"] = lastVisit.facilityName();
    data["websiteURL"] = lastVisit.websiteURL();
    data["foodMenueURL"] = lastVisit.foodMenueURL();
    data["drinksMenueURL"] = lastVisit.drinksMenueURL();
    data["individualURL1"] = lastVisit.individualURL1();
    data["individualURL1Caption"] = lastVisit.individualURL1Caption();
    data["lunchMenueURL"] = lastVisit.lunchMenueURL();
    data["lastVisitFstname"] = lastVisit.fstname();
    data["lastVisitSurname"] = lastVisit.surname();
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
    loading = true;
    QByteArray saveData = dataFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
    QJsonObject data(loadDoc.object());
    setAppVersion(data["appVersion"].toInt(0));
    setAggreementChecked(data["aggrementChecked"].toBool());
    QDateTime help;
    help.setSecsSinceEpoch(data["lastVisitBegin"].toInt());
    lastVisit.setBegin(help);
    help.setSecsSinceEpoch(data["lastVisitEnd"].toInt());
    lastVisit.setEnd(help);

    lastVisit.setLocationContactMailAdress(data["lastVisitLocationContactMailAdress"].toString());

    lastVisit.ibdToken = data["ibdToken"].toString();
    lastVisit.setLogoUrl(data["lastVisitLogoUrl"].toString());
    lastVisit.setFacilityName(data["lastVisitFacilityName"].toString());
    lastVisit.setWebsiteURL(data["websiteURL"].toString());
    lastVisit.setFoodMenueURL(data["foodMenueURL"].toString());
    lastVisit.setDrinksMenueURL(data["drinksMenueURL"].toString());
    lastVisit.setIndividualURL1(data["individualURL1"].toString());
    lastVisit.setIndividualURL1Caption(data["individualURL1Caption"].toString());
    lastVisit.setLunchMenueURL(data["lunchMenueURL"].toString());
    lastVisit.setColor(data["lastVisitColor"].toString());
    lastVisit.setFstname(data["lastVisitFstname"].toString());
    lastVisit.setSurname(data["lastVisitSurname"].toString());

    setLastVisitStreet(data["lastVisitStreet"].toString());
    setLastVisitHousenumber(data["lastVisitHousenumber"].toString());
    setLastVisitZip(data["lastVisitZip"].toString());
    setLastVisitLocation(data["lastVisitLocation"].toString());
    setLastVisitEmailAdress(data["lastVisitEmailAdress"].toString());
    setLastVisitMobile(data["lastVisitMobile"].toString());
    setLastVisitCountXColor(data["lastVisitCountXColor"].toString());
    setLastVisitCountX(data["lastVisitCountX"].toInt());

    setLoginTokenString(data["loginTokenString"].toString());

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
        mainPerson.setFstname(contactData["fstname"].toString());
        mainPerson.setSurname(contactData["surname"].toString());
        mainPerson.setStreet(contactData["street"].toString());
        mainPerson.setHousenumber(contactData["housenumber"].toString());
        mainPerson.setZip(contactData["zip"].toString());
        mainPerson.setLocation(contactData["location"].toString());
        mainPerson.setEmailAdress(contactData["emailAdress"].toString());
        setMobile(contactData["mobile"].toString());
    }
    loading = false;
}

ESAAApp::ESAAApp(QQmlApplicationEngine &e):QObject(&e),
    jw78Utils(e),
    databaseFilename(jw78::Utils::getWriteablePath() + "/ichbinda.db"),
    networkAccessManager(this),
    timeMaster(e, *this, databaseFilename),
    placesManager(e),
    helpOfferManager(e, databaseFilename, networkAccessManager),
    mobileExtensions(e),
    sek30Timer(this),
    emailSender(this),
    internetTester(this),
    qrCodeStore(jw78::Utils::getWriteablePath() + "/knownQRCodes.json"),
    mailOffice(appName(), encrypter, emailSender),
    allVisits(e, "AllVisits", "Visit"),
    customerCardsManager(e, *this, databaseFilename),
    loading(false)
{
    e.rootContext()->setContextProperty("MainPerson", QVariant::fromValue(&mainPerson));
    loadConfigFile();
    setTempTakenPicture(jw78::Utils::getTempPath() + "/tempTakenPicture.jpg");
    allVisits.reverse = true;
    dummyGet();

    e.rootContext()->setContextProperty("JW78APP", QVariant::fromValue(this));
    e.rootContext()->setContextProperty("ESAA", QVariant::fromValue(this));
    e.rootContext()->setContextProperty("CurrentQRCodeData", QVariant::fromValue(&currentQRCodeData));
    e.rootContext()->setContextProperty("LastVisit", QVariant::fromValue(&lastVisit));
    e.rootContext()->setContextProperty("InternetTester", QVariant::fromValue(&internetTester));
    QDir dir;
    QString path(jw78::Utils::getWriteablePath());
    if (!dir.exists(path))
    {
        qDebug() << "erzeuge: " << path;
        qDebug() << (dir.mkpath(path) ? "erfolgreich" : "nicht erfolgreich");
    }
    if (!dir.exists(jw78::Utils::getTempPath()))
    {
        dir.mkdir(jw78::Utils::getTempPath());
    }
    dataFileName = jw78::Utils::getWriteablePath() + "/esaaData.json";
    qDebug() << dataFileName;
    loadData();
    if (appVersion() < 1)
    {
        setAppVersion(1);
        saveData();
    }
    loadAllVisits();

    sek30Timer.setInterval(1000 * 30);
    sek30Timer.setSingleShot(false);
    connect(&sek30Timer, &QTimer::timeout, this, &ESAAApp::onSek30Timeout);
    sek30Timer.start();
    checkLoggedIn();
    runTests();
}

void ESAAApp::runTests()
{
//    serverAdapter.setComm("127.0.0.1", 23578, secToken);
//    serverAdapter.setLoginTokenString(loginTokenString());
//    HelpOffer *ho(new HelpOffer(true));
//    ho->setLatitude(10);
//    ho->setLongitute(9.9);
//    ho->setDescription("Erste Beschreibung");
//    ho->setCaption("Erstes Hilfsangebot");
//    ho->setOffererUuid("1234");
//    serverAdapter.insert(ho->get_entity_name(),
//                          *ho);
}

void ESAAApp::loadConfigFile()
{
    QString EMailConfig(":/EMailConfig.txt");

    QFile file(EMailConfig);
    if (file.open(QIODevice::ReadOnly))
    {
        char buf[1000];
        file.readLine(buf, 1000);
        emailSender.smtpHost = QString(buf).trimmed();
        file.readLine(buf, 1000);
        emailSender.smtpPort = QString(buf).trimmed().toInt();
        file.readLine(buf, 1000);
        emailSender.smtpUser = QString(buf).trimmed();
        emailSender.fstSmtpUser = QString(buf).trimmed();
        file.readLine(buf, 1000);
        emailSender.smtpPassword = QString(buf).trimmed();
        emailSender.fstSmtpPassword = QString(buf).trimmed();
        file.readLine(buf, 1000);
        emailSender.smtpSender = QString(buf).trimmed();
        emailSender.fstSmtpSender = QString(buf).trimmed();

        file.readLine(buf, 1000);
        emailSender.scdSmtpUser = QString(buf).trimmed();
        file.readLine(buf, 1000);
        emailSender.scdSmtpPassword = QString(buf).trimmed();
        file.readLine(buf, 1000);
        emailSender.scdSmtpSender = QString(buf).trimmed();

        file.readLine(buf, 1000);
        setBaseServerURL(QString(buf).trimmed());

        file.readLine(buf, 1000);
        ibdTokenStoreMethod = QString(buf).trimmed();

        file.readLine(buf, 1000);
        fileStoreMethod = QString(buf).trimmed();

        file.readLine(buf, 1000);
        secToken = QString(buf).trimmed();
    }
}

bool ESAAApp::keyNumberOK(int number)
{
    return encrypter.keyNumberOK(number);
}

void ESAAApp::clearYesQuestions()
{
    yesQuestions.clear();
}

void ESAAApp::addYesQuestions(const QString &yq)
{
    yesQuestions.push_back(yq);
}

QString ESAAApp::getYesQuestion(int index)
{
    return yesQuestions[index];
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

void ESAAApp::addSubData2Send(const QString &field, const QString &subField, const QString &value)
{
    //    setData2send(data2send() + field + ": " + value);
    //    setData2send(data2send() + "<br>");
    QJsonArray array(jsonData2Send[field].toArray());
    QJsonObject yq;
    yq[subField] = value;
    array.append(yq);
    jsonData2Send[field] = array;
}

void ESAAApp::firstStartDone()
{
    setFirstStart(false);
    saveData();
}

void ESAAApp::askYesNoQuestion(const QString &mt, QJSValue yescallback, QJSValue nocallback)
{
    emit yesNoQuestion(mt, yescallback, nocallback);
}

void ESAAApp::showBadMessage(const QString &mt)
{
    emit showBadMessageSignal(mt);
}

void ESAAApp::showMessage(const QString &mt)
{
    emit showMessageSignal(mt, QJSValue::NullValue);
}

void ESAAApp::showMessageWithCallback(const QString &mt, QJSValue callback)
{
    emit showMessageSignal(mt, callback);
}

void ESAAApp::showWaitMessage(const QString &mt)
{
    emit showWaitMessageSignal(mt);
}

void ESAAApp::hideWaitMessage()
{
    emit hideWaitMessageSignal();
}

void ESAAApp::sendContactData()
{
    lastVisit.setBegin(QDateTime::currentDateTime());
    saveData();
    setLastVisitCount(updateAndGetVisitCount(locationGUID(), lastVisit.begin()));
    lastVisit.setEnd(QDateTime());
    sendMail();

    lastVisit.ibdToken = QDateTime::currentDateTime().toString(Qt::ISODate);
    lastVisit.ibdToken += QString(".") + locationGUID();
    lastVisit.ibdToken += QString(".") + jw78::Utils::genUUID();
    QString url(baseServerURL() + ibdTokenStoreMethod + lastVisit.ibdToken);
    QNetworkRequest request(url);
    QNetworkReply *networkReply(networkAccessManager.get(qthelper::setSSL(request)));
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply] {
        qDebug() << "StoreToken finished" << networkReply->error() << networkReply->readAll();
        networkReply->deleteLater();// Don't forget to delete it
    });
    Visit *newVisit(new Visit);
    *newVisit = lastVisit;
    if (!lastVisitOfFacility[newVisit->facilityName()].isValid() || lastVisitOfFacility[newVisit->facilityName()].addSecs(60 * 60 * 6) < newVisit->begin())
    {
        facilityName2VisitCount[newVisit->facilityName()] += 1;
        newVisit->setCount(facilityName2VisitCount[newVisit->facilityName()]);
        allVisits.add(newVisit);
    }

    saveVisit(lastVisit.begin(), lastVisit.end());
    saveData();
}

void ESAAApp::ignoreQRCode()
{
    lastActionJSON = "";
}

QString ESAAApp::generateQRcodeIntern(const QString &code, const QString &fn, bool addToQrCodesList)
{
    QString filename(jw78::Utils::getTempPath() + "/" + fn + ".svg");
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
    pix.toImage().save(jw78::Utils::getTempPath() + "/" + fn + ".png");
    pix.toImage().save(jw78::Utils::getTempPath() + "/" + fn + ".jpg");
    qrCodes.insert(filename);
    qrCodes.insert(jw78::Utils::getTempPath() + "/" + fn + ".png");
    qrCodes.insert(jw78::Utils::getTempPath() + "/" + fn + ".jpg");
    return filename;
}

void ESAAApp::onSek30Timeout()
{
    checkLoggedIn();
    helpOfferManager.storeHelpOffer(loggedIn(),
                                    loginTokenString(),
                                    secToken);
}

void ESAAApp::checkLoggedIn()
{
    if (!loginTokenString().size())
    {
        setLoggedIn(false);
        return;
    }
    QString url(baseServerURL() + "/notloggedin/login?sec_token=" + secToken);
    QMap<QString, QString> variables;
    variables["loginTokenString"] = loginTokenString();
    QNetworkReply *networkReply(serverPost(url, variables));
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply, this] {
        networkReply->deleteLater();// Don't forget to delete it
        if (networkReply->error() != QNetworkReply::NoError)
        {
            setLoggedIn(false);
            return;
        }
        QByteArray answer(networkReply->readAll());
        QJsonDocument jsonDoc(QJsonDocument::fromJson(answer));
        QJsonObject jsonObject(jsonDoc.object());
        int messageCode(jsonObject["messageCode"].toInt());
        qDebug() << answer;
        if (messageCode != 3)
        {
            setLoggedIn(false);
        }
        if (messageCode == 3)
        {
            setLoggedIn(true);
        }
    });
}

void ESAAApp::fetchLogo(const QString &logoUrl, QImage &target)
{
    QString url(logoUrl);
    QNetworkRequest request(url);
    QNetworkReply *networkReply(networkAccessManager.get(qthelper::setSSL(request)));
    QEventLoop loop;
    connect(networkReply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();
    target.loadFromData(networkReply->readAll());
}


void ESAAApp::interpretExtendedQRCodeData(const QString &qrCodeJSON)
{
    QJsonDocument qrJSON(QJsonDocument::fromJson(qrCodeJSON.toUtf8()));
    QJsonObject data(qrJSON.object());
    QString facilityId(data["id"].toString());
    setTableNumberWanted(data["tableNumber"].toBool());
    setWhoIsVisitedWanted(data["whoIsVisited"].toBool());
    setStationWanted(data["station"].toBool());
    setRoomWanted(data["room"].toBool());
    setBlockWanted(data["block"].toBool());
    setSeatNumberWanted(data["seatNumber"].toBool());
    QString logo(data["logo"].toString());
    if (logo.size())
    {
        setLogoUrl(logo);
        currentQRCodeData.setLogoUrl(logo);
    }
    clearYesQuestions();
    for (int i(0); i < 20; ++i)
    {
        QString question("yesQuestion");
        question += QString::number(i);
        QString yq(data[question].toString());
        if (yq.length())
        {
            addYesQuestions(yq);
        }
    }
    setYesQuestionCount(yesQuestions.size());
    currentQRCodeData.setWebsiteURL(data["websiteURL"].toString());
    currentQRCodeData.setFoodMenueURL(data["foodMenueURL"].toString());
    currentQRCodeData.setDrinksMenueURL(data["drinksMenueURL"].toString());
    currentQRCodeData.setIndividualURL1(data["individualURL1"].toString());
    currentQRCodeData.setIndividualURL1Caption(data["individualURL1Caption"].toString());
    currentQRCodeData.setLunchMenueURL(data["lunchMenueURL"].toString());
    emit validQRCodeDetected();
    qrCodeStore.add(facilityId, qrCodeJSON);
}

void ESAAApp::fetchExtendedQRCodeData(const QString &facilityId)
{
    QString qrCode(qrCodeStore.get(facilityId));
    if (qrCode.size())
    {
        interpretExtendedQRCodeData(qrCode);
    }
    QString url("https://www.jw78.de/ibd/qrCodeFiles/" + facilityId + ".ibd");
    QNetworkRequest request(url);
    QNetworkReply *networkReply(networkAccessManager.get(qthelper::setSSL(request)));
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply, this, qrCode] {
        QByteArray data(networkReply->readAll());
        if (data != qrCode)
        {
            interpretExtendedQRCodeData(data);
        }
        qDebug() << "Extended Code Data fetched finished" << networkReply->error() << data;
        networkReply->deleteLater();// Don't forget to delete it
    });
}

void ESAAApp::action(QString qrCodeJSON)
{
    if (!qrCodeJSON.size())
    {
        return;
    }
    qDebug() << "qrCodeJSON: " << qrCodeJSON;
    qrCodeJSON.remove(superCodePrefix, Qt::CaseInsensitive);
    qDebug() << "qrCodeJSON: " << qrCodeJSON;
    if (lastActionDateTime.addSecs(10) > QDateTime::currentDateTime() && qrCodeJSON == lastActionJSON)
    {
        qDebug() << "der gleiche code wie vor max 10 Sekunden wird abgelehnt";
        return;
    }
    lastActionJSON = qrCodeJSON;
    lastActionDateTime = QDateTime::currentDateTime();
    QByteArray possibleBase64(qrCodeJSON.toUtf8());
    if (qrCodeJSON[0] != '{')
    {
        possibleBase64 = QByteArray::fromBase64(possibleBase64);
    }
    QJsonDocument qrJSON(QJsonDocument::fromJson(possibleBase64));
    QJsonObject data(qrJSON.object());
    int actionID(data["ai"].toInt());
    if (actionID == 0)
    {
        showBadMessage("Das ist leider kein \"IchBinDa!\"-QR-Code.");
        return;
    }
    if (actionID == actionIDKontakttagebuch)
    {
        if (mainPerson.fstname() == "" || mainPerson.surname() == "" || mainPerson.emailAdress() == "")
        {
            showMessage("Bitte gib noch deine Kontaktdaten (Vorname, Name, E-Mail-Adresse) zum Austausch an. (Menü/Kontaktdaten bearbeiten)");
            return;
        }
        QString otherEMail(data["ea"].toString());
        QString otherFstname(data["fn"].toString());
        QString otherSurname(data["sn"].toString());
        showWaitMessage("Bitte einen Moment Geduld, die E-Mails werden versendet");
        mailOffice.sendKontaktTagebuchEMails(mainPerson.fstname(), mainPerson.surname(), mainPerson.emailAdress(), otherFstname, otherSurname, otherEMail);
        saveKontaktsituation(otherFstname + " " + otherSurname, otherEMail);
        showMessage("Die Kontakttagebuch-E-Mails wurden versendet.");
        return;
    }
    if (actionID == actionIDCoronaKontaktdatenerfassung)
    {
        clearYesQuestions();
        setTableNumberWanted(false);
        setWhoIsVisitedWanted(false);
        setStationWanted(false);
        setRoomWanted(false);
        setBlockWanted(false);
        setSeatNumberWanted(false);
        qDebug() << "actionIDCoronaKontaktdatenerfassung";
        int qrCodeNumber(data["qn"].toInt());
        encrypter.setPublicKey(qrCodeNumber);
        QString email(data["e"].toString());
        QString wantedData(data["d"].toString());
        QString logo(data["logo"].toString());
        QString backgroundColor(data["color"].toString());
        QString facilityId(data["id"].toString());
        QString theFacilityName(data["ln"].toString());
        QString anonymEMail(data["ae"].toString());
        qDebug() << "facilityName: " << theFacilityName;
        qDebug() << "facilityId: " << facilityId;
        qDebug() << "anonymEMail: " << anonymEMail;
        qDebug() << "email: " << email;
        qDebug() << "wantedData: " << wantedData;
        qDebug() << "logo: " << logo;
        qDebug() << "backgroundColor: " << backgroundColor;
        currentQRCodeData.setLogoUrl(logo);
        currentQRCodeData.setLocationContactMailAdress(email);
        currentQRCodeData.setLocationAnonymContactMailAdress(anonymEMail);
        setLocationGUID(facilityId);
        setAdressWanted(wantedData.contains("adress"));
        setEMailWanted(wantedData.contains("email"));
        setMobileWanted(wantedData.contains("mobile"));
        setLogoUrl(logo);
        setColor(backgroundColor);
        setFacilityName(theFacilityName);
        setLastVisitCountX(data["x"].toInt());
        setLastVisitCountXColor(data["colorx"].toString());
        emit validQRCodeDetected();
        fetchExtendedQRCodeData(facilityId);
        return;
    }
    emit invalidQRCodeDetected();

}

void ESAAApp::openUrlORPdf(const QString &urlOrPdf)
{
    QDesktopServices::openUrl(QUrl(urlOrPdf));
    return;
    if (urlOrPdf.right(4).toLower() == ".pdf")
    {
        QString url(urlOrPdf);
        QFileInfo fileInfo(urlOrPdf);
        QString filename(jw78::Utils::getTempPath() + "/" + fileInfo.fileName());
        if (QFile::exists(filename))
        {
            filename = "file:////" + filename;
            QDesktopServices::openUrl(QUrl(filename));
            return;
        }
        QNetworkRequest request(url);
        QNetworkReply *networkReply(networkAccessManager.get(qthelper::setSSL(request)));
        QObject::connect(networkReply, &QNetworkReply::finished, [networkReply, filename] {
            qDebug() << "PDF loaded finished" << networkReply->error();
            QFile dataFile(filename);
            dataFile.open(QIODevice::WriteOnly);
            dataFile.write(networkReply->readAll());
            dataFile.close();
            QString f = "file:////" + filename;
            QDesktopServices::openUrl(QUrl(f));
            networkReply->deleteLater();// Don't forget to delete it
        });
        return;
    }
    QDesktopServices::openUrl(QUrl(urlOrPdf, QUrl::TolerantMode));
}

QString ESAAApp::generateKontaktTagebuchQRCode()
{
    QJsonObject qr;
    qr["ai"] = actionIDKontakttagebuch;
    qr["fn"] = mainPerson.fstname();
    qr["sn"] = mainPerson.surname();
    qr["ea"] = mainPerson.emailAdress();
    QByteArray qrCodeData(QJsonDocument(qr).toJson(QJsonDocument::Compact));
    QString qrCodeFilename(generateQRcodeIntern(qrCodeData, "kontaktTagebuchQRCode", false));
    return qrCodeFilename;
}

QString ESAAApp::generateQRCode(const int qrCodeNumer,
                                const QString &facilityName,
                                const QString &contactReceiveEMail,
                                const QString &theLogoUrl,
                                const QColor color,
                                bool withAddress,
                                bool withEMail,
                                bool withMobile,
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
                                const QString &lunchMenueURL)
{
    SLocationInfo &li(email2locationInfo[contactReceiveEMail]);
    if (li.locationId == "")
    {
        li.locationId = jw78::Utils::genUUID();
    }
    li.contactReceiveEmail = contactReceiveEMail;
    li.facilityName = facilityName;
    li.color = color;
    li.logoUrl = theLogoUrl;
    li.anonymReceiveEMail = anonymReceiveEMail;

    saveData();
    QJsonObject qr;
    qr["qn"] = qrCodeNumer;
    qr["ai"] = actionIDCoronaKontaktdatenerfassung;
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
    qr["x"] = visitCountX;
    qr["xcolor"]  = visitCountXColor;
    QByteArray shortQRCode;
    //    shortQRCode += superCodePrefix.toLatin1();
    //    shortQRCode += QJsonDocument(qr).toJson(QJsonDocument::Compact).toBase64();
    shortQRCode += QJsonDocument(qr).toJson(QJsonDocument::Compact);
    for (size_t i(0); i < yesQuestions.size(); ++i)
    {
        qr[QString("yesQuestion") + QString::number(i)] = yesQuestions[i];
    }
    qr["logo"] = li.logoUrl;
    qr["tableNumber"] = tableNumber;
    qr["whoIsVisited"] = whoIsVisited;
    qr["station"] = station;
    qr["room"] = room;
    qr["block"] = block;
    qr["seatNumber"] = seatNumber;
    qr["websiteURL"] = websiteURL;
    qr["foodMenueURL"] = foodMenueURL;
    qr["drinksMenueURL"] = drinksMenueURL;
    qr["individualURL1"] = individualURL1;
    qr["individualURL1Caption"] = individualURL1Caption;
    qr["lunchMenueURL"] = lunchMenueURL;
    facilityIdToPost = li.locationId;
    qrCodeDataToPost = QJsonDocument(qr).toJson(QJsonDocument::Compact);
    qrCodes.clear();
    QString qrCodeFilename(generateQRcodeIntern(shortQRCode, "qr", true));
    return qrCodeFilename;
}

void ESAAApp::sendQRCode(const QString &qrCodeReceiver, const QString &facilityName, const QString &logoUrl)
{
    QImage logo;
    fetchLogo(logoUrl, logo);
    mailOffice.sendQRCode(qrCodeReceiver, facilityName, logo, qrCodes);
    postQRCodeData(facilityIdToPost, qrCodeDataToPost);
    showMessage(QString("Der QR-Code wurde an ") + qrCodeReceiver + " gesendet");
}

void ESAAApp::postQRCodeData(QString const &filename, QByteArray const &data)
{
    QString url(baseServerURL() + fileStoreMethod);
    QJsonObject json;
    json["name"] = "idbQRCodeData";
    json["filename"] = filename;
    json["filedata"] = data.toBase64().toStdString().c_str();
    QJsonObject jsonData;
    jsonData["data"] = json;

    QByteArray ba(QJsonDocument(jsonData).toJson(QJsonDocument::Compact));
    QNetworkRequest request(url);
    qthelper::setSSL(request);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QUrlQuery postdata;
    postdata.addQueryItem("json", QUrl::toPercentEncoding(ba));
    QNetworkReply *networkReply(networkAccessManager.post(request, postdata.toString(QUrl::FullyEncoded).toUtf8()));
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply] {
        qDebug() << "postQRCode finished" << networkReply->error() << networkReply->readAll();
        networkReply->deleteLater();// Don't forget to delete it
    });

}


void ESAAApp::recommend()
{
    QString content("Ich benutze die ");
    content += appName() + " App um meine Kontaktdaten im Restaurant, Frisör und Co abzugeben. Hier kannst du sie herunterladen:\n\n(PlayStore) ";
    content += "https://play.google.com/store/apps/details?id=ichbinda78.jw78.de\n\noder\n\n(AppStore) https://apps.apple.com/us/app/id1528926162\n\n";
    content += "Besuch uns auf www.app-ichbinda.de für mehr Informationen";
    mobileExtensions.shareText(appName(), appName() + " Kontaktdatenaustausch per QR-Code", content);
    //    mobileExtension.shareText(appName(), appName() + " Kontaktdatenaustausch per QR-Code", content);
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
    setLineInputBorderColor(lineInputBorderColor().darker(110));
    qreal refDpi = 216.;
    qreal refHeight = 1776.;
    qreal refWidth = 1080.;
    QRect rect = QGuiApplication::primaryScreen()->geometry();
    qreal height = qMax(rect.width(), rect.height());
    qreal width = qMin(rect.width(), rect.height());
#ifndef DMOBILEDEVICE
    height = 499;
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
    double baseFontSize(20);
    double baseSpacing(31);
#ifdef DMOBILEDEVICE
    baseFontSize = 18;
#endif
    setFontInputPixelsize(m_ratioFont * baseFontSize * 0.8);
    setFontButtonPixelsize(m_ratioFont * baseFontSize);
    setFontMessageTextPixelsize(m_ratioFont * baseFontSize * 1.3);
    setSpacing(baseSpacing * m_ratio);
    setFontTextPixelsize(m_ratioFont * baseFontSize * 0.8);
    setHeaderFontPixelsize(m_ratioFont * baseFontSize * 1.5);
    setContentFontPixelsize(m_ratioFont * baseFontSize * 1.2);
}

void ESAAApp::reset()
{
    QFile(dataFileName).remove();
    showMessage("Alle Einstellungen wurden zurückgesetzt");
}

void ESAAApp::showLastTransmission()
{
    emit showSendedData();
    //    showMessage("Folgende Daten wurden verschlüsselt an<br><br><b>" + facilityName() + "</b><br><br>übertragen:<br><br>" + data2send());
}

void ESAAApp::finishVisit()
{
    lastVisit.setEnd(QDateTime::currentDateTime());
    saveData();
    sendMail();
    saveVisit(lastVisit.begin(), lastVisit.end());
    lastVisit.ibdToken = "";
    saveData();
}

bool ESAAApp::isActiveVisit(int changeCounter)
{    
    changeCounter += 10;
    if (!lastVisit.begin().isValid())
    {
        return false;
    }
    if (lastVisit.end().isValid() && lastVisit.end().date().year() != 1970 && lastVisit.begin() < lastVisit.end())
    {
        return false;
    }
    return QDateTime::currentDateTime() < lastVisit.begin().addSecs(60 * 60 * 12);
}

void ESAAApp::dummyGet()
{
    QString url("https://www.jw78.de/ibd/qrCodeFiles/902f2e65-9d45-4194-b067-d9b495b5664b.ibd");
    QNetworkRequest request(url);
    QNetworkReply *networkReply(networkAccessManager.get(qthelper::setSSL(request)));
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply, this] {
        qDebug() << "Dummy get finished" << networkReply->error();
        networkReply->deleteLater();// Don't forget to delete it
    });
}


void ESAAApp::saveKontaktsituation(const QString &name, const QString &adress)
{
    lastVisit = Visit();
    lastVisit.setBegin(QDateTime::currentDateTime());
    lastVisit.setEnd(lastVisit.begin().addSecs(60 * 30));
    lastVisit.setFacilityName(name);
    lastVisit.setStreet(adress);
    lastVisit.ibdToken = QDateTime::currentDateTime().toString(Qt::ISODate);
    lastVisit.ibdToken += QString(".") + "Kontaktsitutation";
    lastVisit.ibdToken += QString(".") + jw78::Utils::genUUID();
    saveVisit(lastVisit.begin(), lastVisit.end());
}

void ESAAApp::setIchBinDaScheme()
{
    setButtonDownColor("white");
    setButtonFromColor("#4581B3");
    setButtonToColor("#364995");
}

void ESAAApp::setWorkTimeScheme()
{
    setButtonDownColor("white");
    setButtonFromColor("orange");
    setButtonToColor(buttonFromColor().darker(150));
}

QNetworkReply *ESAAApp::serverPost(const QString &url, const QMap<QString, QString> &variables)
{
    QJsonObject json;
    QMap<QString, QString>::const_iterator it(variables.begin());
    while (it != variables.end())
    {
        json[it.key()] = it.value();
        ++it;
    }
    QJsonObject jsonData;
    jsonData["data"] = json;

    QByteArray ba(QJsonDocument(jsonData).toJson(QJsonDocument::Compact));
    QNetworkRequest request(url);
    qthelper::setSSL(request);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QUrlQuery postdata;
    postdata.addQueryItem("json", QUrl::toPercentEncoding(ba));
    QNetworkReply *networkReply(networkAccessManager.post(request, postdata.toString(QUrl::FullyEncoded).toUtf8()));
    return networkReply;
}


void ESAAApp::login(QString loginEMail,
                    QString password,
                    QString tan)
{
    QString url(baseServerURL() + "/notloggedin/login?sec_token=" + secToken);
    QMap<QString, QString> variables;
    variables["loginEMail"] = loginEMail;
    variables["password"] = password;
    variables["tan"] = tan;
    QNetworkReply *networkReply(serverPost(url, variables));
    showWaitMessage("Bitte einen Moment Geduld");
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply, this] {
        networkReply->deleteLater();// Don't forget to delete it
        hideWaitMessage();
        if (networkReply->error() != QNetworkReply::NoError)
        {
            showBadMessage("Der Login-Server ist derzeit nicht erreichbar, bitte versuche es später noch einmal.");
            return;
        }
        QByteArray answer(networkReply->readAll());
        QJsonDocument jsonDoc(QJsonDocument::fromJson(answer));
        QJsonObject jsonObject(jsonDoc.object());
        bool error(jsonObject["error"].toBool());
        int messageCode(jsonObject["messageCode"].toInt());
        qDebug() << answer;
        if (messageCode == 1)
        {
            showMessage("Diese E-Mail-Adresse ist kein registrierter Account, bitte registriere dich erst.");
        }
        if (messageCode == 13)
        {
            showMessage("Die Registrierung ist noch nicht abgeschlossen, bitte kontrolliere deine E-Mails und nutze den Login-Code");
        }
        if (messageCode == 3)
        {
            setLoginTokenString(jsonObject["loginTokenString"].toString());
            setLoggedIn(true);
            emit loginSuccessful();
        }
        if (messageCode == 2)
        {
            setLoginTokenString("");
            setLoggedIn(false);
            showMessage("Der Login oder das Passwort waren falsch, bitte versuch es erneut oder registriere dich.");
        }
    });
}

void ESAAApp::registerAccount(QString loginEMail, QString password)
{
    QString url(baseServerURL() + "/notloggedin/register?sec_token=" + secToken);
    QMap<QString, QString> variables;
    variables["loginEMail"] = loginEMail;
    variables["password"] = password;
    QNetworkReply *networkReply(serverPost(url, variables));
    showWaitMessage("Bitte einen Moment Geduld");
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply, this] {
        hideWaitMessage();
        QByteArray answer(networkReply->readAll());
        QJsonDocument jsonDoc(QJsonDocument::fromJson(answer));
        QJsonObject jsonObject(jsonDoc.object());
        bool error(jsonObject["error"].toBool());
        QString message(jsonObject["message"].toString());
        int messageCode(jsonObject["messageCode"].toInt());
        qDebug() << message;
        if (message == "Person registered")
        {
            showMessage("Registrierung erfolgreich, wir haben Dir eine E-Mail mit einem Login-Code zugeschickt.<br>Bitte kontrolliere deine E-Mails.");
            setRegistered(true);
        }
        if (message == "E-Mail already in use")
        {
            showMessage("Dieser Login wird schon verwendet, falls du Dein Passwort vergessen hast kannst du einen Login-Code anfordern.");
        }
        networkReply->deleteLater();// Don't forget to delete it
    });
}

void ESAAApp::requestLoginCode(QString loginEMail)
{
    // not yet implemented
    QString url(baseServerURL() + "/notloggedin/forgotPassword?sec_token=" + secToken);
    QMap<QString, QString> variables;
    variables["loginEMail"] = loginEMail;
    QNetworkReply *networkReply(serverPost(url, variables));
    showWaitMessage("Bitte einen Moment Geduld");
    QObject::connect(networkReply, &QNetworkReply::finished, [networkReply, this] {
        hideWaitMessage();
        QByteArray answer(networkReply->readAll());
        qDebug() << answer;
        QJsonDocument jsonDoc(QJsonDocument::fromJson(answer));
        QJsonObject jsonObject(jsonDoc.object());
        bool error(jsonObject["error"].toBool());
        QString message(jsonObject["message"].toString());
        int messageCode(jsonObject["messageCode"].toInt());
        qDebug() << messageCode << " " << message;
        if (messageCode == 1)
        {
            showMessage("Die E-Mail-Adresse ist leider unbekannt.");
        }
        if (messageCode == 18)
        {
            showMessage("Wir haben dir einen Code an die angegebene E-Mail-Adresse geschickt. Bitte kontrolliere deine E-Mails.");
        }
        networkReply->deleteLater();// Don't forget to delete it
    });

    emit requestLoginCodeSuccessful();
}

bool ESAAApp::appendAVisit(Visit *aVisit)
{
    QString fn(aVisit->facilityName());
    QDateTime begin(aVisit->begin());
    if (fn.size() && begin.isValid() && (!lastVisitOfFacility[fn].isValid() || lastVisitOfFacility[fn].addSecs(60 * 60 * 6) < begin))
    {
        lastVisitOfFacility[fn] = begin;
        facilityName2VisitCount[fn] += 1;
        aVisit->setCount(facilityName2VisitCount[fn]);
        allVisits.add(aVisit);
        return true;
    }
    return false;
}

void ESAAApp::loadAllVisits()
{
    QDir directory(jw78::Utils::getWriteablePath());
    QStringList visitFiles(directory.entryList(QStringList() << "visits-*.json", QDir::Files));
    for (int i(0); i < visitFiles.size(); ++i)
    {
        QString visitFileName(jw78::Utils::getWriteablePath() + "/" + visitFiles[i]);
        QFile visitFile(visitFileName);
        if (visitFile.open(QIODevice::ReadOnly))
        {
            QByteArray visitData = visitFile.readAll();
            QJsonDocument loadDoc(QJsonDocument::fromJson(visitData));
            QJsonObject data(loadDoc.object());
            QJsonArray visitArray(data["visits"].toArray());
            for (int v(0); v < visitArray.size(); ++v)
            {
                QJsonObject visitObject(visitArray[v].toObject());
                Visit *aVisit(new Visit);
                QString fn(visitObject["facilityName"].toString());
                aVisit->setFacilityName(fn);
                aVisit->setLogoUrl(visitObject["logoUrl"].toString());
                QString beginStr(visitObject["begin"].toString());
                QDateTime begin(QDateTime::fromString(beginStr, Qt::ISODate));
                aVisit->setBegin(begin);
                if (!appendAVisit(aVisit))
                {
                    delete aVisit;
                }
            }
        }
    }
}
