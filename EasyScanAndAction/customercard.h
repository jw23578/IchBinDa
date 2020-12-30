#ifndef CUSTOMERCARD_H
#define CUSTOMERCARD_H

#include "JW78QTLib/jw78ProxyObject.h"
#include "JW78QTLib/reflection/jw_purereflection.h"

class CustomerCard: public jw78::ProxyObject, public jw::pureReflection
{
    Q_OBJECT
    JWPROPERTY(QString, name, Name, "")
    JWPROPERTY(QString, filename, Filename, "")
public:
    CustomerCard(bool genUuid);
    CustomerCard *create(bool genUuid) const;
};

#endif // CUSTOMERCARD_H
