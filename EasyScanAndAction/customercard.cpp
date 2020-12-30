#include "customercard.h"

CustomerCard::CustomerCard(bool genUuid):jw78::ProxyObject(0), jw::pureReflection(genUuid, "CustomerCard")
{
    ADD_VARIABLE(m_name);
    ADD_VARIABLE(m_filename);
}

CustomerCard *CustomerCard::create(bool genUuid) const
{
    return new CustomerCard(genUuid);
}
