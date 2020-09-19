#include "jwObjectListModel.h"
#include <QQmlContext>

bool jw::ObjectListModel::first(true);

jw::ObjectListModel::ObjectListModel(QQmlApplicationEngine &engine, QString qmlName, QString elemName):
    QAbstractItemModel(&engine),
    elementName(elemName),
    reverse(false)
{
    if (first)
    {
        first = false;
        qmlRegisterType<ProxyObject>("gympool.proxyObject", 1, 0, "ProxyObject");
    }
    engine.rootContext()->setContextProperty(qmlName, QVariant::fromValue(this));
}

QModelIndex jw::ObjectListModel::index(int row, int column, const QModelIndex &parent) const
{
    return createIndex(row, column);
}

QModelIndex jw::ObjectListModel::parent(const QModelIndex &child) const
{
    return QModelIndex();
}

int jw::ObjectListModel::rowCount(const QModelIndex &parent) const
{
    return static_cast<int>(visibleObjects.size());
}

int jw::ObjectListModel::columnCount(const QModelIndex &parent) const
{
    return 1;
}

QVariant jw::ObjectListModel::data(const QModelIndex &index, int role) const
{
    if (role > ObjectRole)
    {
        return customData(index, role);
    }
    int r(reverse ? visibleObjects.size() - 1 - index.row() : index.row());
    if ((role != ObjectRole) || (r >= static_cast<int>(visibleObjects.size())) || (r < 0))
    {
        return QVariant();
    }
    return QVariant::fromValue<QObject *>(visibleObjects[static_cast<size_t>(r)]);
}

QHash<int, QByteArray> jw::ObjectListModel::customRoleNames() const
{
    QHash<int, QByteArray> empty;
    return empty;
}

QVariant jw::ObjectListModel::customData(const QModelIndex &index, int role) const
{
    return QVariant();
}

QHash<int, QByteArray> jw::ObjectListModel::roleNames() const
{
    QHash<int, QByteArray> roles(customRoleNames());
    roles[ObjectRole] = elementName.toLatin1();
    return roles;
}

void jw::ObjectListModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, objects.size() - 1);
    visibleObjects.clear();
    needle2Object.clear();
    stringNeedle2Object.clear();
    objectsIterator it(objects.begin());
    while (it != objects.end())
    {
        delete *it;
        ++it;
    }
    objects.clear();
    endRemoveRows();
    setCount(size());
}

void jw::ObjectListModel::add(jw::ProxyObject *o)
{
    if (reverse)
    {
        beginInsertRows(QModelIndex(), 0, 0);
    }
    else
    {
        beginInsertRows(QModelIndex(), visibleObjects.size(), visibleObjects.size());
    }
    visibleObjects.push_back(o);
    objects.push_back(o);
    endInsertRows();
    setCount(size());
}

jw::ProxyObject *jw::ObjectListModel::removeLast()
{
    if (!size())
    {
        return nullptr;
    }
    ProxyObject *ret(at(size() - 1));
    beginRemoveRows(QModelIndex(), size() - 1, size());
    visibleObjects.pop_back();
    objects.erase(std::find(objects.begin(), objects.end(), ret));
    endRemoveRows();
    setCount(size());
    return ret;
}

jw::ProxyObject *jw::ObjectListModel::at(int index)
{
    return visibleObjects[index];
}

jw::ProxyObject *jw::ObjectListModel::last()
{
    if (!size())
    {
        return nullptr;
    }
    return visibleObjects[size() - 1];
}

jw::ProxyObject *jw::ObjectListModel::byUniqueID(quint64 needle)
{
    if (needle2Object.find(needle) != needle2Object.end())
    {
        return needle2Object[needle];
    }
    objectsIterator it(objects.begin());
    while (it != objects.end())
    {
        if ((*it)->uniqueID() == needle)
        {
            needle2Object[needle] = *it;
            return *it;
        }
        ++it;
    }
    return nullptr;
}


jw::ProxyObject *jw::ObjectListModel::byUniqueStringID(QString needle)
{
    if (stringNeedle2Object.find(needle) != stringNeedle2Object.end())
    {
        return stringNeedle2Object[needle];
    }
    objectsIterator it(objects.begin());
    while (it != objects.end())
    {
        if ((*it)->uniqueStringID() == needle)
        {
            stringNeedle2Object[needle] = *it;
            return *it;
        }
        ++it;
    }
    return nullptr;
}


size_t jw::ObjectListModel::size()
{
    return visibleObjects.size();
}

void jw::ObjectListModel::removeFromVisible(jw::ProxyObject *o)
{
    for (size_t i(0); i < visibleObjects.size(); ++i)
    {
        if (visibleObjects[i] == o)
        {
            beginRemoveRows(QModelIndex(), i, i);
            visibleObjects.erase(visibleObjects.begin() + i);
            endRemoveRows();
        }
    }
}

void jw::ObjectListModel::search(QString needle)
{
    if (needle.size() == 0)
    {
        objectsIterator it(objects.begin());
        while (it != objects.end())
        {
            ProxyObject *o(*it);
            if (!o->searched())
            {
                o->setSearched(true);
                beginInsertRows(QModelIndex(), visibleObjects.size(), visibleObjects.size());
                visibleObjects.push_back(o);
                endInsertRows();
            }
            ++it;
        }
    }
    objectsIterator it(objects.begin());
    while (it != objects.end())
    {
        ProxyObject *o(*it);
        bool oldSearched(o->searched());
        if (oldSearched != o->search(needle))
        {
            if (!oldSearched)
            {
                beginInsertRows(QModelIndex(), visibleObjects.size(), visibleObjects.size());
                visibleObjects.push_back(o);
                endInsertRows();
            }
            else
            {
                removeFromVisible(o);
            }
        }
        ++it;
    }

}

