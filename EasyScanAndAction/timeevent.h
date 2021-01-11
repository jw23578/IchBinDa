#ifndef TIMEEVENT_H
#define TIMEEVENT_H

#include "dataModel/jw78ProxyObject.h"
#include "persistent/jw78persistentobject.h"
#include <QDateTime>

class TimeEvent: public jw78::ProxyObject, public jw78::PersistentObject
{
    Q_OBJECT
    JWPROPERTY(qint64, eventType, EventType, 0)
    JWPROPERTY(QDateTime, timeStamp, TimeStamp, QDateTime())
    qint64 transferedToServer;
protected:
    pureReflection *internalCreate(bool genUuid) const override;
public:
    TimeEvent(bool genUuid);

    Q_INVOKABLE QString type2String();
};

#endif // TIMEEVENT_H
