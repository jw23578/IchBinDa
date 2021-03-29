#ifndef DAYTIMESPAN_H
#define DAYTIMESPAN_H

#include "dataModel/jw78ProxyObject.h"
#include "persistent/jw78persistentobject.h"
#include <QDate>

class DayTimeSpan: public jw78::ProxyObject,  public jw78::PersistentObject
{
    Q_OBJECT
    JWPROPERTY(QDate, day, Day, QDate());
    JWPROPERTY(QTime, since, Since, QTime());
    JWPROPERTY(QTime, until, Until, QTime());
    void addVariables();
public:
    QString helpOfferUuid;

    DayTimeSpan();
    DayTimeSpan(const DayTimeSpan &other);

    Q_INVOKABLE QString getDay(QDate dummy);
    Q_INVOKABLE QString getSince(QTime dummy);
    Q_INVOKABLE QString getUntil(QTime dummy);

    bool operator==(const DayTimeSpan &other);


    // pureReflection interface
protected:
    jw::pureReflection *internalCreate(bool genUuid) const;
};

#endif // DAYTIMESPAN_H
