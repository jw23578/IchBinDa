#include "helpoffer.h"

void HelpOffer::addVariables()
{
    ADD_VARIABLE(m_offererUuid);
    ADD_VARIABLE(m_caption);
    ADD_VARIABLE(m_description);
    ADD_VARIABLE(transferred);
    ADD_VARIABLE(center);
    ADD_VARIABLE(offerTypes);
}


HelpOffer::HelpOffer():
    jw78::ProxyObject(0),
    jw78::PersistentObject(true, "HelpOffer"),
    transferred(false)
{
    addVariables();
}

HelpOffer::HelpOffer(bool genUuid):
    jw78::ProxyObject(0),
    jw78::PersistentObject(true, "HelpOffer"),
    transferred(false)
{
    addVariables();
}

HelpOffer::HelpOffer(const HelpOffer &other):
    jw78::ProxyObject(0),
    jw78::PersistentObject(true, "HelpOffer"),
    transferred(other.transferred)
{
    addVariables();
    m_offererUuid = other.m_offererUuid;
    m_caption = other.m_caption;
    m_description = other.m_description;
    center = other.center;
    offerTypes = other.offerTypes;
}

void HelpOffer::clearOfferTypes()
{
    offerTypes.clear();
}

void HelpOffer::addOfferType(const QString &type)
{
    offerTypes.insert(type);
}

void HelpOffer::setCenter(double latitude, double longitude)
{
    center.setLatitude(latitude);
    center.setLongitude(longitude);
}

jw::pureReflection *HelpOffer::internalCreate(bool genUuid) const
{
    return new HelpOffer(genUuid);
}

