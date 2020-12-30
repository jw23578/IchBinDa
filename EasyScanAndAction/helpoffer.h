#ifndef HELPOFFER_H
#define HELPOFFER_H

#include "JW78QTLib/jw78ProxyObject.h"
#include "JW78QTLib/jw78reflectableobject.h"
#include <QDateTime>

class HelpOffer: public jw78::ProxyObject, public jw78::ReflectableObject
{
    Q_OBJECT
    JWPROPERTY(QString, descricption, Description, "");
    JWPROPERTY(QString, caption, Caption, "");
    JWPROPERTY(double, latitude, Latitude, 0);
    JWPROPERTY(double, longitude, Longitute, 0);
    JWPROPERTY(QString, offererUuid, OffererUuid, "");
public:
    HelpOffer();
};

#endif // HELPOFFER_H
