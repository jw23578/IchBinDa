#include "helpoffermanager.h"
#include <QQmlContext>

HelpOfferManager::HelpOfferManager(QQmlApplicationEngine &e,
                                   jw78::PersistentAdapterSqlite &database,
                                   jw78::PersistentAdapterJWServer &serverAdapter):
    QObject(nullptr),
    database(database),
    serverAdapter(serverAdapter),
    myHelpOffers(e, "MyHelpOffers", "HelpOffer")
{
    e.rootContext()->setContextProperty("HelpOfferManager", QVariant::fromValue(this));
    QVector<jw78::PersistentObject*> temp;
    std::unique_ptr<HelpOffer> templateHelpOffer(new HelpOffer(false));
    database.createTableCollectionOrFileIfNeeded("HelpOffer", *templateHelpOffer);
    database.selectAll("HelpOffer", temp, *templateHelpOffer);
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
    serverAdapter.setComm("127.0.0.1", 23578, secToken);
    serverAdapter.setLoginTokenString(loginTokenString);
    for (int i(0); i < myHelpOffers.size(); ++i)
    {
        HelpOffer *ho(dynamic_cast<HelpOffer*>(myHelpOffers.at(i)));
        if (ho && !ho->getStored())
        {
            serverAdapter.insert(ho->get_entity_name(),
                                 *ho);
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
    database.insert(ho->get_entity_name(),
                    *ho);
    ho->setUnStored();
}

void HelpOfferManager::deleteHelpOfferByIndex(int index)
{
    qDebug() <<  __PRETTY_FUNCTION__ << index;
    HelpOffer *ho(dynamic_cast<HelpOffer*>(myHelpOffers.at(index)));
    database.erase("HelpOffer", *ho);
    serverAdapter.erase(ho->get_entity_name(), *ho);
    myHelpOffers.erase(index);

}
