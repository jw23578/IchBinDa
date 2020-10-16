#ifndef DATETIMEREFLECTABLE_H
#define DATETIMEREFLECTABLE_H

#include "JW78QTLib/jw78reflectableobject.h"
#include <QDateTime>

class DateTimeReflectable: public jw78::ReflectableObject
{
public:
    QString name;
    QDateTime value;
    DateTimeReflectable(bool setUuid);

    ReflectableObject *create(bool setUuid) const;
};

#endif // DATETIMEREFLECTABLE_H
