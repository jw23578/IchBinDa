#include "worktimespan.h"
#include "JW78QTLib/jw78utils.h"

WorkTimeSpan::WorkTimeSpan()
{

}

void WorkTimeSpan::addPause(PauseTimeSpan *pts)
{
    pauseTimeSpans.append(pts);
    int minutes(jw78::Utils::minutesBetween(pts->pauseBegin(), pts->pauseEnd()));
    setPauseMinutesBrutto(pauseMinutesBrutto() + minutes);
}
