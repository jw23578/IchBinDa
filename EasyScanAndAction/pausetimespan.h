#ifndef PAUSETIMESPAN_H
#define PAUSETIMESPAN_H

#include "JW78QTLib/jw78ProxyObject.h"
#include <QDateTime>

class PauseTimeSpan: public jw78::ProxyObject
{
    Q_OBJECT
    JWPROPERTY(QDateTime, pauseBegin, PauseBegin, QDateTime())
    JWPROPERTY(QDateTime, pauseEnd, PauseEnd, QDateTime())
public:
    PauseTimeSpan();
};

#endif // PAUSETIMESPAN_H
