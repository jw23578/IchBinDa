#ifndef QRCODESTORE_H
#define QRCODESTORE_H

#include <QString>
#include <map>

class QRCodeStore
{
    QString filename;
    std::map<QString, QString> facilityID2qrCode;
    void save();
    void load();
public:
    QRCodeStore(QString const &filename);
    void add(const QString &facilityID, const QString &qrCode);
    QString get(const QString &facilityID);
};

#endif // QRCODESTORE_H
