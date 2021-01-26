#ifndef HELPOFFER_H
#define HELPOFFER_H

#include "dataModel/jw78ProxyObject.h"
#include "persistent/jw78persistentobject.h"
#include <QDateTime>

class HelpOffer: public jw78::ProxyObject, public jw78::PersistentObject
{
    Q_OBJECT
    JWPROPERTY(QString, description, Description, "");
    JWPROPERTY(QString, caption, Caption, "");
    JWPROPERTY(double, latitude, Latitude, 0);
    JWPROPERTY(double, longitude, Longitute, 0);
    JWPROPERTY(QString, offererUuid, OffererUuid, "");
protected:
    pureReflection *internalCreate(bool genUuid) const override;
public:
    bool transferred;
    HelpOffer(bool genUuid);
};

#endif // HELPOFFER_H
