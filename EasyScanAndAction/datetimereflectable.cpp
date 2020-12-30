#include "datetimereflectable.h"

DateTimeReflectable::DateTimeReflectable(bool genUuid):jw::pureReflection(genUuid, "DateTimeReflectable")
{
    ADD_VARIABLE(value);
    ADD_VARIABLE(name);
}

jw::pureReflection *DateTimeReflectable::create(bool genUuid) const
{
    return new DateTimeReflectable(genUuid);
}
