#include "helpoffer.h"

HelpOffer::HelpOffer(bool genUuid):jw78::ProxyObject(0), jw::pureReflection(true, "HelpOffer")
{
    ADD_VARIABLE(m_offererUuid);
    ADD_VARIABLE(m_caption);
    ADD_VARIABLE(m_descricption);
//    ADD_VARIABLE(m_longitude);
    //    ADD_VARIABLE(m_latitude);
}

jw::pureReflection *HelpOffer::create(bool genUuid) const
{
    return new HelpOffer(genUuid);
}