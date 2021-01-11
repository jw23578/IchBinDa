#ifndef FLYERGENERATOR_H
#define FLYERGENERATOR_H

#include <QString>
#include <QImage>

class FlyerGenerator
{
public:
    FlyerGenerator();
    QString generateA6Flyer(const QString &facilityName,
                            const QImage &logo,
                            const QString qrCodeFilename,
                            int number);
    QString generateA5Flyer(const QString &facilityName,
                            const QImage &logo,
                            const QString qrCodeFilename,
                            int number);
    QString generateA4Flyer1(const QString &facilityName,
                             const QImage &logo,
                             const QString qrCodeFilename,
                             int number);
};

#endif // FLYERGENERATOR_H
