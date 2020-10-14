#ifndef TIMEEVENT_H
#define TIMEEVENT_H

#include "JW78QTLib/jw78ProxyObject.h"
#include "JW78QTLib/jw78reflectableobject.h"
#include <QDateTime>

class TimeEvent: public jw78::ProxyObject, public jw78::ReflectableObject
{
    Q_OBJECT
    JWPROPERTY(qint64, eventType, EventType, 0)
    JWPROPERTY(QDateTime, timeStamp, TimeStamp, QDateTime())
public:
    TimeEvent(bool setUuid);

    ReflectableObject *create(bool setUuid) const;
    Q_INVOKABLE QString type2String();
};

#endif // TIMEEVENT_H
