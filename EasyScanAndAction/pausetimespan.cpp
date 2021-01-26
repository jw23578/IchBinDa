#include "pausetimespan.h"
#include "jw78utils.h"

void PauseTimeSpan::calculate()
{
    setMinutes(jw78::Utils::minutesBetween(pauseBegin(), pauseEnd()));
}

PauseTimeSpan::PauseTimeSpan()
{

}
