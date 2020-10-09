#include "timemaster.h"
#include <QQmlContext>
#include "esaaapp.h"

void TimeMaster::savedata()
{
    qDebug() << "hello";
}

TimeMaster::TimeMaster(QQmlApplicationEngine &engine,  ESAAApp &app, QObject *parent) : QObject(parent),
    theApp(app)
{
    engine.rootContext()->setContextProperty("TimeMaster", QVariant::fromValue(this));
}
