#include "datetimereflectable.h"

DateTimeReflectable::DateTimeReflectable(bool setUuid):jw78::ReflectableObject(setUuid)
{
    ADD_VARIABLE(value)
            ADD_VARIABLE(name)
}

jw78::ReflectableObject *DateTimeReflectable::create(bool setUuid) const
{
    return new DateTimeReflectable(setUuid);
}
