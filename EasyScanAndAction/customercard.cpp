#include "customercard.h"

CustomerCard::CustomerCard(bool genUuid):jw78::ProxyObject(0), jw78::PersistentObject(genUuid, "CustomerCard")
{
    ADD_VARIABLE(m_name);
    ADD_VARIABLE(m_filename);
}

jw::pureReflection *CustomerCard::internalCreate(bool genUuid) const
{
    return new CustomerCard(genUuid);
}
