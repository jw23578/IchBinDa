#ifndef TIMEEVENT_H
#define TIMEEVENT_H

#include "JW78QTLib/jw78ProxyObject.h"
#include <QDateTime>

class TimeEvent: public jw78::ProxyObject
{
    Q_OBJECT
    JWPROPERTY(int, eventType, EventType, 0);
    JWPROPERTY(QDateTime, timeStamp, TimeStamp, QDateTime());
public:
    TimeEvent();
};

#endif // TIMEEVENT_H
