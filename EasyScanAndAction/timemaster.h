#ifndef TIMEMASTER_H
#define TIMEMASTER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include "JW78QTLib/jw78qtmacros.h"
#include <QDateTime>
#include <QString>

class ESAAApp;

class TimeMaster : public QObject
{
    Q_OBJECT
    ESAAApp &theApp;
    void savedata();
    JWPROPERTYAFTERSET(QString, currentWorkStart, CurrentWorkStart, "", savedata);
    JWPROPERTYAFTERSET(QString, currentPauseStart, CurrentPauseStart, "", savedata);
    JWPROPERTYAFTERSET(QString, currentWorkTravelStart, CurrentWorkTravelStart, "", savedata);

public:
    explicit TimeMaster(QQmlApplicationEngine &engine, ESAAApp &app, QObject *parent = nullptr);

signals:

};

#endif // TIMEMASTER_H
