#ifndef CUSTOMERCARD_H
#define CUSTOMERCARD_H

#include "JW78QTLib/jw78ProxyObject.h"
#include "JW78QTLib/jw78reflectableobject.h"

class CustomerCard: public jw78::ProxyObject, public jw78::ReflectableObject
{
    Q_OBJECT
    JWPROPERTY(QString, name, Name, "")
    JWPROPERTY(QString, filename, Filename, "")
public:
    CustomerCard(bool setUuid);
    CustomerCard *create(bool setUuid) const;
};

#endif // CUSTOMERCARD_H
