#include "customercardsmanager.h"
#include <QQmlContext>
#include "esaaapp.h"
#include <QDir>

CustomerCardsManager::CustomerCardsManager(QQmlApplicationEngine &engine,
                                           ESAAApp &app,
                                           const QString &databaseFilename):
    theApp(app),
    customerCardsDatabase(databaseFilename, "CustomerCards", *new CustomerCard(false)),
    allCustomerCards(engine, "AllCustomerCards", "Card")
{
    engine.rootContext()->setContextProperty("CustomerCardsManager", QVariant::fromValue(this));
    QVector<jw78::PersistentObject*> temp;
    customerCardsDatabase.selectAll(temp);
    for (auto e: temp)
    {
        CustomerCard *cc(dynamic_cast<CustomerCard*>(e));
        allCustomerCards.add(cc);
    }

}

void CustomerCardsManager::deleteAllCustomerCards()
{
    QDir dir;
    for (size_t i(0); i < allCustomerCards.size(); ++i)
    {
        CustomerCard *cc(dynamic_cast<CustomerCard*>(allCustomerCards.at(i)));
        dir.remove(cc->filename());
    }
    allCustomerCards.clear();
    customerCardsDatabase.clear();
}

void CustomerCardsManager::deleteCustomerCardByIndex(int index)
{
    qDebug() <<  __PRETTY_FUNCTION__ << index;
    QDir dir;
    CustomerCard *cc(dynamic_cast<CustomerCard*>(allCustomerCards.at(index)));
    customerCardsDatabase.deleteOne(cc->getUuid());
    dir.remove(cc->filename());
    allCustomerCards.erase(index);
}


void CustomerCardsManager::saveCustomerCard(const QString &name, const QString &filename)
{
    QString customerCardsDir(jw78::Utils::getWriteablePath() + "/customerCards");
    QDir dir;
    if (!dir.exists(customerCardsDir))
    {
        dir.mkdir(customerCardsDir);
    }
    QString customerCardImageFilename(customerCardsDir + "/" + jw78::Utils::genUUID() + ".jpg");
    QString work(filename);
    work.replace("file:", "");
    dir.rename(work, customerCardImageFilename);
    CustomerCard *cc(new CustomerCard(true));
    cc->setFilename(customerCardImageFilename);
    cc->setName(name);
    customerCardsDatabase.insert(*cc);
    allCustomerCards.add(cc);
}
