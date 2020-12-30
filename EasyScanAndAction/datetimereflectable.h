#ifndef DATETIMEREFLECTABLE_H
#define DATETIMEREFLECTABLE_H

#include "JW78QTLib/reflection/jw_purereflection.h"
#include <QDateTime>

class DateTimeReflectable: public jw::pureReflection
{
public:
    QString name;
    QDateTime value;
    DateTimeReflectable(bool genUuid);

    pureReflection *create(bool genUuid) const;
};

#endif // DATETIMEREFLECTABLE_H
