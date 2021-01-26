#ifndef CUSTOMERCARD_H
#define CUSTOMERCARD_H

#include "dataModel/jw78ProxyObject.h"
#include "persistent/jw78persistentobject.h"

class CustomerCard: public jw78::ProxyObject, public jw78::PersistentObject
{
    Q_OBJECT
    JWPROPERTY(QString, name, Name, "")
    JWPROPERTY(QString, filename, Filename, "")
    protected:
        pureReflection *internalCreate(bool genUuid) const override;
public:
    CustomerCard(bool genUuid);
};

#endif // CUSTOMERCARD_H
