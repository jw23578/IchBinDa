#include "daytimespan.h"

DayTimeSpan::DayTimeSpan()
{

}

QString DayTimeSpan::getDay(QDate dummy)
{
    if (day().isNull())
    {
        return "Wochentag";
    }
    return day().toString("dddd");
}

QString DayTimeSpan::getSince(QTime dummy)
{
    if (since().isNull())
    {
        return "Von";
    }
    return since().toString("hh:mm");
}

QString DayTimeSpan::getUntil(QTime dummy)
{
    if (until().isNull())
    {
        return "Von";
    }
    return until().toString("hh:mm");
}

bool DayTimeSpan::operator==(const DayTimeSpan &other)
{
    return day() == other.day() && since() == other.since() && until() == other.until();
}
