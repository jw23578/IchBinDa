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
};

#endif // PERSISTENTMAP_H
