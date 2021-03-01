#ifndef DAYTIMESPAN_H
#define DAYTIMESPAN_H

#include "dataModel/jw78ProxyObject.h"
#include <QDate>

class DayTimeSpan: public jw78::ProxyObject
{
    Q_OBJECT
    JWPROPERTY(QDate, day, Day, QDate());
    JWPROPERTY(QTime, since, Since, QTime());
    JWPROPERTY(QTime, until, Until, QTime());
public:
    DayTimeSpan();

    Q_INVOKABLE QString getDay(QDate dummy);
    Q_INVOKABLE QString getSince(QTime dummy);
    Q_INVOKABLE QString getUntil(QTime dummy);

    bool operator==(const DayTimeSpan &other);

};

#endif // DAYTIMESPAN_H
