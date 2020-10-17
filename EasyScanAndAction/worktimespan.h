#ifndef WORKTIMESPAN_H
#define WORKTIMESPAN_H

#include "pausetimespan.h"
#include "JW78QTLib/jw78ProxyObject.h"
#include <QDateTime>

class WorkTimeSpan: public jw78::ProxyObject
{
    Q_OBJECT
    JWPROPERTY(QDateTime, workBegin, WorkBegin, QDateTime())
    JWPROPERTY(QDateTime, workEnd, WorkEnd, QDateTime())

    JWPROPERTY(int, pauseMinutesBrutto, PauseMinutesBrutto, 0);
    QVector<PauseTimeSpan*> pauseTimeSpans;
public:
    WorkTimeSpan();
    void addPause(PauseTimeSpan *pts);
};

#endif // WORKTIMESPAN_H
