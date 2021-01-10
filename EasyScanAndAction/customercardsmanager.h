#ifndef CUSTOMERCARDSMANAGER_H
#define CUSTOMERCARDSMANAGER_H

#include <QQmlApplicationEngine>
#include "persistent/jw78persistentstoresqlite.h"
#include "customercard.h"
#include "jw78ObjectListModel.h"

class ESAAApp;

class CustomerCardsManager: public QObject
{
    Q_OBJECT
    ESAAApp &theApp;
    jw78::PersistentStoreSQLite customerCardsDatabase;
    jw78::ObjectListModel allCustomerCards;
public:
    CustomerCardsManager(QQmlApplicationEngine &engine,
                         ESAAApp &app,
                         const QString &databaseFilename);

    Q_INVOKABLE void deleteAllCustomerCards();
    Q_INVOKABLE void deleteCustomerCardByIndex(int index);
    Q_INVOKABLE void saveCustomerCard(const QString &name, const QString &filename);

};

#endif // CUSTOMERCARDSMANAGER_H
