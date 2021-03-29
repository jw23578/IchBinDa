#include "daytimespanmodel.h"

bool DayTimeSpanModel::first(true);

DayTimeSpanModel::DayTimeSpanModel():
    jw78::ObjectListModel("DTS")
{
    standardSinceUntil[QTime(8, 0, 0, 0)] = QTime(11, 0, 0, 0);
    standardSinceUntil[QTime(11, 0, 0, 0)] = QTime(14, 0, 0, 0);
    standardSinceUntil[QTime(14, 0, 0, 0)] = QTime(17, 0, 0, 0);
    standardSinceUntil[QTime(17, 0, 0, 0)] = QTime(21, 0, 0, 0);
    if (first)
    {
        qmlRegisterType<DayTimeSpanModel>("jw78.DayTimeSpanModel", 1, 0, "DayTimeSpanModel");
    }
}

DayTimeSpanModel::DayTimeSpanModel(QQmlApplicationEngine &engine,
                                   const QString &qmlName):
    jw78::ObjectListModel(engine, qmlName, "DTS")
{
    standardSinceUntil[QTime(8, 0, 0, 0)] = QTime(11, 0, 0, 0);
    standardSinceUntil[QTime(11, 0, 0, 0)] = QTime(14, 0, 0, 0);
    standardSinceUntil[QTime(14, 0, 0, 0)] = QTime(17, 0, 0, 0);
    standardSinceUntil[QTime(17, 0, 0, 0)] = QTime(21, 0, 0, 0);
    if (first)
    {
        qmlRegisterType<DayTimeSpanModel>("jw78.DayTimeSpanModel", 1, 0, "DayTimeSpanModel");
    }
}

void DayTimeSpanModel::addDayTimeSpan(const QDate &day, const QTime &since, const QTime &until)
{
    DayTimeSpan *dTS(new DayTimeSpan);
    dTS->setDay(day);
    dTS->setSince(since);
    dTS->setUntil(until);
    add(dTS);
}

void DayTimeSpanModel::removeDayTimeSpan(const QDate &day,
                                         const QTime &since,
                                         const QTime &until)
{
    for (size_t i(0); i < size(); ++i)
    {
        DayTimeSpan *dts(dynamic_cast<DayTimeSpan*>(at(i)));
        if (dts->day() == day && dts->since() == since && dts->until() == until)
        {
            erase(i);
            return;
        }
    }
}

void DayTimeSpanModel::removeDoubleDayTimeSpans()
{
    QVector<int> indexeToErase;
    for (size_t a(0); a < size(); ++a)
    {
        DayTimeSpan *dtsA(dynamic_cast<DayTimeSpan*>(at(a)));
        for (size_t b(a + 1); b < size(); ++b)
        {
            DayTimeSpan *dtsB(dynamic_cast<DayTimeSpan*>(at(b)));

            if (*dtsA == *dtsB)
            {
                indexeToErase.push_back(b);
            }
        }
    }
    eraseMany(indexeToErase);
}

void DayTimeSpanModel::removeSpecialDayTimeSpans()
{
    QVector<int> indexeToErase;
    for (size_t i(0); i < size(); ++i)
    {
        DayTimeSpan *dts(dynamic_cast<DayTimeSpan*>(at(i)));
        auto it(standardSinceUntil.find(dts->since()));
        if (it == standardSinceUntil.end())
        {
            indexeToErase.push_back(i);
        }
        else
        {
            if (it.value() != dts->until())
            {
                indexeToErase.push_back(i);
            }
        }
    }
    eraseMany(indexeToErase);
}

bool DayTimeSpanModel::hasSpecialDayTimeSpans()
{
    for (size_t i(0); i < size(); ++i)
    {
        DayTimeSpan *dts(dynamic_cast<DayTimeSpan*>(at(i)));
        auto it(standardSinceUntil.find(dts->since()));
        if (it == standardSinceUntil.end())
        {
            return true;
        }
        if (it.value() != dts->until())
        {
            return true;
        }
    }
    return false;
}

bool DayTimeSpanModel::contains(const QDate &day,
                                const QTime &since,
                                const QTime &until,
                                const int QMLTriggerDummy)
{
    Q_UNUSED(QMLTriggerDummy);
    for (size_t i(0); i < size(); ++i)
    {
        DayTimeSpan *dts(dynamic_cast<DayTimeSpan*>(at(i)));
        if (dts->day() == day && dts->since() == since && dts->until() == until)
        {
            return true;
        }
    }
    return false;
}

DayTimeSpan *DayTimeSpanModel::dtsAt(int index)
{
    return dynamic_cast<DayTimeSpan*>(at(index));
}
