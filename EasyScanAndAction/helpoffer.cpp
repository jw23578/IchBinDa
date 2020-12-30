#include "helpoffer.h"

HelpOffer::HelpOffer():jw78::ProxyObject(0), jw78::ReflectableObject(true)
{
    ADD_VARIABLE(m_offererUuid);
    ADD_VARIABLE(m_caption);
    ADD_VARIABLE(m_descricption);
//    ADD_VARIABLE(m_longitude);
//    ADD_VARIABLE(m_latitude);
}
