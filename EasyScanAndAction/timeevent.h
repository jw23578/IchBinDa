#ifndef TIMEEVENT_H
#define TIMEEVENT_H

#include "JW78QTLib/jw78ProxyObject.h"
#include "JW78QTLib/reflection/jw_purereflection.h"
#include <QDateTime>

class TimeEvent: public jw78::ProxyObject, public jw::pureReflection
{
    Q_OBJECT
    JWPROPERTY(qint64, eventType, EventType, 0)
    JWPROPERTY(QDateTime, timeStamp, TimeStamp, QDateTime())
    qint64 transferedToServer;
public:
    TimeEvent(bool genUuid);

    pureReflection *create(bool genUuid) const;
    Q_INVOKABLE QString type2String();
};

#endif // TIMEEVENT_H
