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
    QVector<PauseTimeSpan> pauseTimeSpans;
public:
    WorkTimeSpan();
};

#endif // WORKTIMESPAN_H
