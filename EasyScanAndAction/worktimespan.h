#ifndef WORKTIMESPAN_H
#define WORKTIMESPAN_H

#include "pausetimespan.h"
#include "dataModel/jw78ProxyObject.h"
#include <QDateTime>

class WorkTimeSpan: public jw78::ProxyObject
{
    Q_OBJECT
    void calculate();
    JWPROPERTY(QDateTime, workBegin, WorkBegin, QDateTime())
    JWPROPERTYAFTERSET(QDateTime, workEnd, WorkEnd, QDateTime(), calculate)
    JWPROPERTY(int, workMinutesBrutto, WorkMinutesBrutto, 0);
    JWPROPERTY(int, workMinutesNetto, WorkMinutesNetto, 0);
    JWPROPERTY(int, pauseMinutesNetto, PauseMinutesNetto, 0);
    JWPROPERTY(int, addedPauseMinutes, AddedPauseMinutes, 0);

    JWPROPERTY(int, pauseMinutesBrutto, PauseMinutesBrutto, 0);
    JWPROPERTY(int, pauseCount, PauseCount, 0);
    QVector<PauseTimeSpan*> pauseTimeSpans;
public:
    WorkTimeSpan();
    void addPause(PauseTimeSpan *pts);
    Q_INVOKABLE jw78::ProxyObject *getPause(int index);
};

#endif // WORKTIMESPAN_H
