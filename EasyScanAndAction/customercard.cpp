#include "customercard.h"

CustomerCard::CustomerCard(bool setUuid):jw78::ProxyObject(0), jw78::ReflectableObject(setUuid)
{
    ADD_VARIABLE(m_name);
    ADD_VARIABLE(m_filename);
}

CustomerCard *CustomerCard::create(bool setUuid) const
{
    return new CustomerCard(setUuid);
}
