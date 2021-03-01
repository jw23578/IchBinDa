#ifndef DAYTIMESPANMODEL_H
#define DAYTIMESPANMODEL_H

#include "daytimespan.h"
#include "dataModel/jw78ObjectListModel.h"

class DayTimeSpanModel: public jw78::ObjectListModel
{
    Q_OBJECT
    QMap<QTime, QTime> standardSinceUntil;
public:
    DayTimeSpanModel(QQmlApplicationEngine &engine,
                     QString const &qmlName);

    Q_INVOKABLE void addDayTimeSpan(QDate const &day,
                                    QTime const &since,
                                    QTime const &until);
    Q_INVOKABLE void removeDayTimeSpan(QDate const &day,
                                       QTime const &since,
                                       QTime const &until);

    Q_INVOKABLE void removeSpecialDayTimes();
    Q_INVOKABLE bool hasSpecialDayTimes();
    Q_INVOKABLE bool contains(QDate const &day,
                              QTime const &since,
                              QTime const &until,
                              const int QMLTriggerDummy);
};

#endif // DAYTIMESPANMODEL_H
