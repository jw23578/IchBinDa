#include "placesmanager.h"

#include <QQmlContext>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "place.h"
#include "JW78QTLib/jw78utils.h"
#include "qthelper.h"

PlacesManager::PlacesManager(QQmlApplicationEngine &engine): QObject(&engine),
    source(nullptr),
    places(engine, "Places", "place")
{
    engine.rootContext()->setContextProperty("PlacesManager", QVariant::fromValue(this));
    QObject::connect(&network, &QNetworkAccessManager::finished,
                     this, &PlacesManager::handleReplyFinished);
}

void PlacesManager::update()
{
    jw78::Utils::log(__FILE__, __LINE__, "update");
    setWaitingForPlaces(true);
    places.clear();
    if (source == nullptr)
    {
        source = QGeoPositionInfoSource::createDefaultSource(0);
        if (source != nullptr)
        {
            qDebug() << source->sourceName();
            QObject::connect(source, &QGeoPositionInfoSource::positionUpdated,
                             this, &PlacesManager::positionUpdated);
            source->setUpdateInterval(0);
        }
    }
    if (source != nullptr)
    {
        source->startUpdates();
    }
}

void PlacesManager::simulate()
{
    positionUpdated(QGeoPositionInfo(QGeoCoordinate(53.1435668, 8.2171558), QDateTime::currentDateTime()));
}

void PlacesManager::handleReplyFinished(QNetworkReply *reply)
{
    jw78::Utils::log(__FILE__, __LINE__, "reply finished");
    if (reply->error() != QNetworkReply::NoError)
    {
        update();
        return;
    }
    QByteArray data(reply->readAll());
    QJsonDocument json(QJsonDocument::fromJson(data));
    if (json.isNull())
    {
        jw78::Utils::log(__FILE__, __LINE__, "isNull");
        setIsNull(true);
        setWaitingForPlaces(false);
        return;
    }
    setIsNull(false);
    if (json.isEmpty())
    {
        jw78::Utils::log(__FILE__, __LINE__, "isEmpty");
        setIsEmpty(true);
        setWaitingForPlaces(false);
        return;
    }
    setIsEmpty(false);
    QJsonObject overpass(json.object());
    QJsonArray elements(overpass["elements"].toArray());
    if (elements.size() == 0)
    {
        setNoElements(true);
        setWaitingForPlaces(false);
        return;
    }
    setNoElements(false);
    QSet<QString> inserted;
    for (int i(0); i < elements.size(); ++i)
    {
        QJsonObject obj(elements[i].toObject());
        QJsonObject tags(obj["tags"].toObject());
        QString name(tags["name"].toString());
        QString street(tags["addr:street"].toString());
        QString housenumber(tags["addr:housenumber"].toString());
        QString complex(name + "##" + street + "##" + housenumber);
        if (inserted.find(complex) == inserted.end())
        {
            inserted.insert(complex);
            Place *p(new Place);
            p->setName(name);
            p->setAdress(street + " " + housenumber);
            places.add(p);
        }
    }
    setWaitingForPlaces(false);
}

void PlacesManager::positionUpdated(const QGeoPositionInfo &update)
{
    places.clear();
    setWaitingForPlaces(true);
    if (source != nullptr)
    {
        source->stopUpdates();
    }
    QByteArray xmlRequest("<osm-script output=\"json\">"
            "<query type=\"nw\">"
              "<has-kv k=\"name\"/>"
              "<has-kv k=\"highway\" modv=\"not\" regv=\".\"/>"
            "<around lat=\"");
    xmlRequest += QString::number(update.coordinate().latitude()).toUtf8();
    xmlRequest += QByteArray("\" lon=\"");
    xmlRequest += QString::number(update.coordinate().longitude()).toUtf8();
    xmlRequest += QByteArray("\" radius=\"30\"/>"
            "</query>"
            "<print/>"
          "</osm-script>");
    QString url("https://overpass-api.de/api/interpreter");
    QNetworkRequest request(url);
    qthelper::setSSL(request);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    network.post(request, xmlRequest);
}
