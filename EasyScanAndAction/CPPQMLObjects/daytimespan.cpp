#include "daytimespan.h"

void DayTimeSpan::addVariables()
{
    ADD_VARIABLE(m_day);
    ADD_VARIABLE(m_since);
    ADD_VARIABLE(m_until);
    ADD_VARIABLE(helpOfferUuid);
}

DayTimeSpan::DayTimeSpan():jw78::ProxyObject(),
    jw78::PersistentObject(true, "DayTimeSpan")
{
    addVariables();
}

DayTimeSpan::DayTimeSpan(const DayTimeSpan &other):
    jw78::ProxyObject(other),
    jw78::PersistentObject(other)
{
    addVariables();
    setDay(other.day());
    setSince(other.since());
    setUntil(other.until());
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

jw::pureReflection *DayTimeSpan::internalCreate(bool genUuid) const
{
    return new DayTimeSpan;
}
