#include "timemaster.h"
#include <QQmlContext>
#include "esaaapp.h"
#include "timeevent.h"

void TimeMaster::handleEvent(const QString &name, const QDateTime &value)
{
    TimeEvent *te(new TimeEvent);
    te->setTimeStamp(value);
    allTimeEvents.add(te);
    qDebug() << allTimeEvents.count();
    if (name == m_currentWorkStartName)
    {
        if (value.isNull())
        {
            // ende
            te->setEventType(1);
        }
        else
        {
            // beginn
            te->setEventType(0);
        }
        return;
    }
    if (name == m_currentPauseStartName)
    {
        if (value.isNull())
        {
            // ende
            te->setEventType(3);
        }
        else
        {
            // beginn
            te->setEventType(2);
        }
        return;
    }
    if (name == m_currentWorkTravelStartName)
    {
        if (value.isNull())
        {
            // ende
            te->setEventType(5);
        }
        else
        {
            // beginn
            te->setEventType(4);
        }
        return;
    }
}

TimeMaster::TimeMaster(QQmlApplicationEngine &engine,  ESAAApp &app, QObject *parent) : QObject(parent),
    theApp(app),
    allTimeEvents(engine, "AllTimeEvents", "event")
{
    engine.rootContext()->setContextProperty("TimeMaster", QVariant::fromValue(this));
}

QDateTime TimeMaster::now()
{
    return QDateTime::currentDateTime();
}

QDateTime TimeMaster::nullDate()
{
    return QDateTime();
}

bool TimeMaster::isNull(const QDateTime &dt)
{
    return dt.isNull();
}

bool TimeMaster::isValid(const QDateTime &dt)
{
    return dt.isValid();
}
