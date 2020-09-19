#include "jwProxyObject.h"

jw::ProxyObject::ProxyObject(QObject *parent):QObject(parent)
{

}

bool jw::ProxyObject::search(QString needle)
{
    return internalSearch(needle);
}

void jw::ProxyObject::setValue(const QString &valueName, const QString &value)
{
    internalSetValue(valueName, value);
}

QString jw::ProxyObject::getValue(const QString &valueName)
{
    return internalGetValue(valueName);
}
