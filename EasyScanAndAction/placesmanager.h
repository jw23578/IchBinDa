#ifndef PLACESMANAGER_H
#define PLACESMANAGER_H

#include <QQmlApplicationEngine>
#include "JW78QTLib/jw78ObjectListModel.h"
#include <QNetworkAccessManager>
#include <QGeoPositionInfoSource>

class PlacesManager: public QObject
{
    Q_OBJECT
    QGeoPositionInfoSource *source;
    jw78::ObjectListModel places;
    QNetworkAccessManager network;
    JWPROPERTY(bool, isNull, IsNull, true)
    JWPROPERTY(bool, isEmpty, IsEmpty, true)
    JWPROPERTY(bool, noElements, NoElements, true)
    JWPROPERTY(bool, waitingForPlaces, WaitingForPlaces, false)
public:
    PlacesManager(QQmlApplicationEngine &engine);
    Q_INVOKABLE void update();
    Q_INVOKABLE void simulate();

private slots:
    void handleReplyFinished(QNetworkReply *reply);
    void positionUpdated(const QGeoPositionInfo &update);
};

#endif // PLACESMANAGER_H
