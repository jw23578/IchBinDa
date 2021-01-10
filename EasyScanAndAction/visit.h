#ifndef VISIT_H
#define VISIT_H

#include <QObject>
#include <QColor>
#include <QDateTime>
#include "JW78QTLib/jw78ProxyObject.h"


class Visit: public jw78::ProxyObject
{
    Q_OBJECT
    JWPROPERTY(QString, locationContactMailAdress, LocationContactMailAdress, "");
    JWPROPERTY(QString, locationAnonymContactMailAdress, LocationAnonymContactMailAdress, "");
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
    JWPROPERTY(QString, tableNumber, TableNumber, "");
    JWPROPERTY(QString, whoIsVisited, WhoIsVisited, "");
    JWPROPERTY(QString, station, Station, "");
    JWPROPERTY(QString, room, Room, "");
    JWPROPERTY(QString, block, Block, "");
    JWPROPERTY(QString, seatNumber, SeatNumber, "");

    JWPROPERTY(QString, websiteURL, WebsiteURL, "");
    JWPROPERTY(QString, foodMenueURL, FoodMenueURL, "");
    JWPROPERTY(QString, drinksMenueURL, DrinksMenueURL, "");
    JWPROPERTY(QString, individualURL1, IndividualURL1, "");
    JWPROPERTY(QString, individualURL1Caption, IndividualURL1Caption, "");
    JWPROPERTY(QString, lunchMenueURL, LunchMenueURL, "");

    QDateTime visitBegin;
    QDateTime visitEnd;
public:
    Visit();
    QString ibdToken;
    void operator=(const Visit &other);
};

#endif // VISIT_H
