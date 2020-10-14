#include "timemaster.h"
#include <QQmlContext>
#include "esaaapp.h"
#include "timeevent.h"

void TimeMaster::handleEvent(const QString &name, const QDateTime &value)
{
    TimeEvent *te(new TimeEvent(true));
    QDateTime dt(QDateTime::currentDateTime());
    dt.setTime(QTime(dt.time().hour(), dt.time().minute()));
    te->setTimeStamp(dt);
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
    }
    pa.insert("TimeEvents", *te);
}

TimeMaster::TimeMaster(QQmlApplicationEngine &engine,
                       ESAAApp &app,
                       jw78::PersistentAdapter &pa,
                       QObject *parent) : QObject(parent),
    theApp(app),
    pa(pa),
    allTimeEvents(engine, "AllTimeEvents", "event"),
    workTimeSpans(engine, "WorkTimeSpans", "timeSpan")
{
    engine.rootContext()->setContextProperty("TimeMaster", QVariant::fromValue(this));
    std::unique_ptr<TimeEvent> te(new TimeEvent(false));
    QVector<jw78::ReflectableObject*> temp;
    pa.createTableCollectionOrFileIfNeeded("TimeEvents", *te);
    pa.loadAll("TimeEvents", temp, *te);
    WorkTimeSpan *currentWorkTimeSpan(nullptr);
    for (auto t : temp)
    {
        TimeEvent *e(dynamic_cast<TimeEvent*>(t));
        allTimeEvents.add(e);
        if (e->eventType() == 0)
        {
            currentWorkTimeSpan = new WorkTimeSpan;
            currentWorkTimeSpan->setWorkBegin(e->timeStamp());
        }
        if (e->eventType() == 1)
        {
            currentWorkTimeSpan->setWorkEnd(e->timeStamp());
            workTimeSpans.add(currentWorkTimeSpan);
            currentWorkTimeSpan = nullptr;
        }
    }
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
