#ifndef DAYTIMESPANMODEL_H
#define DAYTIMESPANMODEL_H

#include "daytimespan.h"
#include "dataModel/jw78ObjectListModel.h"

class DayTimeSpanModel: public jw78::ObjectListModel
{
    Q_OBJECT
public:
    DayTimeSpanModel(QQmlApplicationEngine &engine,
                     QString const &qmlName);

    Q_INVOKABLE void addDayTimeSpan(QDate const &day,
                                    QTime const &since,
                                    QTime const &until);
};

#endif // DAYTIMESPANMODEL_H
