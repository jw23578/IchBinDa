#include "qrcodestore.h"
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFile>


void QRCodeStore::save()
{
    QFile dataFile(filename);
    if (!dataFile.open(QIODevice::WriteOnly))
    {
        qWarning("QR-Code filename konnte nicht zum speichern geöffnet werden.");
        return;
    }
    QJsonArray qrCodes;
    std::map<QString, QString>::iterator it(facilityID2qrCode.begin());
    while (it != facilityID2qrCode.end())
    {
        QJsonObject d;
        d["facilityID"] = it->first;
        d["qrCode"] = it->second;
        qrCodes.append(d);
        ++it;
    }
    QJsonObject d;
    d["qrCodes"] = qrCodes;
    dataFile.write(QJsonDocument(d).toJson());
}

void QRCodeStore::load()
{
    QFile dataFile(filename);
    if (!dataFile.open(QIODevice::ReadOnly))
    {
        qWarning("QR-Code filename konnte nicht zum laden geöffnet werden.");
        return;
    }
    QByteArray saveData = dataFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
    QJsonArray qrCodes(loadDoc.object()["qrCodes"].toArray());
    for (int i(0); i < qrCodes.size(); ++i)
    {
        QJsonObject d(qrCodes[i].toObject());
        facilityID2qrCode[d["facilityID"].toString()] = d["qrCode"].toString();
    }
}

QRCodeStore::QRCodeStore(QString const &filename): filename(filename)
{
    load();
}

void QRCodeStore::add(const QString &facilityID, const QString &qrCode)
{
    if (facilityID2qrCode.find(facilityID) != facilityID2qrCode.end())
    {
        if (facilityID2qrCode[facilityID] == qrCode)
        {
            return;
        }
    }
    facilityID2qrCode[facilityID] = qrCode;
    save();
}

QString QRCodeStore::get(const QString &facilityID)
{
    if (facilityID2qrCode.find(facilityID) == facilityID2qrCode.end())
    {
        return "";
    }
    return facilityID2qrCode[facilityID];
}
