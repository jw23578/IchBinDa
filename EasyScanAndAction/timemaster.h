#ifndef TIMEMASTER_H
#define TIMEMASTER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include "jw78qtmacros.h"
#include <QDateTime>
#include <QString>
#include <dataModel/jw78ObjectListModel.h>
#include "worktimespan.h"
#include "datetimereflectable.h"
#include "persistent/jw78persistentstoresqlite.h"
class ESAAApp;

class TimeMaster : public QObject
{
    Q_OBJECT
    ESAAApp &theApp;
    jw78::PersistentStoreSQLite currentStateDatabase;
    jw78::PersistentStoreSQLite timeEventsDatabase;
    DateTimeReflectable dbCurrentWorkStart;
    DateTimeReflectable dbCurrentPauseStart;
    DateTimeReflectable dbCurrentWorkTravelStart;
    void handleEvent(const QString &name, const QDateTime &value);
    JWPROPERTYAFTERSETNAMEVALUE(QDateTime, currentWorkStart, CurrentWorkStart, QDateTime(), handleEvent);
    JWPROPERTYAFTERSETNAMEVALUE(QDateTime, currentPauseStart, CurrentPauseStart, QDateTime(), handleEvent);
    JWPROPERTYAFTERSETNAMEVALUE(QDateTime, currentWorkTravelStart, CurrentWorkTravelStart, QDateTime(), handleEvent);
    JWPROPERTY(QDateTime, currentYearMonth, CurrentYearMonth, QDateTime::currentDateTime())

    jw78::ObjectListModel allTimeEvents;
    jw78::ObjectListModel workTimeSpans;

public:
    explicit TimeMaster(QQmlApplicationEngine &engine,
                        ESAAApp &app,
                        const QString &databaseFilename,
                        QObject *parent = nullptr);

    Q_INVOKABLE void developPrepare();

    Q_INVOKABLE QDateTime now();
    Q_INVOKABLE QDateTime nullDate();
    Q_INVOKABLE bool isNull(const QDateTime &dt);
    Q_INVOKABLE bool isValid(const QDateTime &dt);
    Q_INVOKABLE void load(int year, int month);

signals:

};

#endif // TIMEMASTER_H
