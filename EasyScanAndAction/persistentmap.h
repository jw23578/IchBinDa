#ifndef PERSISTENTMAP_H
#define PERSISTENTMAP_H

#include <QString>
#include <map>

class PersistentMap
{
    QString filename;
    QString firstName;
    QString secondName;
    std::map<QString, QString> dataMap;
    void save();
    void load();
public:
    PersistentMap(QString const &filename,
                  QString const &firstName,
                  QString const &secondName);
    bool contains(const QString &index);
    QString get(const QString &index);
    void set(const QString &index, const QString &value);
    void setFiledata(const QString &index, const QString &filename);
};

#endif // PERSISTENTMAP_H
