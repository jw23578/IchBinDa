#ifndef VISIT_H
#define VISIT_H

#include <QObject>
#include <QColor>
#include <QDateTime>
#include "qt_extension_macros.h"


class Visit: public QObject
{
    Q_OBJECT
    QString ibdToken;
    JWPROPERTY(QString, locationContactMailAdress, LocationContactMailAdress, "");
    JWPROPERTY(QString, logoUrl, LogoUrl, "");
    JWPROPERTY(QColor, color, Color, "#ffffff");

    JWPROPERTY(QString, facilityName, FacilityName, "");
    JWPROPERTY(int, count, Count, 0);
    JWPROPERTY(QDateTime, begin, Begin, QDateTime());
    JWPROPERTY(QDateTime, end, End, QDateTime());
    JWPROPERTY(QString, fstname, Fstname, "")
    JWPROPERTY(QString, surname, Surname, "");
    JWPROPERTY(QString, street, Street, "");
    JWPROPERTY(QString, housenumber, Housenumber, "");
    JWPROPERTY(QString, zip, Zip, "");
    JWPROPERTY(QString, location, Location, "");
    JWPROPERTY(QString, emailAdress, EmailAdress, "");
    JWPROPERTY(QString, mobile, Mobile, "");
    JWPROPERTY(QColor, countXColor, CountXColor, "");
    JWPROPERTY(int, countX, CountX, 0);
    QDateTime visitBegin;
    QDateTime visitEnd;
public:
    Visit();
};

#endif // VISIT_H
