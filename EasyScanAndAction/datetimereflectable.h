#ifndef DATETIMEREFLECTABLE_H
#define DATETIMEREFLECTABLE_H

#include "persistent/jw78persistentobject.h"
#include <QDateTime>

class DateTimeReflectable: public jw78::PersistentObject
{
protected:
    pureReflection *internalCreate(bool genUuid) const override;
public:
    QString name;
    QDateTime value;
    DateTimeReflectable(bool genUuid);
};

#endif // DATETIMEREFLECTABLE_H
