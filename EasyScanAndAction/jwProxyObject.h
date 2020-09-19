#ifndef PROXY_OBJECT_H
#define PROXY_OBJECT_H

#include <QObject>
#include "qtcoremacros78.h"

namespace jw
{

class ProxyObject: public QObject
{
    Q_OBJECT
    JWPROPERTY(quint64, uniqueID, UniqueID, 0);
    JWPROPERTY(QString, uniqueStringID, UniqueStringID, "");
    JWPROPERTY(bool, searched, Searched, true);
protected:
    virtual bool internalSearch(QString needle) {return true;}
    virtual void internalSetValue(const QString &valueName, const QString &value) {}
    virtual QString internalGetValue(const QString &valueName) {return "";}
    public:
        ProxyObject(QObject *parent = nullptr);
    bool search(QString needle);
    Q_INVOKABLE void setValue(const QString &valueName, const QString &value);
    Q_INVOKABLE QString getValue(const QString &valueName);
};

}

#endif // PROXY_OBJECT_H
