#include "pausetimespan.h"
#include "JW78QTLib/jw78utils.h"

void PauseTimeSpan::calculate()
{
    setMinutes(jw78::Utils::minutesBetween(pauseBegin(), pauseEnd()));
}

PauseTimeSpan::PauseTimeSpan()
{

}
