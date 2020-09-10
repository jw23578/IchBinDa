#include "persistentmap.h"
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFile>

PersistentMap::PersistentMap(const QString &filename,
                             const QString &firstName,
                             const QString &secondName):filename(filename),
    firstName(firstName),
    secondName(secondName)
{
    load();
}

void PersistentMap::load()
{
    QFile dataFile(filename);
    if (!dataFile.open(QIODevice::ReadOnly))
    {
        qWarning("QR-Code filename konnte nicht zum laden geöffnet werden.");
        return;
    }
    QByteArray saveData = dataFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
    QJsonArray qrCodes(loadDoc.object()["data"].toArray());
    for (int i(0); i < qrCodes.size(); ++i)
    {
        QJsonObject d(qrCodes[i].toObject());
        dataMap[d[firstName].toString()] = d[secondName].toString();
    }
}

void PersistentMap::save()
{
    QFile dataFile(filename);
    if (!dataFile.open(QIODevice::WriteOnly))
    {
        qWarning("QR-Code filename konnte nicht zum speichern geöffnet werden.");
        return;
    }
    QJsonArray qrCodes;
    std::map<QString, QString>::iterator it(dataMap.begin());
    while (it != dataMap.end())
    {
        QJsonObject d;
        d[firstName] = it->first;
        d[secondName] = it->second;
        qrCodes.append(d);
        ++it;
    }
    QJsonObject d;
    d["data"] = qrCodes;
    dataFile.write(QJsonDocument(d).toJson());
}
