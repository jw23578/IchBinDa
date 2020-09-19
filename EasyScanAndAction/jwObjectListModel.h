#ifndef OBJECT_LIST_MODEL_H
#define OBJECT_LIST_MODEL_H

#include <QAbstractItemModel>
#include <vector>
#include "jwProxyObject.h"
#include <QQmlApplicationEngine>
#include <QDateTime>

namespace jw
{

class ObjectListModel: public QAbstractItemModel
{
    Q_OBJECT
private:
    JWPROPERTY(QDateTime, lastUpdate, LastUpdate, QDateTime())
    JWPROPERTY(int, count, Count, 0)
    static bool first;
    std::map<quint64, ProxyObject*> needle2Object;
    std::map<QString, ProxyObject*> stringNeedle2Object;
    std::vector<ProxyObject*> objects;

    void removeFromVisible(jw::ProxyObject *o);
protected:
    std::vector<ProxyObject*> visibleObjects;
    typedef  std::vector<ProxyObject*>::iterator objectsIterator;
    QString elementName;

    enum OLMRoles {
        ObjectRole = Qt::UserRole + 1
    };
    virtual QHash<int, QByteArray> customRoleNames() const;
    virtual QVariant customData(const QModelIndex &index, int role) const;
public:
    ObjectListModel(QQmlApplicationEngine &engine, QString qmlName, QString elemName);

    // QAbstractItemModel interface
public:
    QModelIndex index(int row, int column, const QModelIndex &parent) const override;
    QModelIndex parent(const QModelIndex &child) const override;
    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void clear();
    void add(ProxyObject *o);
    ProxyObject *removeLast();
    Q_INVOKABLE ProxyObject *at(int index);
    ProxyObject *last();
    ProxyObject *byUniqueID(quint64 needle);
    ProxyObject *byUniqueStringID(QString needle);
    size_t size();

    Q_INVOKABLE void search(QString needle);

    bool reverse;
};

}

#endif // OBJECT_LIST_MODEL_H
