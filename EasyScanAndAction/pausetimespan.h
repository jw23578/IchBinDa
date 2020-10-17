#ifndef PAUSETIMESPAN_H
#define PAUSETIMESPAN_H

#include "JW78QTLib/jw78ProxyObject.h"
#include <QDateTime>

class PauseTimeSpan: public jw78::ProxyObject
{
    Q_OBJECT
    void calculate();
    JWPROPERTY(QDateTime, pauseBegin, PauseBegin, QDateTime())
    JWPROPERTYAFTERSET(QDateTime, pauseEnd, PauseEnd, QDateTime(), calculate)
    JWPROPERTY(int, minutes, Minutes, 0);
public:
    PauseTimeSpan();
};

#endif // PAUSETIMESPAN_H
