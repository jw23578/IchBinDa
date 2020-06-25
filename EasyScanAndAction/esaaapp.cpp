#include "esaaapp.h"
#include <QQmlContext>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>
#include <QJsonObject>
#include <QJsonDocument>

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
    QJsonObject data;
    data["contactData"] = contactData;
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
    if (data.contains("contactData"))
    {
        QJsonObject contactData(data["contactData"].toObject());
        setFstname(contactData["fstname"].toString());
        setSurname(contactData["surname"].toString());
    }
}



ESAAApp::ESAAApp(QQmlApplicationEngine &e):QObject(&e)
{
    e.rootContext()->setContextProperty("ESAA", QVariant::fromValue(this));
    QDir dir;
    if (!dir.exists(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)))
    {
        dir.mkdir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    }
    dataFileName = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/esaaData.json";
    qDebug() << dataFileName;
    loadData();
}

void ESAAApp::showMessage(const QString &mt)
{
    emit showMessageSignal(mt);
}

void ESAAApp::sendContactData()
{
    saveData();
}
