#include "helpoffer.h"

HelpOffer::HelpOffer(bool genUuid):
    jw78::ProxyObject(0),
    jw78::PersistentObject(true, "HelpOffer"),
    transferred(false)
{
    ADD_VARIABLE(m_offererUuid);
    ADD_VARIABLE(m_caption);
    ADD_VARIABLE(m_description);
    ADD_VARIABLE(m_longitude);
    ADD_VARIABLE(m_latitude);
    ADD_VARIABLE(transferred);
}

jw::pureReflection *HelpOffer::internalCreate(bool genUuid) const
{
    return new HelpOffer(genUuid);
}
