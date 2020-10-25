#include "placesmanager.h"

#include <QQmlContext>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "place.h"

PlacesManager::PlacesManager(QQmlApplicationEngine &engine): QObject(&engine),
    places(engine, "Places", "place")
{
    engine.rootContext()->setContextProperty("PlacesManager", QVariant::fromValue(this));
    QObject::connect(&network, &QNetworkAccessManager::finished,
                     this, &PlacesManager::handleReplyFinished);
}

void PlacesManager::update()
{
    QByteArray xmlRequest("<osm-script output=\"json\">"
            "<query type=\"nwr\">"
              "<has-kv k=\"name\"/>"
              "<has-kv k=\"highway\" modv=\"not\" regv=\".\"/>"
            "<around lat=\"53.140920\" lon=\"8.212130\" radius=\"50\"/>"
            "</query>"
            "<print/>"
          "</osm-script>");
    QString url("https://overpass-api.de/api/interpreter");
    network.post(QNetworkRequest(url), xmlRequest);
}

void PlacesManager::handleReplyFinished(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError)
    {
        update();
        return;
    }
    QByteArray data(reply->readAll());
    QJsonDocument json(QJsonDocument::fromJson(data));
    if (json.isNull())
    {
        setIsNull(true);
        return;
    }
    setIsNull(false);
    if (json.isEmpty())
    {
        setIsEmpty(true);
        return;
    }
    setIsEmpty(false);
    QJsonObject overpass(json.object());
    QJsonArray elements(overpass["elements"].toArray());
    if (elements.size() == 0)
    {
        setNoElements(true);
        return;
    }
    setNoElements(false);
    for (int i(0); i < elements.size(); ++i)
    {
        QJsonObject obj(elements[i].toObject());
        QJsonObject tags(obj["tags"].toObject());
        Place *p(new Place);
        p->setName(tags["name"].toString());
        QString street(tags["addr:street"].toString());
        QString housenumber(tags["addr:housenumber"].toString());
        p->setAdress(street + " " + housenumber);
        places.add(p);
        qDebug() << "name: " << tags["name"].toString();
        qDebug() << "address: " << p->adress();
    }
}
