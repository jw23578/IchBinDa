#include "helpoffermanager.h"
#include <QQmlContext>

HelpOfferManager::HelpOfferManager(QQmlApplicationEngine &e,
                                   const QString &databaseFilename,
                                   QNetworkAccessManager &networkAccessManager):
    QObject(nullptr),
    helpOfferDatabaseStore(databaseFilename, "HelpOffer", *new HelpOffer(false)),
    dayTimeSpanDatabaseStore(databaseFilename, "DayTimeSpan", *new DayTimeSpan),
    serverStore(networkAccessManager, "", 0, "", "HelpOffer", factory),
    myHelpOffers(e, "MyHelpOffers", "HelpOffer"),
    dayTimeSpanModel(e, "DayTimeSpanModel"),
    removedTimeSpanModel(e, "RemovedDayTimeSpanModel")
{
    connect(&serverStore, &jw78::PersistentStoreJWServer::objectStored, this, &HelpOfferManager::onHelpOfferStored);
    connect(&serverStore, &jw78::PersistentStoreJWServer::objectNotStored, this, &HelpOfferManager::onHelpOfferNotStored);

    factory.addClass(new HelpOffer(false));
    factory.addClass(new DayTimeSpan);
    e.rootContext()->setContextProperty("HelpOfferManager", QVariant::fromValue(this));
    e.rootContext()->setContextProperty("TheCurrentHelpOffer", QVariant::fromValue(&theCurrentHelpOffer));
    QVector<jw78::PersistentObject*> temp;
    helpOfferDatabaseStore.selectAll(temp);
    for (auto &e: temp)
    {
        HelpOffer *ho(dynamic_cast<HelpOffer*>(e));
        QVector<jw78::PersistentObject*> dayTimeSpans;
        dayTimeSpanDatabaseStore.selectAll("helpOfferUuid", ho->getUuid(), dayTimeSpans);
        for (auto &preDTS: dayTimeSpans)
        {
            DayTimeSpan *dts(dynamic_cast<DayTimeSpan*>(preDTS));
            ho->addDayTimeSpan(dts);
        }
        myHelpOffers.add(ho);
    }
}


void HelpOfferManager::storeHelpOffer(bool loggedIn,
                                      const QString &loginTokenString,
                                      const QString &secToken)
{
    if (!loggedIn)
    {
        return;
    }
    serverStore.setComm("127.0.0.1", 23578, secToken);
    serverStore.setLoginTokenString(loginTokenString);
    for (int i(0); i < myHelpOffers.size(); ++i)
    {
        HelpOffer *ho(dynamic_cast<HelpOffer*>(myHelpOffers.at(i)));
        if (ho && !ho->getStored() && !ho->transferred)
        {
            serverStore.store(*ho);
        }
    }
}

void HelpOfferManager::saveNewHelpOffer()
{
    HelpOffer *ho(new HelpOffer(theCurrentHelpOffer));
    myHelpOffers.add(ho);
    helpOfferDatabaseStore.store(*ho);
    ho->setUnStored();
    for (size_t i(0); i < dayTimeSpanModel.size(); ++i)
    {

        DayTimeSpan *dts(new DayTimeSpan(*dayTimeSpanModel.dtsAt(i)));
        dts->helpOfferUuid = ho->getUuid();
        ho->addDayTimeSpan(dts);
        dayTimeSpanDatabaseStore.store(*dts);
        dts->setUnStored();
    }
}

void HelpOfferManager::deleteHelpOfferByIndex(int index)
{
    qDebug() <<  __PRETTY_FUNCTION__ << index;
    HelpOffer *ho(dynamic_cast<HelpOffer*>(myHelpOffers.at(index)));
    helpOfferDatabaseStore.deleteOne(ho->getUuid());
    // FIX ME
    // das funktioniert bisher, weil die daten beim Store gesetzt werden, aber das passiert ja nicht immer sicher vorher
//    serverStore.setComm("127.0.0.1", 23578, secToken);
//    serverStore.setLoginTokenString(loginTokenString);
    serverStore.deleteOne(ho->getUuid());
    myHelpOffers.erase(index);

}

void HelpOfferManager::onHelpOfferStored(jw78::PersistentObject &object)
{
    qDebug() << "helpoffer stored";
    HelpOffer *ho(dynamic_cast<HelpOffer*>(&object));
    ho->transferred = true;
    helpOfferDatabaseStore.update(*ho);
}

void HelpOfferManager::onHelpOfferNotStored(const jw78::PersistentObject &object)
{
    qDebug() << "helpoffer not stored";
}
