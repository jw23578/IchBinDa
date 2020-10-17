#include "worktimespan.h"
#include "JW78QTLib/jw78utils.h"

void WorkTimeSpan::calculate()
{
    int minutes(jw78::Utils::minutesBetween(workBegin(), workEnd()));
    setWorkMinutesBrutto(minutes);
    setWorkMinutesNetto(0);

    setPauseMinutesNetto(0);
    QDateTime lastPauseEnd;
    int lastDauerMinutes(0);
    for (auto p: pauseTimeSpans)
    {
        int dauerMinutes(jw78::Utils::minutesBetween(p->pauseBegin(), p->pauseEnd()));
        if (lastPauseEnd.addSecs(60) >= p->pauseBegin())
        {
            lastDauerMinutes += dauerMinutes;
        }
        else
        {
            if (lastDauerMinutes >= 15)
            {
                setPauseMinutesNetto(pauseMinutesNetto() + lastDauerMinutes);
            }
            lastDauerMinutes = dauerMinutes;
        }
        lastPauseEnd = p->pauseEnd();
    }
    if (lastDauerMinutes >= 15)
    {
        setPauseMinutesNetto(pauseMinutesNetto() + lastDauerMinutes);
    }
    setWorkMinutesNetto(minutes - pauseMinutesNetto());
    setAddedPauseMinutes(0);
    if (workMinutesNetto() > 9 * 60 && pauseMinutesNetto() < 45)
    {
        setAddedPauseMinutes(45 - pauseMinutesNetto());
    }
    else
    {
        if (workMinutesNetto() > 6 * 60 && pauseMinutesNetto() < 30)
        {
            setAddedPauseMinutes(30 - pauseMinutesNetto());
        }
    }
}

WorkTimeSpan::WorkTimeSpan()
{

}

void WorkTimeSpan::addPause(PauseTimeSpan *pts)
{
    pauseTimeSpans.append(pts);
    int minutes(jw78::Utils::minutesBetween(pts->pauseBegin(), pts->pauseEnd()));
    setPauseMinutesBrutto(pauseMinutesBrutto() + minutes);
    setPauseCount(pauseTimeSpans.size());
}

jw78::ProxyObject *WorkTimeSpan::getPause(int index)
{
    if ((index < 0) || (index >= pauseTimeSpans.size()))
    {
        return nullptr;
    }
    QQmlEngine::setObjectOwnership(pauseTimeSpans[index], QQmlEngine::CppOwnership);
    return pauseTimeSpans[index];
}
