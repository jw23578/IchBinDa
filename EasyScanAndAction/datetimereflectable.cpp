#include "datetimereflectable.h"

DateTimeReflectable::DateTimeReflectable(bool genUuid):jw78::PersistentObject(genUuid, "DateTimeReflectable")
{
    ADD_VARIABLE(value);
    ADD_VARIABLE(name);
}

jw::pureReflection *DateTimeReflectable::internalCreate(bool genUuid) const
{
    return new DateTimeReflectable(genUuid);
}
