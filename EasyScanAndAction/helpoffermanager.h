#ifndef HELPOFFERMANAGER_H
#define HELPOFFERMANAGER_H

#include "JW78QTLib/persistent/jw78persistentadaptersqlite.h"
#include "JW78QTLib/persistent/jw78persistentadapterjwserver.h"
#include "helpoffer.h"
#include "JW78QTLib/jw78ObjectListModel.h"
#include <QNetworkAccessManager>
#include <QQmlApplicationEngine>


class HelpOfferManager: public QObject
{
    Q_OBJECT
    jw78::PersistentAdapterSqlite &database;
    jw78::PersistentAdapterJWServer &serverAdapter;
    jw78::ObjectListModel myHelpOffers;
public:
    HelpOfferManager(QQmlApplicationEngine &e,
                     jw78::PersistentAdapterSqlite &database,
                     jw78::PersistentAdapterJWServer &serverAdapter);
    void storeHelpOffer(bool loggedIn,
                        const QString &loginTokenString,
                        const QString &secToken);

    Q_INVOKABLE void saveHelpOffer(QString caption,
                                   QString description,
                                   double longitude,
                                   double latitude);
    Q_INVOKABLE void deleteHelpOfferByIndex(int index);

};

#endif // HELPOFFERMANAGER_H
