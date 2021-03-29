#ifndef DAYTIMESPANMODEL_H
#define DAYTIMESPANMODEL_H

#include "daytimespan.h"
#include "dataModel/jw78ObjectListModel.h"

class DayTimeSpanModel: public jw78::ObjectListModel
{
    Q_OBJECT
    QMap<QTime, QTime> standardSinceUntil;
    static bool first;
public:
    DayTimeSpanModel();
    DayTimeSpanModel(QQmlApplicationEngine &engine,
                     QString const &qmlName);

    Q_INVOKABLE void addDayTimeSpan(QDate const &day,
                                    QTime const &since,
                                    QTime const &until);
    Q_INVOKABLE void removeDayTimeSpan(QDate const &day,
                                       QTime const &since,
                                       QTime const &until);

    Q_INVOKABLE void removeDoubleDayTimeSpans();
    Q_INVOKABLE void removeSpecialDayTimeSpans();
    Q_INVOKABLE bool hasSpecialDayTimeSpans();
    Q_INVOKABLE bool contains(QDate const &day,
                              QTime const &since,
                              QTime const &until,
                              const int QMLTriggerDummy);
    DayTimeSpan *dtsAt(int index);
};

#endif // DAYTIMESPANMODEL_H
