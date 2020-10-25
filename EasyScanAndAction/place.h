#ifndef PLACE_H
#define PLACE_H

#include "JW78QTLib/jw78ProxyObject.h"

class Place: public jw78::ProxyObject
{
    Q_OBJECT
    JWPROPERTY(QString, name, Name, "")
    JWPROPERTY(QString, adress, Adress, "")
    JWPROPERTY(QString, types, Types, "")
public:
    Place();
};

#endif // PLACE_H
