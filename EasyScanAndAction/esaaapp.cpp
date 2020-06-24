#include "esaaapp.h"
#include <QQmlContext>

ESAAApp::ESAAApp(QQmlApplicationEngine &e):QObject(&e)
{
    e.rootContext()->setContextProperty("ESAA", QVariant::fromValue(this));
}

void ESAAApp::showMessage(const QString &mt)
{
    emit showMessageSignal(mt);
}
