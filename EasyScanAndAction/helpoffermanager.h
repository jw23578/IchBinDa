#ifndef HELPOFFERMANAGER_H
#define HELPOFFERMANAGER_H

#include "helpoffer.h"
#include "dataModel/jw78ObjectListModel.h"
#include <QNetworkAccessManager>
#include <QQmlApplicationEngine>
#include "persistent/jw78persistentstorejwserver.h"
#include "persistent/jw78persistentstoresqlite.h"
#include "CPPQMLObjects/daytimespanmodel.h"


class HelpOfferManager: public QObject
{
    Q_OBJECT
    jw78::ReflectionFactory factory;
    jw78::PersistentStoreSQLite helpOfferDatabaseStore;
    jw78::PersistentStoreSQLite dayTimeSpanDatabaseStore;
    jw78::PersistentStoreJWServer serverStore;
    jw78::ObjectListModel myHelpOffers;
    HelpOffer theCurrentHelpOffer;
    DayTimeSpanModel dayTimeSpanModel;
    DayTimeSpanModel removedTimeSpanModel;

public:
    HelpOfferManager(QQmlApplicationEngine &e,
                     const QString &databaseFilename,
                     QNetworkAccessManager &networkAccessManager);
    void storeHelpOffer(bool loggedIn,
                        const QString &loginTokenString,
                        const QString &secToken);

    Q_INVOKABLE void saveNewHelpOffer();
    Q_INVOKABLE void deleteHelpOfferByIndex(int index);

public slots:
    void onHelpOfferStored(jw78::PersistentObject &object);
    void onHelpOfferNotStored(const jw78::PersistentObject &object);

};

#endif // HELPOFFERMANAGER_H
