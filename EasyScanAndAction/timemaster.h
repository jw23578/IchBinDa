#ifndef TIMEMASTER_H
#define TIMEMASTER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include "JW78QTLib/jw78qtmacros.h"
#include <QDateTime>
#include <QString>
#include <JW78QTLib/jw78ObjectListModel.h>
#include <JW78QTLib/jw78persistentadapter.h>
#include "worktimespan.h"
#include "datetimereflectable.h"

class ESAAApp;

class TimeMaster : public QObject
{
    Q_OBJECT
    ESAAApp &theApp;
    jw78::PersistentAdapter &pa;
    DateTimeReflectable dbCurrentWorkStart;
    DateTimeReflectable dbCurrentPauseStart;
    DateTimeReflectable dbCurrentWorkTravelStart;
    void handleEvent(const QString &name, const QDateTime &value);
    JWPROPERTYAFTERSETNAMEVALUE(QDateTime, currentWorkStart, CurrentWorkStart, QDateTime(), handleEvent);
    JWPROPERTYAFTERSETNAMEVALUE(QDateTime, currentPauseStart, CurrentPauseStart, QDateTime(), handleEvent);
    JWPROPERTYAFTERSETNAMEVALUE(QDateTime, currentWorkTravelStart, CurrentWorkTravelStart, QDateTime(), handleEvent);

    jw78::ObjectListModel allTimeEvents;
    jw78::ObjectListModel workTimeSpans;

public:
    explicit TimeMaster(QQmlApplicationEngine &engine, ESAAApp &app, jw78::PersistentAdapter &pa, QObject *parent = nullptr);

    Q_INVOKABLE QDateTime now();
    Q_INVOKABLE QDateTime nullDate();
    Q_INVOKABLE bool isNull(const QDateTime &dt);
    Q_INVOKABLE bool isValid(const QDateTime &dt);

signals:

};

#endif // TIMEMASTER_H