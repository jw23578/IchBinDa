#include "visit.h"

Visit::Visit():jw78::ProxyObject(nullptr)
{

}

void Visit::operator=(const Visit &other)
{
    setBegin(other.begin());
    setLogoUrl(other.logoUrl());
    setFacilityName(other.facilityName());
}
