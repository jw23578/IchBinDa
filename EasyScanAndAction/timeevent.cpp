#include "timeevent.h"

TimeEvent::TimeEvent(bool genUuid):jw78::ProxyObject(0), jw::pureReflection(genUuid, "TimeEvent")
{
    ADD_VARIABLE(m_eventType);
    ADD_VARIABLE(m_timeStamp);
    ADD_VARIABLE(transferedToServer);
}

jw::pureReflection *TimeEvent::create(bool genUuid) const
{
    return new TimeEvent(genUuid);
}

QString TimeEvent::type2String()
{
    switch (eventType())
    {
    case 0: return "Dienstbeginn";
    case 1: return "Dienstende";
    case 2: return "Pausebeginn";
    case 3: return "Pauseende";
    case 4: return "Dienstgangbeginn";
    case 5: return "Dienstgangende";
    }
    return "";
}
