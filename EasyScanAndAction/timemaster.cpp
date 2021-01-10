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
        dbCurrentWorkStart.value = value;
        currentStateDatabase.store(dbCurrentWorkStart);
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
        dbCurrentPauseStart.value = value;
        currentStateDatabase.store(dbCurrentPauseStart);
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
        dbCurrentWorkTravelStart.value = value;
        currentStateDatabase.store(dbCurrentWorkTravelStart);
    }
    timeEventsDatabase.insert(*te);
}

TimeMaster::TimeMaster(QQmlApplicationEngine &engine,
                       ESAAApp &app,
                       const QString &databaseFilename,
                       QObject *parent) : QObject(parent),
    theApp(app),
    currentStateDatabase(databaseFilename, "Config", *new DateTimeReflectable(false)),
    timeEventsDatabase(databaseFilename, "TimeEvents", *new TimeEvent(false)),
    dbCurrentWorkStart(true),
    dbCurrentPauseStart(true),
    dbCurrentWorkTravelStart(true),
    allTimeEvents(engine, "AllTimeEvents", "event"),
    workTimeSpans(engine, "WorkTimeSpansModel", "timeSpan")
{
    engine.rootContext()->setContextProperty("TimeMaster", QVariant::fromValue(this));

    dbCurrentWorkStart.name = "currentWorkStart";
    dbCurrentPauseStart.name = "currentPauseStart";
    dbCurrentWorkTravelStart.name = "currentWorkTravelStart";
    currentStateDatabase.fetchOneByEntityField("name", dbCurrentWorkStart.name, dbCurrentWorkStart);
    m_currentWorkStart = dbCurrentWorkStart.value;
    currentStateDatabase.fetchOneByEntityField("name", dbCurrentPauseStart.name, dbCurrentPauseStart);
    m_currentPauseStart = dbCurrentPauseStart.value;
    currentStateDatabase.fetchOneByEntityField("name", dbCurrentWorkTravelStart.name, dbCurrentWorkTravelStart);
    m_currentWorkTravelStart = dbCurrentWorkTravelStart.value;

    load(QDate::currentDate().year(),
         QDate::currentDate().month());
}

void TimeMaster::developPrepare()
{
    timeEventsDatabase.clear();
    QDate work(2020, 5, 1);
    int counter(1);
    while (work < QDate::currentDate())
    {
        counter += 1;
        int randMinutes(rand() % 20);
        TimeEvent te(true);
        te.setEventType(0);
        te.setTimeStamp(QDateTime(work, QTime(8, 0, 0, 0).addSecs(randMinutes * 60)));
        timeEventsDatabase.insert(te);
        te.setEventType(1);
        randMinutes = rand() % 20;
        te.setTimeStamp(QDateTime(work, QTime(17, 0, 0, 0).addSecs(randMinutes * 60)));
        timeEventsDatabase.insert(te);
        if (counter % 3 == 1)
        {
            randMinutes = rand() % 20;
            te.setEventType(2);
            te.setTimeStamp(QDateTime(work, QTime(9, 30, 0, 0).addSecs(randMinutes * 60)));
            timeEventsDatabase.insert(te);
            te.setEventType(3);
            randMinutes = rand() % 20;
            te.setTimeStamp(QDateTime(work, QTime(9, 45, 0, 0).addSecs(randMinutes * 60)));
            timeEventsDatabase.insert(te);
        }
        if (counter % 3 == 2)
        {
            randMinutes = rand() % 20;
            te.setEventType(2);
            te.setTimeStamp(QDateTime(work, QTime(9, 30, 0, 0).addSecs(randMinutes * 60)));
            timeEventsDatabase.insert(te);
            te.setEventType(3);
            randMinutes = rand() % 20;
            te.setTimeStamp(QDateTime(work, QTime(9, 45, 0, 0).addSecs(randMinutes * 60)));
            timeEventsDatabase.insert(te);

            te.setEventType(2);
            te.setTimeStamp(QDateTime(work, QTime(12, 30, 0, 0)));
            timeEventsDatabase.insert(te);
            te.setEventType(3);
            te.setTimeStamp(QDateTime(work, QTime(13, 15, 0, 0)));
            timeEventsDatabase.insert(te);
        }
        work = work.addDays(1);
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

void TimeMaster::load(int year, int month)
{
    allTimeEvents.clear();
    workTimeSpans.clear();
    TimeEvent templateEvent(false);
    QVector<jw78::PersistentObject*> temp;
    QDate monthStart(year, month, 1);
    QDate nextMonthStart(monthStart.addMonths(1));
    timeEventsDatabase.selectAllBetween("timeStamp",
                                        monthStart.toString(Qt::ISODate),
                                        nextMonthStart.toString(Qt::ISODate),
                                        temp);
    WorkTimeSpan *currentWorkTimeSpan(nullptr);
    PauseTimeSpan *currentPauseTimeSpan(nullptr);
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
            if (currentWorkTimeSpan != nullptr)
            {
                currentWorkTimeSpan->setWorkEnd(e->timeStamp());
                workTimeSpans.add(currentWorkTimeSpan);
                currentWorkTimeSpan = nullptr;
            }
        }
        if (e->eventType() == 2)
        {
            currentPauseTimeSpan = new PauseTimeSpan;
            currentPauseTimeSpan->setPauseBegin(e->timeStamp());
        }
        if (e->eventType() == 3)
        {
            if (currentPauseTimeSpan != nullptr && currentWorkTimeSpan != nullptr)
            {
                currentPauseTimeSpan->setPauseEnd(e->timeStamp());
                currentWorkTimeSpan->addPause(currentPauseTimeSpan);
                currentPauseTimeSpan = nullptr;
            }
        }
    }
}
