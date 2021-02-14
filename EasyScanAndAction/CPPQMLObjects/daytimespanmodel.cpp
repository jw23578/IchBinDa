#include "daytimespanmodel.h"

DayTimeSpanModel::DayTimeSpanModel(QQmlApplicationEngine &engine,
                                   const QString &qmlName):
    jw78::ObjectListModel(engine, qmlName, "DTS")
{

}

void DayTimeSpanModel::addDayTimeSpan(const QDate &day, const QTime &since, const QTime &until)
{
    DayTimeSpan *dTS(new DayTimeSpan);
    dTS->setDay(day);
    dTS->setSince(since);
    dTS->setUntil(until);
    add(dTS);
}
