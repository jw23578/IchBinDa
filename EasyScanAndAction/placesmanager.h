#ifndef PLACESMANAGER_H
#define PLACESMANAGER_H

#include <QQmlApplicationEngine>
#include "JW78QTLib/jw78ObjectListModel.h"
#include <QNetworkAccessManager>

class PlacesManager: public QObject
{
    Q_OBJECT
    jw78::ObjectListModel places;
    QNetworkAccessManager network;
    JWPROPERTY(bool, isNull, IsNull, true)
    JWPROPERTY(bool, isEmpty, IsEmpty, true)
    JWPROPERTY(bool, noElements, NoElements, true)
public:
    PlacesManager(QQmlApplicationEngine &engine);
    void update();

private slots:
    void handleReplyFinished(QNetworkReply *reply);
};

#endif // PLACESMANAGER_H
