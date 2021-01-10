#include "helpoffermanager.h"
#include <QQmlContext>

HelpOfferManager::HelpOfferManager(QQmlApplicationEngine &e,
                                   const QString &databaseFilename,
                                   QNetworkAccessManager &networkAccessManager):
    QObject(nullptr),
    databaseStore(databaseFilename, "HelpOffer", *new HelpOffer(false)),
    serverStore(networkAccessManager, "", 0, "", "HelpOffer", factory),
    myHelpOffers(e, "MyHelpOffers", "HelpOffer")
{
    connect(&serverStore, &jw78::PersistentStoreJWServer::objectStored, this, &HelpOfferManager::onHelpOfferStored);
    connect(&serverStore, &jw78::PersistentStoreJWServer::objectNotStored, this, &HelpOfferManager::onHelpOfferNotStored);

    factory.addClass(new HelpOffer(false));
    e.rootContext()->setContextProperty("HelpOfferManager", QVariant::fromValue(this));
    QVector<jw78::PersistentObject*> temp;
    databaseStore.selectAll(temp);
    for (auto e: temp)
    {
        HelpOffer *ho(dynamic_cast<HelpOffer*>(e));
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
        if (ho && !ho->getStored())
        {
            serverStore.store(*ho);
        }
    }
}

void HelpOfferManager::saveHelpOffer(QString caption,
                                     QString description,
                                     double longitude,
                                     double latitude)
{
    HelpOffer *ho(new HelpOffer(true));
    ho->setCaption(caption);
    ho->setDescription(description);
    ho->setLatitude(latitude);
    ho->setLongitute(longitude);
    myHelpOffers.add(ho);
    databaseStore.store(*ho);
    ho->setUnStored();
}

void HelpOfferManager::deleteHelpOfferByIndex(int index)
{
    qDebug() <<  __PRETTY_FUNCTION__ << index;
    HelpOffer *ho(dynamic_cast<HelpOffer*>(myHelpOffers.at(index)));
    databaseStore.deleteOne(ho->getUuid());
    // FIX ME
    // das funktioniert bisher, weil die daten beim Store gesetzt werden, aber das passiert ja nicht immer sicher vorher
//    serverStore.setComm("127.0.0.1", 23578, secToken);
//    serverStore.setLoginTokenString(loginTokenString);
    serverStore.deleteOne(ho->getUuid());
    myHelpOffers.erase(index);

}

void HelpOfferManager::onHelpOfferStored(const jw78::PersistentObject &object)
{
    qDebug() << "helpoffer stored";

}

void HelpOfferManager::onHelpOfferNotStored(const jw78::PersistentObject &object)
{
    qDebug() << "helpoffer not stored";
}
